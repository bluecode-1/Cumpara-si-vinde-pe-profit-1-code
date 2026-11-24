package ro.profitnet.app.feature.home.domain;

import javax.inject.Inject;

import ro.profitnet.app.core.common.Result;
import ro.profitnet.app.core.model.User;

/**
 * Name for the greeting: the one saved on this device during onboarding, otherwise the one on
 * the server. Empty if neither is available (e.g. offline right after signing in).
 */
public class GetDisplayNameUseCase {

    private final HomeRepository repository;

    @Inject
    public GetDisplayNameUseCase(HomeRepository repository) {
        this.repository = repository;
    }

    public String execute() {
        String cached = repository.getCachedDisplayName();
        if (cached != null && !cached.trim().isEmpty()) {
            return cached;
        }
        Result<User> me = repository.getMe();
        return me.isSuccess() ? me.getValue().getDisplayName() : "";
    }
}
