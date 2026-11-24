package ro.profitnet.app.feature.onboarding.ui.code;

import android.os.CountDownTimer;

/** {@link Countdown} on the main thread's {@link CountDownTimer}. */
public final class AndroidCountdown implements Countdown {

    private static final long SECOND_MILLIS = 1000;

    private CountDownTimer timer;

    @Override
    public void start(int seconds, Listener listener) {
        cancel();
        if (seconds <= 0) {
            listener.onTick(0);
            return;
        }
        listener.onTick(seconds);
        timer = new CountDownTimer(seconds * SECOND_MILLIS, SECOND_MILLIS) {
            @Override
            public void onTick(long millisUntilFinished) {
                // Round up so the label never shows 0 while the timer is still running.
                listener.onTick((int) ((millisUntilFinished + SECOND_MILLIS - 1) / SECOND_MILLIS));
            }

            @Override
            public void onFinish() {
                listener.onTick(0);
            }
        };
        timer.start();
    }

    @Override
    public void cancel() {
        if (timer != null) {
            timer.cancel();
            timer = null;
        }
    }
}
