package ro.profitnet.app.feature.onboarding.data;

import android.Manifest;
import android.content.Context;
import android.content.pm.PackageManager;
import android.location.Location;
import android.location.LocationManager;

import androidx.annotation.Nullable;
import androidx.annotation.RequiresPermission;
import androidx.core.content.ContextCompat;
import androidx.core.location.LocationManagerCompat;
import androidx.core.os.CancellationSignal;

import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicReference;

import javax.inject.Inject;

import dagger.hilt.android.qualifiers.ApplicationContext;
import ro.profitnet.app.core.common.AppError;
import ro.profitnet.app.core.common.Result;
import ro.profitnet.app.core.model.GeoPoint;
import ro.profitnet.app.feature.onboarding.domain.DeviceLocationProvider;
import ro.profitnet.app.feature.onboarding.domain.OnboardingErrors;

/**
 * Location through the platform {@link LocationManager} (no Google Play services dependency).
 * Only the approximate (coarse) permission is used, so the network provider is preferred and
 * the platform already fuzzes the result. A recent last-known fix is used when available;
 * otherwise a single fresh fix is requested with a timeout.
 */
public final class AndroidDeviceLocationProvider implements DeviceLocationProvider {

    private static final long FIX_TIMEOUT_SECONDS = 10;
    private static final long MAX_LAST_KNOWN_AGE_MILLIS = TimeUnit.MINUTES.toMillis(30);
    private static final String[] PROVIDERS = {
            LocationManager.NETWORK_PROVIDER,
            LocationManager.GPS_PROVIDER,
            LocationManager.PASSIVE_PROVIDER,
    };

    private final Context context;

    @Inject
    public AndroidDeviceLocationProvider(@ApplicationContext Context context) {
        this.context = context;
    }

    @Override
    public Result<GeoPoint> getCurrentLocation() {
        if (ContextCompat.checkSelfPermission(context, Manifest.permission.ACCESS_COARSE_LOCATION)
                != PackageManager.PERMISSION_GRANTED) {
            return unavailable();
        }
        LocationManager manager = ContextCompat.getSystemService(context, LocationManager.class);
        if (manager == null || !LocationManagerCompat.isLocationEnabled(manager)) {
            return unavailable();
        }
        try {
            Location location = recentLastKnown(manager);
            if (location == null) {
                location = requestFreshFix(manager);
            }
            if (location == null) {
                return unavailable();
            }
            return Result.success(new GeoPoint(location.getLatitude(), location.getLongitude()));
        } catch (SecurityException | IllegalArgumentException e) {
            // Permission revoked meanwhile, or a provider reported an impossible coordinate.
            return unavailable();
        }
    }

    @Nullable
    @RequiresPermission(Manifest.permission.ACCESS_COARSE_LOCATION)
    private Location recentLastKnown(LocationManager manager) {
        long now = System.currentTimeMillis();
        Location best = null;
        for (String provider : PROVIDERS) {
            if (!manager.getAllProviders().contains(provider)) {
                continue;
            }
            Location candidate = manager.getLastKnownLocation(provider);
            if (candidate == null || now - candidate.getTime() > MAX_LAST_KNOWN_AGE_MILLIS) {
                continue;
            }
            if (best == null || candidate.getTime() > best.getTime()) {
                best = candidate;
            }
        }
        return best;
    }

    @Nullable
    @RequiresPermission(Manifest.permission.ACCESS_COARSE_LOCATION)
    private Location requestFreshFix(LocationManager manager) {
        String provider = null;
        for (String candidate : PROVIDERS) {
            if (!LocationManager.PASSIVE_PROVIDER.equals(candidate)
                    && manager.getAllProviders().contains(candidate)
                    && manager.isProviderEnabled(candidate)) {
                provider = candidate;
                break;
            }
        }
        if (provider == null) {
            return null;
        }
        CountDownLatch done = new CountDownLatch(1);
        AtomicReference<Location> fix = new AtomicReference<>();
        CancellationSignal cancellation = new CancellationSignal();
        LocationManagerCompat.getCurrentLocation(manager, provider, cancellation, Runnable::run,
                location -> {
                    fix.set(location);
                    done.countDown();
                });
        try {
            if (!done.await(FIX_TIMEOUT_SECONDS, TimeUnit.SECONDS)) {
                cancellation.cancel();
            }
        } catch (InterruptedException e) {
            cancellation.cancel();
            Thread.currentThread().interrupt();
        }
        return fix.get();
    }

    private static Result<GeoPoint> unavailable() {
        return Result.failure(AppError.local(OnboardingErrors.LOCATION_UNAVAILABLE));
    }
}
