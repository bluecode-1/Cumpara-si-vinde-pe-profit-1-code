package ro.profitnet.app.core.model;

import java.util.Objects;

/** Access + refresh token returned by sign-in and by token rotation. */
public final class TokenPair {

    private final String accessToken;
    private final String refreshToken;
    private final int expiresInSeconds;

    public TokenPair(String accessToken, String refreshToken, int expiresInSeconds) {
        this.accessToken = Objects.requireNonNull(accessToken, "accessToken");
        this.refreshToken = Objects.requireNonNull(refreshToken, "refreshToken");
        this.expiresInSeconds = expiresInSeconds;
    }

    public String getAccessToken() {
        return accessToken;
    }

    public String getRefreshToken() {
        return refreshToken;
    }

    public int getExpiresInSeconds() {
        return expiresInSeconds;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (!(o instanceof TokenPair)) {
            return false;
        }
        TokenPair other = (TokenPair) o;
        return expiresInSeconds == other.expiresInSeconds
                && accessToken.equals(other.accessToken)
                && refreshToken.equals(other.refreshToken);
    }

    @Override
    public int hashCode() {
        return Objects.hash(accessToken, refreshToken, expiresInSeconds);
    }

    /** Tokens are secrets: never include them in logs. */
    @Override
    public String toString() {
        return "TokenPair{expiresInSeconds=" + expiresInSeconds + '}';
    }
}
