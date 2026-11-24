package ro.profitnet.app.core.network;

import androidx.annotation.NonNull;

import java.io.IOException;
import java.util.Locale;

import okhttp3.Interceptor;
import okhttp3.Response;

/** Sends {@code Accept-Language: ro} (default) or {@code en}, the two languages of the API. */
public final class LanguageInterceptor implements Interceptor {

    private static final String ENGLISH = "en";
    private static final String ROMANIAN = "ro";

    @NonNull
    @Override
    public Response intercept(@NonNull Chain chain) throws IOException {
        String language = ENGLISH.equals(Locale.getDefault().getLanguage()) ? ENGLISH : ROMANIAN;
        return chain.proceed(chain.request().newBuilder()
                .header("Accept-Language", language)
                .build());
    }
}
