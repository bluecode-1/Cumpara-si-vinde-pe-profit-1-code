package ro.profitnet.app.feature.onboarding.domain;

import java.util.List;

import ro.profitnet.app.core.common.Result;
import ro.profitnet.app.core.model.Category;
import ro.profitnet.app.core.model.Consent;
import ro.profitnet.app.core.model.GeoPoint;
import ro.profitnet.app.core.model.User;

/** Profile data collected during onboarding. Methods block; call them off the main thread. */
public interface ProfileRepository {

    Result<Void> saveConsents(List<Consent> consents);

    Result<User> updateDisplayName(String displayName);

    Result<User> updateHomeLocation(GeoPoint location);

    /**
     * Marks onboarding as completed.
     *
     * @param interestCategoryIds chosen categories; empty when the user skipped the step.
     */
    Result<User> completeOnboarding(List<String> interestCategoryIds);

    Result<List<Category>> getCategories();
}
