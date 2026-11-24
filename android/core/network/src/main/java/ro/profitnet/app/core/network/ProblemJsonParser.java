package ro.profitnet.app.core.network;

import androidx.annotation.Nullable;

import com.google.gson.Gson;
import com.google.gson.JsonParseException;

import ro.profitnet.app.core.common.AppError;
import ro.profitnet.app.core.network.dto.ProblemDto;

/**
 * Maps an error response to {@link AppError}. Only {@code code} and the HTTP status are kept:
 * the server's {@code title} / {@code detail} are never shown to the user.
 */
public final class ProblemJsonParser {

    private static final int HTTP_UNAUTHORIZED = 401;

    private final Gson gson;

    public ProblemJsonParser(Gson gson) {
        this.gson = gson;
    }

    public AppError parse(int httpStatus, @Nullable String body) {
        String code = null;
        if (body != null && !body.isEmpty()) {
            try {
                ProblemDto problem = gson.fromJson(body, ProblemDto.class);
                if (problem != null && problem.code != null && !problem.code.isEmpty()) {
                    code = problem.code;
                }
            } catch (JsonParseException ignored) {
                // Not a problem+json body (e.g. an HTML error page from a proxy).
            }
        }
        if (code == null) {
            code = httpStatus == HTTP_UNAUTHORIZED
                    ? AppError.CODE_UNAUTHORIZED
                    : AppError.CODE_UNKNOWN;
        }
        return new AppError(code, httpStatus);
    }
}
