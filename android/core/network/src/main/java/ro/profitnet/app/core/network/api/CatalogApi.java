package ro.profitnet.app.core.network.api;

import java.util.List;

import retrofit2.Call;
import retrofit2.http.GET;
import retrofit2.http.Headers;
import ro.profitnet.app.core.network.AuthInterceptor;
import ro.profitnet.app.core.network.dto.CategoryDto;

/** Catalog endpoints (public). */
public interface CatalogApi {

    @Headers(AuthInterceptor.NO_AUTH_HEADER_LINE)
    @GET("categories")
    Call<List<CategoryDto>> listCategories();
}
