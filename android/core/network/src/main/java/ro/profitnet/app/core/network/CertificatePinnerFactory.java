package ro.profitnet.app.core.network;

import androidx.annotation.Nullable;

import okhttp3.CertificatePinner;
import okhttp3.HttpUrl;

/**
 * Builds the OkHttp {@link CertificatePinner} from configuration.
 *
 * <p>Pins come from {@code BuildConfig.CERTIFICATE_PINS}: a comma-separated list of
 * {@code sha256/<base64>} values for the API host (always configure at least one backup pin).
 * While the list is empty — the production domain does not exist yet — pinning is disabled and
 * the platform's default trust evaluation applies.
 */
public final class CertificatePinnerFactory {

    private CertificatePinnerFactory() {
    }

    public static CertificatePinner create(String baseUrl, @Nullable String commaSeparatedPins) {
        if (commaSeparatedPins == null || commaSeparatedPins.trim().isEmpty()) {
            return CertificatePinner.DEFAULT;
        }
        HttpUrl url = HttpUrl.parse(baseUrl);
        if (url == null) {
            throw new IllegalArgumentException("Invalid API base URL: " + baseUrl);
        }
        CertificatePinner.Builder builder = new CertificatePinner.Builder();
        for (String pin : commaSeparatedPins.split(",")) {
            String trimmed = pin.trim();
            if (!trimmed.isEmpty()) {
                builder.add(url.host(), trimmed);
            }
        }
        return builder.build();
    }
}
