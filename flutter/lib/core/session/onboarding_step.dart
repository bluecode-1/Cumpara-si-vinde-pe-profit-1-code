/// The onboarding steps that follow phone verification, in order. The
/// current one is persisted so the flow resumes after the app is killed.
enum OnboardingStep { consents, name, location, interests }
