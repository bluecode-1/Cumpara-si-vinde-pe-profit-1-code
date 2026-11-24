package ro.profitnet.app.core.network.di;

import com.google.gson.Gson;

import java.util.Set;
import java.util.concurrent.TimeUnit;

import javax.inject.Singleton;

import dagger.Module;
import dagger.Provides;
import dagger.hilt.InstallIn;
import dagger.hilt.components.SingletonComponent;
import okhttp3.CertificatePinner;
import okhttp3.Interceptor;
import okhttp3.OkHttpClient;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;
import ro.profitnet.app.core.network.ApiCaller;
import ro.profitnet.app.core.network.AuthInterceptor;
import ro.profitnet.app.core.network.BuildConfig;
import ro.profitnet.app.core.network.CertificatePinnerFactory;
import ro.profitnet.app.core.network.LanguageInterceptor;
import ro.profitnet.app.core.network.ProblemJsonParser;
import ro.profitnet.app.core.network.TokenAuthenticator;
import ro.profitnet.app.core.network.api.AuthApi;
import ro.profitnet.app.core.network.api.CatalogApi;
import ro.profitnet.app.core.network.api.MeApi;
import ro.profitnet.app.core.security.SessionManager;

@Module
@InstallIn(SingletonComponent.class)
public final class NetworkModule {

    private static final long CONNECT_TIMEOUT_SECONDS = 15;
    private static final long READ_WRITE_TIMEOUT_SECONDS = 30;

    private NetworkModule() {
    }

    @Provides
    @Singleton
    static Gson provideGson() {
        return new Gson();
    }

    @Provides
    @Singleton
    static CertificatePinner provideCertificatePinner() {
        return CertificatePinnerFactory.create(
                BuildConfig.API_BASE_URL, BuildConfig.CERTIFICATE_PINS);
    }

    /** Base client: timeouts, pinning, language header and (debug only) the fake API. */
    @Provides
    @Singleton
    @RefreshClient
    static OkHttpClient provideRefreshOkHttpClient(CertificatePinner certificatePinner,
            @DemoInterceptors Set<Interceptor> demoInterceptors) {
        OkHttpClient.Builder builder = new OkHttpClient.Builder()
                .connectTimeout(CONNECT_TIMEOUT_SECONDS, TimeUnit.SECONDS)
                .readTimeout(READ_WRITE_TIMEOUT_SECONDS, TimeUnit.SECONDS)
                .writeTimeout(READ_WRITE_TIMEOUT_SECONDS, TimeUnit.SECONDS)
                .certificatePinner(certificatePinner)
                .addInterceptor(new LanguageInterceptor());
        for (Interceptor interceptor : demoInterceptors) {
            builder.addInterceptor(interceptor);
        }
        return builder.build();
    }

    @Provides
    @Singleton
    @RefreshClient
    static AuthApi provideRefreshAuthApi(@RefreshClient OkHttpClient client, Gson gson) {
        return buildRetrofit(client, gson).create(AuthApi.class);
    }

    /** Main client: shares the pool of the base client and adds authentication. */
    @Provides
    @Singleton
    static OkHttpClient provideOkHttpClient(@RefreshClient OkHttpClient baseClient,
            SessionManager sessionManager, @RefreshClient AuthApi refreshApi) {
        OkHttpClient.Builder builder = baseClient.newBuilder();
        // The auth interceptor must run before the fake API so that the fake sees the token.
        builder.interceptors().add(0, new AuthInterceptor(sessionManager));
        return builder
                .authenticator(new TokenAuthenticator(sessionManager, refreshApi))
                .build();
    }

    @Provides
    @Singleton
    static Retrofit provideRetrofit(OkHttpClient client, Gson gson) {
        return buildRetrofit(client, gson);
    }

    @Provides
    @Singleton
    static AuthApi provideAuthApi(Retrofit retrofit) {
        return retrofit.create(AuthApi.class);
    }

    @Provides
    @Singleton
    static MeApi provideMeApi(Retrofit retrofit) {
        return retrofit.create(MeApi.class);
    }

    @Provides
    @Singleton
    static CatalogApi provideCatalogApi(Retrofit retrofit) {
        return retrofit.create(CatalogApi.class);
    }

    @Provides
    @Singleton
    static ApiCaller provideApiCaller(Gson gson) {
        return new ApiCaller(new ProblemJsonParser(gson));
    }

    private static Retrofit buildRetrofit(OkHttpClient client, Gson gson) {
        return new Retrofit.Builder()
                .baseUrl(BuildConfig.API_BASE_URL)
                .client(client)
                .addConverterFactory(GsonConverterFactory.create(gson))
                .build();
    }
}
