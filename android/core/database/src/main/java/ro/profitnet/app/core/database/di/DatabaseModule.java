package ro.profitnet.app.core.database.di;

import android.content.Context;

import androidx.room.Room;

import javax.inject.Singleton;

import dagger.Module;
import dagger.Provides;
import dagger.hilt.InstallIn;
import dagger.hilt.android.qualifiers.ApplicationContext;
import dagger.hilt.components.SingletonComponent;
import ro.profitnet.app.core.database.ProfitNetDatabase;
import ro.profitnet.app.core.database.onboarding.OnboardingProgressDao;

@Module
@InstallIn(SingletonComponent.class)
public final class DatabaseModule {

    private DatabaseModule() {
    }

    @Provides
    @Singleton
    static ProfitNetDatabase provideDatabase(@ApplicationContext Context context) {
        return Room.databaseBuilder(context, ProfitNetDatabase.class, ProfitNetDatabase.NAME)
                .build();
    }

    @Provides
    static OnboardingProgressDao provideOnboardingProgressDao(ProfitNetDatabase database) {
        return database.onboardingProgressDao();
    }
}
