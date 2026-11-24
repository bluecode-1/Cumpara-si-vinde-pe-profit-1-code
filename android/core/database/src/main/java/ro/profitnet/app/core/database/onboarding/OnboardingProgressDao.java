package ro.profitnet.app.core.database.onboarding;

import androidx.annotation.Nullable;
import androidx.room.Dao;
import androidx.room.Insert;
import androidx.room.OnConflictStrategy;
import androidx.room.Query;

/** Blocking DAO: call it from a background executor. */
@Dao
public interface OnboardingProgressDao {

    @Nullable
    @Query("SELECT * FROM onboarding_progress WHERE id = 0")
    OnboardingProgressEntity get();

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    void upsert(OnboardingProgressEntity entity);

    @Query("DELETE FROM onboarding_progress")
    void clear();
}
