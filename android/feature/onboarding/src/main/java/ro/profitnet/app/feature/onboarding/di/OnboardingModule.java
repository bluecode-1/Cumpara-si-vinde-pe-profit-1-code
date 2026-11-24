package ro.profitnet.app.feature.onboarding.di;

import dagger.Binds;
import dagger.Module;
import dagger.Provides;
import dagger.hilt.InstallIn;
import dagger.hilt.android.components.ViewModelComponent;
import ro.profitnet.app.feature.onboarding.data.AndroidDeviceLocationProvider;
import ro.profitnet.app.feature.onboarding.data.AuthRepositoryImpl;
import ro.profitnet.app.feature.onboarding.data.OnboardingProgressRepositoryImpl;
import ro.profitnet.app.feature.onboarding.data.ProfileRepositoryImpl;
import ro.profitnet.app.feature.onboarding.domain.AuthRepository;
import ro.profitnet.app.feature.onboarding.domain.DeviceLocationProvider;
import ro.profitnet.app.feature.onboarding.domain.OnboardingProgressRepository;
import ro.profitnet.app.feature.onboarding.domain.ProfileRepository;
import ro.profitnet.app.feature.onboarding.ui.code.AndroidCountdown;
import ro.profitnet.app.feature.onboarding.ui.code.Countdown;

@Module
@InstallIn(ViewModelComponent.class)
public abstract class OnboardingModule {

    @Binds
    abstract AuthRepository bindAuthRepository(AuthRepositoryImpl impl);

    @Binds
    abstract ProfileRepository bindProfileRepository(ProfileRepositoryImpl impl);

    @Binds
    abstract OnboardingProgressRepository bindProgressRepository(
            OnboardingProgressRepositoryImpl impl);

    @Binds
    abstract DeviceLocationProvider bindDeviceLocationProvider(AndroidDeviceLocationProvider impl);

    @Provides
    static Countdown provideCountdown() {
        return new AndroidCountdown();
    }
}
