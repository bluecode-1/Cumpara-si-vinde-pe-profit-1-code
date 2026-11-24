package ro.profitnet.app.core.database.onboarding;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.room.ColumnInfo;
import androidx.room.Entity;
import androidx.room.PrimaryKey;

/**
 * Single-row table with the local state of the onboarding flow, so the user comes back to the
 * step they left even after the process is killed.
 */
@Entity(tableName = "onboarding_progress")
public final class OnboardingProgressEntity {

    /** There is only ever one row. */
    public static final int SINGLE_ROW_ID = 0;

    @PrimaryKey
    @ColumnInfo(name = "id")
    public final int id;

    /** Name of the current step (see the onboarding feature's OnboardingStep). */
    @NonNull
    @ColumnInfo(name = "step")
    public final String step;

    /** Phone number in E.164, kept to prefill the phone screen. */
    @Nullable
    @ColumnInfo(name = "phone")
    public final String phone;

    /** Display name chosen during onboarding; used for the greeting before /me is loaded. */
    @Nullable
    @ColumnInfo(name = "display_name")
    public final String displayName;

    @ColumnInfo(name = "updated_at")
    public final long updatedAtMillis;

    public OnboardingProgressEntity(int id, @NonNull String step, @Nullable String phone,
            @Nullable String displayName, long updatedAtMillis) {
        this.id = id;
        this.step = step;
        this.phone = phone;
        this.displayName = displayName;
        this.updatedAtMillis = updatedAtMillis;
    }
}
