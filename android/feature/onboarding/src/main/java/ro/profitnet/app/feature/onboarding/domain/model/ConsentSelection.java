package ro.profitnet.app.feature.onboarding.domain.model;

/**
 * The choices on the consents screen. Optional consents default to "not granted": consent is
 * never assumed.
 */
public final class ConsentSelection {

    private final boolean terms;
    private final boolean privacy;
    private final boolean marketing;
    private final boolean analytics;
    private final boolean aiPhotoProcessing;

    public ConsentSelection(boolean terms, boolean privacy, boolean marketing, boolean analytics,
            boolean aiPhotoProcessing) {
        this.terms = terms;
        this.privacy = privacy;
        this.marketing = marketing;
        this.analytics = analytics;
        this.aiPhotoProcessing = aiPhotoProcessing;
    }

    public static ConsentSelection none() {
        return new ConsentSelection(false, false, false, false, false);
    }

    public boolean isTerms() {
        return terms;
    }

    public boolean isPrivacy() {
        return privacy;
    }

    public boolean isMarketing() {
        return marketing;
    }

    public boolean isAnalytics() {
        return analytics;
    }

    public boolean isAiPhotoProcessing() {
        return aiPhotoProcessing;
    }

    /** Terms and Privacy are both required to use the app. */
    public boolean hasRequired() {
        return terms && privacy;
    }

    public ConsentSelection withTerms(boolean value) {
        return new ConsentSelection(value, privacy, marketing, analytics, aiPhotoProcessing);
    }

    public ConsentSelection withPrivacy(boolean value) {
        return new ConsentSelection(terms, value, marketing, analytics, aiPhotoProcessing);
    }

    public ConsentSelection withMarketing(boolean value) {
        return new ConsentSelection(terms, privacy, value, analytics, aiPhotoProcessing);
    }

    public ConsentSelection withAnalytics(boolean value) {
        return new ConsentSelection(terms, privacy, marketing, value, aiPhotoProcessing);
    }

    public ConsentSelection withAiPhotoProcessing(boolean value) {
        return new ConsentSelection(terms, privacy, marketing, analytics, value);
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (!(o instanceof ConsentSelection)) {
            return false;
        }
        ConsentSelection other = (ConsentSelection) o;
        return terms == other.terms && privacy == other.privacy && marketing == other.marketing
                && analytics == other.analytics && aiPhotoProcessing == other.aiPhotoProcessing;
    }

    @Override
    public int hashCode() {
        return java.util.Objects.hash(terms, privacy, marketing, analytics, aiPhotoProcessing);
    }
}
