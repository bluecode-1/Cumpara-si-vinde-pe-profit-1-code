package ro.profitnet.app.core.common;

import java.util.Objects;

/**
 * Wrapper for one-shot UI events (navigation, clearing a field) exposed through an observable
 * holder. The content is handed out once, so a re-delivered value (e.g. after rotation) is not
 * acted on twice.
 */
public final class Event<T> {

    private final T content;
    private boolean handled;

    public Event(T content) {
        this.content = Objects.requireNonNull(content, "content");
    }

    /** Returns the content the first time it is called and {@code null} afterwards. */
    public synchronized T getContentIfNotHandled() {
        if (handled) {
            return null;
        }
        handled = true;
        return content;
    }

    /** Returns the content without marking it handled. */
    public T peekContent() {
        return content;
    }
}
