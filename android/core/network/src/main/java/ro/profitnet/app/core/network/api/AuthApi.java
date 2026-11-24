package ro.profitnet.app.core.network.api;

import retrofit2.Call;
import retrofit2.http.Body;
import retrofit2.http.Headers;
import retrofit2.http.POST;
import ro.profitnet.app.core.network.AuthInterceptor;
import ro.profitnet.app.core.network.dto.AuthSessionDto;
import ro.profitnet.app.core.network.dto.OtpChallengeDto;
import ro.profitnet.app.core.network.dto.OtpRequestDto;
import ro.profitnet.app.core.network.dto.OtpVerifyRequestDto;
import ro.profitnet.app.core.network.dto.RefreshRequestDto;
import ro.profitnet.app.core.network.dto.TokenPairDto;

/** Auth endpoints. All but logout are public ({@code security: []} in the contract). */
public interface AuthApi {

    @Headers(AuthInterceptor.NO_AUTH_HEADER_LINE)
    @POST("auth/otp/request")
    Call<OtpChallengeDto> requestOtp(@Body OtpRequestDto body);

    @Headers(AuthInterceptor.NO_AUTH_HEADER_LINE)
    @POST("auth/otp/verify")
    Call<AuthSessionDto> verifyOtp(@Body OtpVerifyRequestDto body);

    @Headers(AuthInterceptor.NO_AUTH_HEADER_LINE)
    @POST("auth/refresh")
    Call<TokenPairDto> refresh(@Body RefreshRequestDto body);

    @POST("auth/logout")
    Call<Void> logout();
}
