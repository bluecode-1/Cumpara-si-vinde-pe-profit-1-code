package ro.profitnet.app.core.network.fake;

import java.io.IOException;

/** Reads a fixture from {@code api/fixtures} by file name (e.g. {@code me.new.200.json}). */
public interface FixtureSource {

    String read(String fileName) throws IOException;
}
