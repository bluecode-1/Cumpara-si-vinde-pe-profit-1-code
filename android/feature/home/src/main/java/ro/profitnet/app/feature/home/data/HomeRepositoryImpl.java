package ro.profitnet.app.feature.home.data;

import javax.inject.Inject;

import ro.profitnet.app.core.common.AppError;
import ro.profitnet.app.core.common.Result;
import ro.profitnet.app.core.database.onboarding.OnboardingProgressDao;
import ro.profitnet.app.core.database.onboarding.OnboardingProgressEntity;
import ro.profitnet.app.core.model.User;
import ro.profitnet.app.core.network.ApiCaller;
import ro.profitnet.app.core.network.api.AuthApi;
import ro.profitnet.app.core.network.api.MeApi;
import ro.profitnet.app.core.network.dto.MeDto;
import ro.profitnet.app.core.network.mapper.ModelMappers;
import ro.profitnet.app.core.security.SessionManager;
import ro.profitnet.app.feature.home.domain.HomeRepository;

public final class HomeRepositoryImpl implements HomeRepository {

    private final AuthApi authApi;
    private final MeApi meApi;
    private final ApiCaller apiCaller;
    private final SessionManager sessionManager;
    private final OnboardingProgressDao progressDao;

    @Inject
    public HomeRepositoryImpl(AuthApi authApi, MeApi meApi, ApiCaller apiCaller,
            SessionManager sessionManager, OnboardingProgressDao progressDao) {
        this.authApi = authApi;
        this.meApi = meApi;
        this.apiCaller = apiCaller;
        this.sessionManager = sessionManager;
        this.progressDao = progressDao;
    }

    @Override
    public String getCachedDisplayName() {
        OnboardingProgressEntity entity = progressDao.get();
        return entity == null ? null : entity.displayName;
    }

    @Override
    public Result<User> getMe() {
        Result<MeDto> result = apiCaller.execute(meApi.getMe());
        if (result.isFailure()) {
            return Result.failure(result.getError());
        }
        User user = ModelMappers.toUser(result.getValue());
        if (user == null) {
            return Result.failure(AppError.unknown(AppError.NO_HTTP_STATUS));
        }
        return Result.success(user);
    }

    @Override
    public void logout() {
        // Best effort: being offline must not keep the user signed in on this device.
        apiCaller.executeEmpty(authApi.logout());
        sessionManager.clear();
        progressDao.clear();
    }
}
