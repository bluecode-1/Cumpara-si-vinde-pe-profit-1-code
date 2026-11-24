package ro.profitnet.app.feature.onboarding.ui.code;

/** A one-second countdown, abstracted so the view model can be tested without a Looper. */
public interface Countdown {

    interface Listener {
        /** Called about once per second and finally with {@code 0}. */
        void onTick(int secondsRemaining);
    }

    /** Starts counting down from {@code seconds}, replacing any countdown in progress. */
    void start(int seconds, Listener listener);

    void cancel();
}
