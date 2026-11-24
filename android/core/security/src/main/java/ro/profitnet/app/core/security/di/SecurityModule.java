package ro.profitnet.app.core.security.di;

import android.content.Context;

import javax.inject.Singleton;

import dagger.Module;
import dagger.Provides;
import dagger.hilt.InstallIn;
import dagger.hilt.android.qualifiers.ApplicationContext;
import dagger.hilt.components.SingletonComponent;
import ro.profitnet.app.core.security.KeystoreTokenStore;
import ro.profitnet.app.core.security.SessionManager;
import ro.profitnet.app.core.security.TokenStore;

@Module
@InstallIn(SingletonComponent.class)
public final class SecurityModule {

    private SecurityModule() {
    }

    @Provides
    @Singleton
    static TokenStore provideTokenStore(@ApplicationContext Context context) {
        return new KeystoreTokenStore(context);
    }

    @Provides
    @Singleton
    static SessionManager provideSessionManager(TokenStore tokenStore) {
        return new SessionManager(tokenStore);
    }
}
