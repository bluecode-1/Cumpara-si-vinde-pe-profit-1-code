package ro.profitnet.app.core.model;

/** GDPR consent purposes. TERMS and PRIVACY are required to use the app; the rest are optional. */
public enum ConsentPurpose {
    TERMS,
    PRIVACY,
    MARKETING,
    ANALYTICS,
    LOCATION,
    AI_PHOTO_PROCESSING;

    public boolean isRequired() {
        return this == TERMS || this == PRIVACY;
    }
}
