package ro.profitnet.app.core.network.di;

import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;

import javax.inject.Qualifier;

/**
 * Interceptors that answer requests locally instead of the real backend. The set is populated
 * only in debug builds (fake API, see {@code src/debug}); in release builds it is empty.
 */
@Qualifier
@Retention(RetentionPolicy.RUNTIME)
public @interface DemoInterceptors {
}
