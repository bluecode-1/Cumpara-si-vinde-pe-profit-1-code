package ro.profitnet.app.feature.home.di;

import dagger.Binds;
import dagger.Module;
import dagger.hilt.InstallIn;
import dagger.hilt.android.components.ViewModelComponent;
import ro.profitnet.app.feature.home.data.HomeRepositoryImpl;
import ro.profitnet.app.feature.home.domain.HomeRepository;

@Module
@InstallIn(ViewModelComponent.class)
public abstract class HomeModule {

    @Binds
    abstract HomeRepository bindHomeRepository(HomeRepositoryImpl impl);
}
