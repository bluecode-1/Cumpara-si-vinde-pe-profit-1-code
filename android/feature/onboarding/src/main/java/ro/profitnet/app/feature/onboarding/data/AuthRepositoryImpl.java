package ro.profitnet.app.feature.onboarding.data;

import javax.inject.Inject;

import ro.profitnet.app.core.common.AppError;
import ro.profitnet.app.core.common.Result;
import ro.profitnet.app.core.model.AuthSession;
import ro.profitnet.app.core.model.OtpChallenge;
import ro.profitnet.app.core.network.ApiCaller;
import ro.profitnet.app.core.network.api.AuthApi;
import ro.profitnet.app.core.network.dto.AuthSessionDto;
import ro.profitnet.app.core.network.dto.OtpChallengeDto;
import ro.profitnet.app.core.network.dto.OtpRequestDto;
import ro.profitnet.app.core.network.dto.OtpVerifyRequestDto;
import ro.profitnet.app.core.network.mapper.ModelMappers;
import ro.profitnet.app.core.security.SessionManager;
import ro.profitnet.app.feature.onboarding.domain.AuthRepository;

public final class AuthRepositoryImpl implements AuthRepository {

    private final AuthApi authApi;
    private final ApiCaller apiCaller;
    private final SessionManager sessionManager;

    @Inject
    public AuthRepositoryImpl(AuthApi authApi, ApiCaller apiCaller,
            SessionManager sessionManager) {
        this.authApi = authApi;
        this.apiCaller = apiCaller;
        this.sessionManager = sessionManager;
    }

    @Override
    public Result<OtpChallenge> requestOtp(String phone) {
        Result<OtpChallengeDto> result =
                apiCaller.execute(authApi.requestOtp(new OtpRequestDto(phone)));
        if (result.isFailure()) {
            return Result.failure(result.getError());
        }
        OtpChallenge challenge = ModelMappers.toOtpChallenge(result.getValue());
        if (challenge == null) {
            return Result.failure(AppError.unknown(AppError.NO_HTTP_STATUS));
        }
        return Result.success(challenge);
    }

    @Override
    public Result<AuthSession> verifyOtp(String challengeId, String code) {
        Result<AuthSessionDto> result =
                apiCaller.execute(authApi.verifyOtp(new OtpVerifyRequestDto(challengeId, code)));
        if (result.isFailure()) {
            return Result.failure(result.getError());
        }
        AuthSession session = ModelMappers.toAuthSession(result.getValue());
        if (session == null) {
            return Result.failure(AppError.unknown(AppError.NO_HTTP_STATUS));
        }
        sessionManager.saveTokens(session.getTokens().getAccessToken(),
                session.getTokens().getRefreshToken());
        return Result.success(session);
    }
}
