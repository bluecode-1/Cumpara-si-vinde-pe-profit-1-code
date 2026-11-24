package ro.profitnet.app.core.network.di;

import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;

import javax.inject.Qualifier;

/** Marks the HTTP stack used only for token refresh (no auth interceptor, no authenticator). */
@Qualifier
@Retention(RetentionPolicy.RUNTIME)
public @interface RefreshClient {
}
