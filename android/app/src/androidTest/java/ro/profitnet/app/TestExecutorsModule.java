package ro.profitnet.app;

import android.content.Context;

import androidx.core.content.ContextCompat;
import androidx.test.espresso.idling.concurrent.IdlingThreadPoolExecutor;

import java.util.concurrent.Executors;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.TimeUnit;

import javax.inject.Singleton;

import dagger.Module;
import dagger.Provides;
import dagger.hilt.android.qualifiers.ApplicationContext;
import dagger.hilt.components.SingletonComponent;
import dagger.hilt.testing.TestInstallIn;
import ro.profitnet.app.core.common.AppExecutors;
import ro.profitnet.app.di.ExecutorsModule;

/**
 * Replaces the background executor with one Espresso can wait for (it registers itself as an
 * idling resource), so the tests need no sleeps.
 */
@Module
@TestInstallIn(components = SingletonComponent.class, replaces = ExecutorsModule.class)
public final class TestExecutorsModule {

    private TestExecutorsModule() {
    }

    @Provides
    @Singleton
    static AppExecutors provideAppExecutors(@ApplicationContext Context context) {
        IdlingThreadPoolExecutor io = new IdlingThreadPoolExecutor("profitnet-io", 4, 4,
                0L, TimeUnit.MILLISECONDS, new LinkedBlockingQueue<>(),
                Executors.defaultThreadFactory());
        return new AppExecutors(io, ContextCompat.getMainExecutor(context));
    }
}
