package ro.profitnet.app.core.network.api;

import java.util.List;

import retrofit2.Call;
import retrofit2.http.Body;
import retrofit2.http.GET;
import retrofit2.http.PATCH;
import retrofit2.http.PUT;
import ro.profitnet.app.core.network.dto.ConsentDto;
import ro.profitnet.app.core.network.dto.ConsentUpdateDto;
import ro.profitnet.app.core.network.dto.MeDto;
import ro.profitnet.app.core.network.dto.MeUpdateDto;

/** Endpoints for the signed-in user. */
public interface MeApi {

    @GET("me")
    Call<MeDto> getMe();

    @PATCH("me")
    Call<MeDto> updateMe(@Body MeUpdateDto body);

    @GET("me/consents")
    Call<List<ConsentDto>> listConsents();

    @PUT("me/consents")
    Call<Void> setConsents(@Body List<ConsentUpdateDto> body);
}
