package ro.profitnet.app.feature.home.domain;

import ro.profitnet.app.core.common.Result;
import ro.profitnet.app.core.model.User;

/** Data for the provisional Home screen. Methods block; call them off the main thread. */
public interface HomeRepository {

    /** @return the display name saved on this device, or {@code null} if none. */
    String getCachedDisplayName();

    /** Loads the signed-in user from the server. */
    Result<User> getMe();

    /**
     * Signs out: revokes the session on the server (best effort) and always removes the local
     * session and onboarding state.
     */
    void logout();
}
