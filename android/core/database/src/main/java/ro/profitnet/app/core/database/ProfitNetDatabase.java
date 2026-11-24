package ro.profitnet.app.core.database;

import androidx.room.Database;
import androidx.room.RoomDatabase;

import ro.profitnet.app.core.database.onboarding.OnboardingProgressDao;
import ro.profitnet.app.core.database.onboarding.OnboardingProgressEntity;

/** The app's local database. Bump the version and add a migration for every schema change. */
@Database(entities = {OnboardingProgressEntity.class}, version = 1)
public abstract class ProfitNetDatabase extends RoomDatabase {

    public static final String NAME = "profitnet.db";

    public abstract OnboardingProgressDao onboardingProgressDao();
}
