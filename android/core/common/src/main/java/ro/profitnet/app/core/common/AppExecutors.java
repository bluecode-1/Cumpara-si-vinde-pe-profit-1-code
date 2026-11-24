package ro.profitnet.app.core.common;

import java.util.Objects;
import java.util.concurrent.Executor;

/** Executors injected wherever work must leave the main thread; replaced in tests. */
public final class AppExecutors {

    private final Executor io;
    private final Executor main;

    public AppExecutors(Executor io, Executor main) {
        this.io = Objects.requireNonNull(io, "io");
        this.main = Objects.requireNonNull(main, "main");
    }

    /** Network, disk and database work. */
    public Executor io() {
        return io;
    }

    /** The UI thread. */
    public Executor main() {
        return main;
    }
}
