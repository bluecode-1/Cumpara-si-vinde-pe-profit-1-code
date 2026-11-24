package ro.profitnet.app.feature.onboarding.domain;

import java.util.Arrays;
import java.util.List;

import javax.inject.Inject;

import ro.profitnet.app.core.common.AppError;
import ro.profitnet.app.core.common.Result;
import ro.profitnet.app.core.model.Consent;
import ro.profitnet.app.core.model.ConsentPurpose;
import ro.profitnet.app.feature.onboarding.domain.model.ConsentSelection;
import ro.profitnet.app.feature.onboarding.domain.model.OnboardingStep;

/**
 * Sends the consent decisions, tied to the current policy version. Both required consents must
 * be granted; the optional ones are sent as chosen (including explicit refusals).
 */
public class SaveConsentsUseCase {

    /** Version of the Terms / Privacy policy the user is agreeing to. */
    public static final String POLICY_VERSION = "2026-11";

    private final ProfileRepository profileRepository;
    private final OnboardingProgressRepository progressRepository;

    @Inject
    public SaveConsentsUseCase(ProfileRepository profileRepository,
            OnboardingProgressRepository progressRepository) {
        this.profileRepository = profileRepository;
        this.progressRepository = progressRepository;
    }

    public Result<Void> execute(ConsentSelection selection) {
        if (!selection.hasRequired()) {
            return Result.failure(AppError.local(OnboardingErrors.CONSENTS_REQUIRED));
        }
        List<Consent> consents = Arrays.asList(
                decision(ConsentPurpose.TERMS, selection.isTerms()),
                decision(ConsentPurpose.PRIVACY, selection.isPrivacy()),
                decision(ConsentPurpose.MARKETING, selection.isMarketing()),
                decision(ConsentPurpose.ANALYTICS, selection.isAnalytics()),
                decision(ConsentPurpose.AI_PHOTO_PROCESSING, selection.isAiPhotoProcessing()));
        Result<Void> result = profileRepository.saveConsents(consents);
        if (result.isSuccess()) {
            progressRepository.save(progressRepository.load().withStep(OnboardingStep.NAME));
        }
        return result;
    }

    private static Consent decision(ConsentPurpose purpose, boolean granted) {
        return Consent.decision(purpose, granted, POLICY_VERSION);
    }
}
