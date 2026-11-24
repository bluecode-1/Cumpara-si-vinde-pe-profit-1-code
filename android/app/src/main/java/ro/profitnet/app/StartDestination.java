package ro.profitnet.app;

import androidx.annotation.Nullable;

import java.util.Objects;

/** Where the app opens, decided from the stored session and the saved onboarding progress. */
public final class StartDestination {

    /** The feature graph the app starts in. */
    public enum Graph {
        ONBOARDING,
        HOME
    }

    private final Graph graph;
    @Nullable
    private final String resumeDeepLink;

    private StartDestination(Graph graph, @Nullable String resumeDeepLink) {
        this.graph = graph;
        this.resumeDeepLink = resumeDeepLink;
    }

    /** No session: the flow starts at the welcome screen. */
    public static StartDestination onboarding() {
        return new StartDestination(Graph.ONBOARDING, null);
    }

    /** Session with unfinished onboarding: continue at the saved step. */
    public static StartDestination resumeOnboarding(String deepLink) {
        return new StartDestination(Graph.ONBOARDING, Objects.requireNonNull(deepLink));
    }

    public static StartDestination home() {
        return new StartDestination(Graph.HOME, null);
    }

    public Graph getGraph() {
        return graph;
    }

    /** In-app deep link of the onboarding step to resume, or {@code null}. */
    @Nullable
    public String getResumeDeepLink() {
        return resumeDeepLink;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (!(o instanceof StartDestination)) {
            return false;
        }
        StartDestination other = (StartDestination) o;
        return graph == other.graph && Objects.equals(resumeDeepLink, other.resumeDeepLink);
    }

    @Override
    public int hashCode() {
        return Objects.hash(graph, resumeDeepLink);
    }

    @Override
    public String toString() {
        return "StartDestination{" + graph + ", resume=" + resumeDeepLink + '}';
    }
}
