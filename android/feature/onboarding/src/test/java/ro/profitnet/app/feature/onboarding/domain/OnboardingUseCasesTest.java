package ro.profitnet.app.feature.onboarding.domain;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyList;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.inOrder;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.verifyNoInteractions;
import static org.mockito.Mockito.when;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;

import org.junit.Test;
import org.mockito.ArgumentCaptor;
import org.mockito.InOrder;

import ro.profitnet.app.core.common.AppError;
import ro.profitnet.app.core.common.Result;
import ro.profitnet.app.core.model.AuthSession;
import ro.profitnet.app.core.model.Category;
import ro.profitnet.app.core.model.Consent;
import ro.profitnet.app.core.model.ConsentPurpose;
import ro.profitnet.app.core.model.GeoPoint;
import ro.profitnet.app.core.model.OtpChallenge;
import ro.profitnet.app.core.model.TokenPair;
import ro.profitnet.app.core.model.User;
import ro.profitnet.app.feature.onboarding.domain.model.Cities;
import ro.profitnet.app.feature.onboarding.domain.model.ConsentSelection;
import ro.profitnet.app.feature.onboarding.domain.model.OnboardingProgress;
import ro.profitnet.app.feature.onboarding.domain.model.OnboardingStep;
import ro.profitnet.app.feature.onboarding.domain.model.OtpRequest;

public class OnboardingUseCasesTest {

    /** Keeps the last saved progress, like the Room-backed implementation. */
    private static final class InMemoryProgress implements OnboardingProgressRepository {
        OnboardingProgress progress = OnboardingProgress.initial();

        @Override
        public OnboardingProgress load() {
            return progress;
        }

        @Override
        public void save(OnboardingProgress newProgress) {
            progress = newProgress;
        }
    }

    private static final User USER = User.builder("user-1").build();

    private final AuthRepository authRepository = mock(AuthRepository.class);
    private final ProfileRepository profileRepository = mock(ProfileRepository.class);
    private final DeviceLocationProvider locationProvider = mock(DeviceLocationProvider.class);
    private final InMemoryProgress progress = new InMemoryProgress();

    // ----- phone -----

    @Test
    public void requestOtpSendsE164AndSavesProgress() {
        when(authRepository.requestOtp("+40712345678"))
                .thenReturn(Result.success(new OtpChallenge("c1", 30)));

        Result<OtpRequest> result =
                new RequestOtpUseCase(authRepository, progress).execute("0712 345 678");

        assertTrue(result.isSuccess());
        assertEquals("+40712345678", result.getValue().getPhone());
        assertEquals("c1", result.getValue().getChallenge().getChallengeId());
        assertEquals(OnboardingStep.CODE, progress.progress.getStep());
        assertEquals("+40712345678", progress.progress.getPhone());
    }

    @Test
    public void invalidPhoneFailsWithoutCallingTheServer() {
        Result<OtpRequest> result =
                new RequestOtpUseCase(authRepository, progress).execute("0212345678");

        assertEquals(OnboardingErrors.PHONE_INVALID, result.getError().getCode());
        verifyNoInteractions(authRepository);
        assertEquals(OnboardingProgress.initial(), progress.progress);
    }

    // ----- code -----

    @Test
    public void incompleteCodeIsRejectedLocally() {
        VerifyOtpUseCase useCase = new VerifyOtpUseCase(authRepository, progress);

        assertEquals(AppError.CODE_OTP_INVALID, useCase.execute("c1", "12345").getError().getCode());
        assertEquals(AppError.CODE_OTP_INVALID,
                useCase.execute("c1", "1234567").getError().getCode());
        assertEquals(AppError.CODE_OTP_INVALID, useCase.execute("c1", "12a456").getError().getCode());
        verifyNoInteractions(authRepository);
    }

