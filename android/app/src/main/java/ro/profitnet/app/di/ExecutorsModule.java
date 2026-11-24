package ro.profitnet.app.di;

import android.content.Context;

import androidx.core.content.ContextCompat;

import java.util.concurrent.Executors;

import javax.inject.Singleton;

import dagger.Module;
import dagger.Provides;
import dagger.hilt.InstallIn;
import dagger.hilt.android.qualifiers.ApplicationContext;
import dagger.hilt.components.SingletonComponent;
import ro.profitnet.app.core.common.AppExecutors;

@Module
@InstallIn(SingletonComponent.class)
public final class ExecutorsModule {

    private static final int IO_THREADS = 4;

    private ExecutorsModule() {
    }

    @Provides
    @Singleton
    static AppExecutors provideAppExecutors(@ApplicationContext Context context) {
        return new AppExecutors(
                Executors.newFixedThreadPool(IO_THREADS),
                ContextCompat.getMainExecutor(context));
    }
}
