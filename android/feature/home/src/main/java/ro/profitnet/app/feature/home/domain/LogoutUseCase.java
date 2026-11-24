package ro.profitnet.app.feature.home.domain;

import javax.inject.Inject;

/** Signs the user out; the local session is cleared even if the server cannot be reached. */
public class LogoutUseCase {

    private final HomeRepository repository;

    @Inject
    public LogoutUseCase(HomeRepository repository) {
        this.repository = repository;
    }

    public void execute() {
        repository.logout();
    }
}
