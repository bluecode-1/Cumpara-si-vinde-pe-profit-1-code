package ro.profitnet.app.core.network.fake;

import android.content.res.AssetManager;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;

/** Fixtures packaged as debug assets by the {@code syncDebugApiFixtures} Gradle task. */
public final class AssetFixtureSource implements FixtureSource {

    private static final String DIRECTORY = "fixtures/";

    private final AssetManager assets;

    public AssetFixtureSource(AssetManager assets) {
        this.assets = assets;
    }

    @Override
    public String read(String fileName) throws IOException {
        try (InputStream in = assets.open(DIRECTORY + fileName)) {
            ByteArrayOutputStream out = new ByteArrayOutputStream();
            byte[] buffer = new byte[4096];
            int read;
            while ((read = in.read(buffer)) != -1) {
                out.write(buffer, 0, read);
            }
            return new String(out.toByteArray(), StandardCharsets.UTF_8);
        }
    }
}
