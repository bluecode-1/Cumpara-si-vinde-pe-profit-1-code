package ro.profitnet.app.core.common;

import java.util.Objects;
import java.util.function.Function;

/**
 * Outcome of an operation: either a value or an {@link AppError}. Immutable.
 *
 * @param <T> type of the success value; use {@link Void} (with a {@code null} value) for
 *            operations that return nothing.
 */
public final class Result<T> {

    private final T value;
    private final AppError error;

    private Result(T value, AppError error) {
        this.value = value;
        this.error = error;
    }

    public static <T> Result<T> success(T value) {
        return new Result<>(value, null);
    }

    public static <T> Result<T> failure(AppError error) {
        return new Result<>(null, Objects.requireNonNull(error, "error"));
    }

    public boolean isSuccess() {
        return error == null;
    }

    public boolean isFailure() {
        return error != null;
    }

    /** The success value; may be {@code null} for {@code Result<Void>}. */
    public T getValue() {
        if (error != null) {
            throw new IllegalStateException("Result is a failure: " + error);
        }
        return value;
    }

    public AppError getError() {
        if (error == null) {
            throw new IllegalStateException("Result is a success");
        }
        return error;
    }

    /** Transforms the success value; a failure is passed through unchanged. */
    public <R> Result<R> map(Function<? super T, ? extends R> mapper) {
        if (error != null) {
            return failure(error);
        }
        return success(mapper.apply(value));
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (!(o instanceof Result)) {
            return false;
        }
        Result<?> other = (Result<?>) o;
        return Objects.equals(value, other.value) && Objects.equals(error, other.error);
    }

    @Override
    public int hashCode() {
        return Objects.hash(value, error);
    }

    @Override
    public String toString() {
        return error == null ? "Success(" + value + ')' : "Failure(" + error + ')';
    }
}
