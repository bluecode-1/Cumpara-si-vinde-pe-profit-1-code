import Core
import Foundation
import SwiftData

/// Hides `ModelContext` behind a model actor. Callers only see the
/// `OnboardingProgress` value type from `Core`.
///
/// The `ModelActor` conformance is written by hand (it is exactly what the
/// `@ModelActor` macro expands to) so that the initialiser and the protocol
/// witnesses are explicitly `public` and usable from other modules.
public actor OnboardingProgressStore: ModelActor {
    public nonisolated let modelExecutor: any ModelExecutor
    public nonisolated let modelContainer: ModelContainer

    public init(modelContainer: ModelContainer) {
        let modelContext = ModelContext(modelContainer)
        self.modelExecutor = DefaultSerialModelExecutor(modelContext: modelContext)
        self.modelContainer = modelContainer
    }

    public func load() throws -> OnboardingProgress? {
        guard let record = try fetchRecords().first else {
            return nil
        }
        // An unknown step (written by a newer app version) restarts the flow.
        guard let step = OnboardingStep(rawValue: record.stepRawValue) else {
            return nil
        }
        return OnboardingProgress(step: step, phone: record.phone, displayName: record.displayName)
    }

    public func save(_ progress: OnboardingProgress) throws {
        let records = try fetchRecords()
        if let record = records.first {
            record.stepRawValue = progress.step.rawValue
            record.phone = progress.phone
            record.displayName = progress.displayName
            record.updatedAt = Date()
            for duplicate in records.dropFirst() {
                modelContext.delete(duplicate)
            }
        } else {
            let record = OnboardingProgressRecord(
                stepRawValue: progress.step.rawValue,
                phone: progress.phone,
                displayName: progress.displayName,
                updatedAt: Date()
            )
            modelContext.insert(record)
        }
        try modelContext.save()
    }

    public func clear() throws {
        for record in try fetchRecords() {
            modelContext.delete(record)
        }
        try modelContext.save()
    }

    private func fetchRecords() throws -> [OnboardingProgressRecord] {
        try modelContext.fetch(FetchDescriptor<OnboardingProgressRecord>())
    }
}
