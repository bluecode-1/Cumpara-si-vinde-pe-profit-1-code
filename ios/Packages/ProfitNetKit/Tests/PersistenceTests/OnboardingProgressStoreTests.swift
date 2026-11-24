import Core
import Persistence
import SwiftData
import XCTest

final class OnboardingProgressStoreTests: XCTestCase {
    private func makeStore() throws -> OnboardingProgressStore {
        let container = try PersistenceContainer.make(inMemory: true)
        return OnboardingProgressStore(modelContainer: container)
    }

    func testLoadReturnsNilWhenNothingWasSaved() async throws {
        let store = try makeStore()
        let progress = try await store.load()
        XCTAssertNil(progress)
    }

    func testSaveThenLoadRoundTrips() async throws {
        let store = try makeStore()
        let saved = OnboardingProgress(step: .name, phone: "+40712345678", displayName: "Ioana")

        try await store.save(saved)
        let loaded = try await store.load()

        XCTAssertEqual(loaded, saved)
    }

    func testSaveOverwritesThePreviousProgress() async throws {
        let store = try makeStore()

        try await store.save(OnboardingProgress(step: .phone, phone: "+40712345678"))
        try await store.save(OnboardingProgress(step: .location, phone: "+40712345678", displayName: "Ioana"))
        let loaded = try await store.load()

        XCTAssertEqual(loaded?.step, .location)
        XCTAssertEqual(loaded?.displayName, "Ioana")
    }

    func testClearRemovesTheProgress() async throws {
        let store = try makeStore()
        try await store.save(OnboardingProgress(step: .completed, displayName: "Ioana"))

        try await store.clear()
        let loaded = try await store.load()

        XCTAssertNil(loaded)
    }

    func testProgressSurvivesANewStoreOnTheSameContainer() async throws {
        // Simulates the app being killed: a new store (and context) reads
        // what the previous one saved.
        let container = try PersistenceContainer.make(inMemory: true)
        let first = OnboardingProgressStore(modelContainer: container)
        try await first.save(OnboardingProgress(step: .interests, phone: "+40712345678", displayName: "Ioana"))

        let second = OnboardingProgressStore(modelContainer: container)
        let loaded = try await second.load()

        XCTAssertEqual(loaded?.step, .interests)
    }

    func testEveryStepRoundTrips() async throws {
        let store = try makeStore()
        for step in OnboardingStep.allCases {
            try await store.save(OnboardingProgress(step: step))
            let loaded = try await store.load()
            XCTAssertEqual(loaded?.step, step)
        }
    }
}