    @Test
    public void verifiedNewUserMovesToConsents() {
        when(authRepository.verifyOtp("c1", "123456")).thenReturn(Result.success(
                new AuthSession(new TokenPair("a", "r", 900), USER, true)));

        assertTrue(new VerifyOtpUseCase(authRepository, progress).execute("c1", "123456")
                .isSuccess());

        assertEquals(OnboardingStep.CONSENTS, progress.progress.getStep());
    }

    @Test
    public void verifiedReturningUserIsCompleted() {
        User onboarded = User.builder("user-1").displayName("Ioana").onboardingCompleted(true)
                .build();
        when(authRepository.verifyOtp("c1", "123456")).thenReturn(Result.success(
                new AuthSession(new TokenPair("a", "r", 900), onboarded, false)));

        new VerifyOtpUseCase(authRepository, progress).execute("c1", "123456");

        assertEquals(OnboardingStep.COMPLETED, progress.progress.getStep());
        assertEquals("Ioana", progress.progress.getDisplayName());
    }

    @Test
    public void failedVerificationKeepsProgress() {
        when(authRepository.verifyOtp(anyString(), anyString())).thenReturn(
                Result.failure(new AppError(AppError.CODE_OTP_INVALID, 422)));

        new VerifyOtpUseCase(authRepository, progress).execute("c1", "000000");

        assertEquals(OnboardingProgress.initial(), progress.progress);
    }

    // ----- consents -----

    @Test
    public void consentsNeedBothRequiredOnes() {
        SaveConsentsUseCase useCase = new SaveConsentsUseCase(profileRepository, progress);

        Result<Void> result = useCase.execute(ConsentSelection.none().withTerms(true));

        assertEquals(OnboardingErrors.CONSENTS_REQUIRED, result.getError().getCode());
        verifyNoInteractions(profileRepository);
    }

    @Test
    @SuppressWarnings("unchecked")
    public void consentsAreSentWithPolicyVersionAndExplicitRefusals() {
        when(profileRepository.saveConsents(anyList())).thenReturn(Result.success(null));
        ConsentSelection selection = ConsentSelection.none().withTerms(true).withPrivacy(true)
                .withAnalytics(true);

        Result<Void> result =
                new SaveConsentsUseCase(profileRepository, progress).execute(selection);

        assertTrue(result.isSuccess());
        ArgumentCaptor<List<Consent>> captor = ArgumentCaptor.forClass(List.class);
        verify(profileRepository).saveConsents(captor.capture());
        assertEquals(Arrays.asList(
                Consent.decision(ConsentPurpose.TERMS, true, "2026-11"),
                Consent.decision(ConsentPurpose.PRIVACY, true, "2026-11"),
                Consent.decision(ConsentPurpose.MARKETING, false, "2026-11"),
                Consent.decision(ConsentPurpose.ANALYTICS, true, "2026-11"),
                Consent.decision(ConsentPurpose.AI_PHOTO_PROCESSING, false, "2026-11")),
                captor.getValue());
        assertEquals(OnboardingStep.NAME, progress.progress.getStep());
    }

    // ----- name -----

    @Test
    public void nameIsTrimmedValidatedAndSaved() {
        when(profileRepository.updateDisplayName("Ioana")).thenReturn(Result.success(USER));
        SaveDisplayNameUseCase useCase = new SaveDisplayNameUseCase(profileRepository, progress);

        assertEquals(OnboardingErrors.NAME_INVALID, useCase.execute(" I ").getError().getCode());
        verify(profileRepository, never()).updateDisplayName(anyString());

        assertTrue(useCase.execute("  Ioana ").isSuccess());
        assertEquals("Ioana", progress.progress.getDisplayName());
        assertEquals(OnboardingStep.LOCATION, progress.progress.getStep());
    }

    // ----- location -----

