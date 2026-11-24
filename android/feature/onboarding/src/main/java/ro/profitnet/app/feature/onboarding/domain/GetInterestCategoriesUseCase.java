package ro.profitnet.app.feature.onboarding.domain;

import java.util.ArrayList;
import java.util.List;

import javax.inject.Inject;

import ro.profitnet.app.core.common.Result;
import ro.profitnet.app.core.model.Category;

/** Loads the top-level categories offered as interests. */
public class GetInterestCategoriesUseCase {

    private final ProfileRepository profileRepository;

    @Inject
    public GetInterestCategoriesUseCase(ProfileRepository profileRepository) {
        this.profileRepository = profileRepository;
    }

    public Result<List<Category>> execute() {
        return profileRepository.getCategories().map(all -> {
            List<Category> topLevel = new ArrayList<>();
            for (Category category : all) {
                if (category.isTopLevel()) {
                    topLevel.add(category);
                }
            }
            return topLevel;
        });
    }
}
