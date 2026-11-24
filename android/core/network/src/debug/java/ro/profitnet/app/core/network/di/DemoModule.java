package ro.profitnet.app.core.network.di;

import android.content.Context;

import java.util.Collections;
import java.util.Set;

import javax.inject.Singleton;

import dagger.Module;
import dagger.Provides;
import dagger.hilt.InstallIn;
import dagger.hilt.android.qualifiers.ApplicationContext;
import dagger.hilt.components.SingletonComponent;
import okhttp3.Interceptor;
import ro.profitnet.app.core.network.fake.AssetFixtureSource;
import ro.profitnet.app.core.network.fake.FakeApiInterceptor;

/**
 * Debug builds run in demo mode: the backend is not implemented yet, so every request is
 * answered by {@link FakeApiInterceptor}. The release variant of this module (src/release)
 * provides an empty set, and the fake is not compiled into release builds at all.
 */
@Module
@InstallIn(SingletonComponent.class)
public final class DemoModule {

    private static final long FAKE_LATENCY_MILLIS = 300;

    private DemoModule() {
    }

    @Provides
    @Singleton
    @DemoInterceptors
    static Set<Interceptor> provideDemoInterceptors(@ApplicationContext Context context) {
        return Collections.singleton(new FakeApiInterceptor(
                new AssetFixtureSource(context.getAssets()), FAKE_LATENCY_MILLIS));
    }
}
