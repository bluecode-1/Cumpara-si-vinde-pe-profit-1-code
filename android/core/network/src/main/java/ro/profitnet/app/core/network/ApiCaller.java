package ro.profitnet.app.core.network;

import com.google.gson.JsonParseException;
import com.google.gson.stream.MalformedJsonException;

import java.io.IOException;

import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.Response;
import ro.profitnet.app.core.common.AppError;
import ro.profitnet.app.core.common.Result;

/**
 * Runs a Retrofit call synchronously and converts every outcome to {@link Result}; nothing is
 * thrown. Callers are expected to be on a background executor.
 */
public final class ApiCaller {

    private final ProblemJsonParser problemJsonParser;

    public ApiCaller(ProblemJsonParser problemJsonParser) {
        this.problemJsonParser = problemJsonParser;
    }

    /** For endpoints that return a body; a missing body is reported as an error. */
    public <T> Result<T> execute(Call<T> call) {
        return run(call, true);
    }

    /** For endpoints that answer 204 (or whose body is not needed). */
    public Result<Void> executeEmpty(Call<Void> call) {
        return run(call, false);
    }

    private <T> Result<T> run(Call<T> call, boolean bodyRequired) {
        try {
            Response<T> response = call.execute();
            if (!response.isSuccessful()) {
                return Result.failure(toError(response));
            }
            T body = response.body();
            if (bodyRequired && body == null) {
                return Result.failure(AppError.unknown(response.code()));
            }
            return Result.success(body);
        } catch (MalformedJsonException | JsonParseException e) {
            // The server answered 2xx with a body that does not match the contract.
            return Result.failure(AppError.unknown(AppError.NO_HTTP_STATUS));
        } catch (IOException e) {
            return Result.failure(AppError.network());
        }
    }

    private AppError toError(Response<?> response) {
        String body = null;
        try (ResponseBody errorBody = response.errorBody()) {
            if (errorBody != null) {
                body = errorBody.string();
            }
        } catch (IOException ignored) {
            // Fall through with no body: the status alone decides the error.
        }
        return problemJsonParser.parse(response.code(), body);
    }
}
