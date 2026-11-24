package ro.profitnet.app.core.network.di;

import java.util.Collections;
import java.util.Set;

import dagger.Module;
import dagger.Provides;
import dagger.hilt.InstallIn;
import dagger.hilt.components.SingletonComponent;
import okhttp3.Interceptor;

/** Release builds have no demo mode: every request goes to the real API. */
@Module
@InstallIn(SingletonComponent.class)
public final class DemoModule {

    private DemoModule() {
    }

    @Provides
    @DemoInterceptors
    static Set<Interceptor> provideDemoInterceptors() {
        return Collections.emptySet();
    }
}
