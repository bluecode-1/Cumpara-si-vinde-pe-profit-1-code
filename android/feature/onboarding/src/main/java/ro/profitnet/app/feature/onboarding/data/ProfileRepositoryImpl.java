package ro.profitnet.app.feature.onboarding.data;

import java.util.List;

import javax.inject.Inject;

import ro.profitnet.app.core.common.AppError;
import ro.profitnet.app.core.common.Result;
import ro.profitnet.app.core.model.Category;
import ro.profitnet.app.core.model.Consent;
import ro.profitnet.app.core.model.GeoPoint;
import ro.profitnet.app.core.model.User;
import ro.profitnet.app.core.network.ApiCaller;
import ro.profitnet.app.core.network.api.CatalogApi;
import ro.profitnet.app.core.network.api.MeApi;
import ro.profitnet.app.core.network.dto.MeDto;
import ro.profitnet.app.core.network.dto.MeUpdateDto;
import ro.profitnet.app.core.network.mapper.ModelMappers;
import ro.profitnet.app.feature.onboarding.domain.ProfileRepository;

public final class ProfileRepositoryImpl implements ProfileRepository {

    private final MeApi meApi;
    private final CatalogApi catalogApi;
    private final ApiCaller apiCaller;

    @Inject
    public ProfileRepositoryImpl(MeApi meApi, CatalogApi catalogApi, ApiCaller apiCaller) {
        this.meApi = meApi;
        this.catalogApi = catalogApi;
        this.apiCaller = apiCaller;
    }

    @Override
    public Result<Void> saveConsents(List<Consent> consents) {
        return apiCaller.executeEmpty(
                meApi.setConsents(ModelMappers.toConsentUpdates(consents)));
    }

    @Override
    public Result<User> updateDisplayName(String displayName) {
        MeUpdateDto update = new MeUpdateDto();
        update.displayName = displayName;
        return updateMe(update);
    }

    @Override
    public Result<User> updateHomeLocation(GeoPoint location) {
        MeUpdateDto update = new MeUpdateDto();
        update.homeLocation = ModelMappers.toDto(location);
        return updateMe(update);
    }

    @Override
    public Result<User> completeOnboarding(List<String> interestCategoryIds) {
        MeUpdateDto update = new MeUpdateDto();
        if (!interestCategoryIds.isEmpty()) {
            update.interestCategoryIds = interestCategoryIds;
        }
        update.onboardingCompleted = true;
        return updateMe(update);
    }

    @Override
    public Result<List<Category>> getCategories() {
        return apiCaller.execute(catalogApi.listCategories()).map(ModelMappers::toCategories);
    }

    private Result<User> updateMe(MeUpdateDto update) {
        Result<MeDto> result = apiCaller.execute(meApi.updateMe(update));
        if (result.isFailure()) {
            return Result.failure(result.getError());
        }
        User user = ModelMappers.toUser(result.getValue());
        if (user == null) {
            return Result.failure(AppError.unknown(AppError.NO_HTTP_STATUS));
        }
        return Result.success(user);
    }
}
