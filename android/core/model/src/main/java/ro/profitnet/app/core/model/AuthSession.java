package ro.profitnet.app.core.model;

import java.util.Objects;

/** Result of a successful code verification: tokens plus the account. */
public final class AuthSession {

    private final TokenPair tokens;
    private final User user;
    private final boolean newUser;

    public AuthSession(TokenPair tokens, User user, boolean newUser) {
        this.tokens = Objects.requireNonNull(tokens, "tokens");
        this.user = Objects.requireNonNull(user, "user");
        this.newUser = newUser;
    }

    public TokenPair getTokens() {
        return tokens;
    }

    public User getUser() {
        return user;
    }

    public boolean isNewUser() {
        return newUser;
    }
}
