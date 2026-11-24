import Foundation
import SwiftData

/// Builds the app's `ModelContainer`.
public enum PersistenceContainer {
    /// - Parameter inMemory: `true` for tests and as a fallback when the
    ///   on-disk store cannot be opened.
    public static func make(inMemory: Bool = false) throws -> ModelContainer {
        let schema = Schema([OnboardingProgressRecord.self])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: inMemory)
        return try ModelContainer(for: schema, configurations: [configuration])
    }
}
