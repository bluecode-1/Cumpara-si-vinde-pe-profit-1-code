package ro.profitnet.app.feature.onboarding.data;

import javax.inject.Inject;

import ro.profitnet.app.core.database.onboarding.OnboardingProgressDao;
import ro.profitnet.app.core.database.onboarding.OnboardingProgressEntity;
import ro.profitnet.app.feature.onboarding.domain.OnboardingProgressRepository;
import ro.profitnet.app.feature.onboarding.domain.model.OnboardingProgress;
import ro.profitnet.app.feature.onboarding.domain.model.OnboardingStep;

/** Room-backed progress, so the flow resumes after the process is killed. */
public final class OnboardingProgressRepositoryImpl implements OnboardingProgressRepository {

    private final OnboardingProgressDao dao;

    @Inject
    public OnboardingProgressRepositoryImpl(OnboardingProgressDao dao) {
        this.dao = dao;
    }

    @Override
    public OnboardingProgress load() {
        OnboardingProgressEntity entity = dao.get();
        if (entity == null) {
            return OnboardingProgress.initial();
        }
        return new OnboardingProgress(OnboardingStep.fromName(entity.step), entity.phone,
                entity.displayName);
    }

    @Override
    public void save(OnboardingProgress progress) {
        dao.upsert(new OnboardingProgressEntity(
                OnboardingProgressEntity.SINGLE_ROW_ID,
                progress.getStep().name(),
                progress.getPhone(),
                progress.getDisplayName(),
                System.currentTimeMillis()));
    }
}
