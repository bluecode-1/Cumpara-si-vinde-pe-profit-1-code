package ro.profitnet.app.core.network;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

/**
 * Test access to the shared API fixtures. The directory is a generated copy of the repo's
 * {@code api/fixtures}, produced by the {@code syncTestApiFixtures} Gradle task and passed in
 * through the {@code profitnet.fixturesDir} system property.
 */
public final class Fixtures {

    private Fixtures() {
    }

    public static Path directory() {
        String dir = System.getProperty("profitnet.fixturesDir");
        if (dir == null) {
            throw new IllegalStateException(
                    "profitnet.fixturesDir is not set; run the tests through Gradle");
        }
        return Paths.get(dir);
    }

    public static String read(String fileName) throws IOException {
        return new String(Files.readAllBytes(directory().resolve(fileName)),
                StandardCharsets.UTF_8);
    }
}
