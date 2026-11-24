package ro.profitnet.buildlogic

import javax.inject.Inject
import org.gradle.api.DefaultTask
import org.gradle.api.file.DirectoryProperty
import org.gradle.api.file.FileSystemOperations
import org.gradle.api.tasks.InputDirectory
import org.gradle.api.tasks.OutputDirectory
import org.gradle.api.tasks.PathSensitive
import org.gradle.api.tasks.PathSensitivity
import org.gradle.api.tasks.TaskAction

/**
 * Copies the shared API fixtures (repo-root {@code api/fixtures}) into a generated directory,
 * under a {@code fixtures/} sub-folder. The same files feed the debug-only fake API (as assets)
 * and the contract tests, so they are never duplicated by hand.
 */
abstract class SyncApiFixturesTask extends DefaultTask {

    @InputDirectory
    @PathSensitive(PathSensitivity.RELATIVE)
    abstract DirectoryProperty getFixturesDir()

    @OutputDirectory
    abstract DirectoryProperty getOutputDir()

    @Inject
    abstract FileSystemOperations getFileSystemOperations()

    @TaskAction
    void sync() {
        fileSystemOperations.sync { spec ->
            spec.from(fixturesDir) { it.include('*.json') }
            spec.into(outputDir.dir('fixtures'))
        }
    }
}