    @Test
    public void deviceLocationIsRoundedAndLocationConsentIsRecordedFirst() {
        when(locationProvider.getCurrentLocation())
                .thenReturn(Result.success(new GeoPoint(46.7712101, 23.6236353)));
        when(profileRepository.saveConsents(anyList())).thenReturn(Result.success(null));
        when(profileRepository.updateHomeLocation(any())).thenReturn(Result.success(USER));

        Result<Void> result = new SaveHomeLocationUseCase(profileRepository, locationProvider,
                progress).fromDeviceLocation();

        assertTrue(result.isSuccess());
        InOrder order = inOrder(profileRepository);
        order.verify(profileRepository).saveConsents(Collections.singletonList(
                Consent.decision(ConsentPurpose.LOCATION, true, "2026-11")));
        order.verify(profileRepository).updateHomeLocation(new GeoPoint(46.77, 23.62));
        assertEquals(OnboardingStep.INTERESTS, progress.progress.getStep());
    }

    @Test
    public void unavailableDeviceLocationSendsNothing() {
        when(locationProvider.getCurrentLocation()).thenReturn(
                Result.failure(AppError.local(OnboardingErrors.LOCATION_UNAVAILABLE)));

        Result<Void> result = new SaveHomeLocationUseCase(profileRepository, locationProvider,
                progress).fromDeviceLocation();

        assertEquals(OnboardingErrors.LOCATION_UNAVAILABLE, result.getError().getCode());
        verifyNoInteractions(profileRepository);
    }

    @Test
    public void manualCityDoesNotRecordLocationConsent() {
        when(profileRepository.updateHomeLocation(any())).thenReturn(Result.success(USER));

        Result<Void> result = new SaveHomeLocationUseCase(profileRepository, locationProvider,
                progress).fromCity(Cities.ALL.get(1));

        assertTrue(result.isSuccess());
        verify(profileRepository).updateHomeLocation(new GeoPoint(46.77, 23.6));
        verify(profileRepository, never()).saveConsents(anyList());
        verifyNoInteractions(locationProvider);
    }

    @Test
    public void cityListMatchesTheSpec() {
        assertEquals(10, Cities.ALL.size());
        assertEquals("București", Cities.ALL.get(0).getName());
        assertEquals(new GeoPoint(44.43, 26.10), Cities.ALL.get(0).getLocation());
        assertEquals("Sibiu", Cities.ALL.get(9).getName());
        assertEquals(new GeoPoint(45.80, 24.15), Cities.ALL.get(9).getLocation());
    }

    // ----- interests -----

    @Test
    public void onlyTopLevelCategoriesAreOffered() {
        when(profileRepository.getCategories()).thenReturn(Result.success(Arrays.asList(
                new Category("1", null, "haine", "Haine", null, false),
                new Category("2", "1", "rochii", "Rochii", null, false),
                new Category("3", null, "carti", "Cărți", null, false))));

        List<Category> categories =
                new GetInterestCategoriesUseCase(profileRepository).execute().getValue();

        assertEquals(2, categories.size());
        assertEquals("3", categories.get(1).getId());
    }

    @Test
    public void completingSavesInterestsAndMarksCompleted() {
        when(profileRepository.completeOnboarding(anyList())).thenReturn(Result.success(USER));

        Result<Void> result = new CompleteOnboardingUseCase(profileRepository, progress)
                .execute(Arrays.asList("1", "3"));

        assertTrue(result.isSuccess());
        verify(profileRepository).completeOnboarding(Arrays.asList("1", "3"));
        assertEquals(OnboardingStep.COMPLETED, progress.progress.getStep());
    }

    @Test
    public void failedCompletionKeepsTheStep() {
        when(profileRepository.completeOnboarding(anyList()))
                .thenReturn(Result.failure(AppError.network()));
        progress.progress = OnboardingProgress.initial().withStep(OnboardingStep.INTERESTS);

        Result<Void> result = new CompleteOnboardingUseCase(profileRepository, progress)
                .execute(Collections.emptyList());

        assertFalse(result.isSuccess());
        assertEquals(OnboardingStep.INTERESTS, progress.progress.getStep());
    }
}
