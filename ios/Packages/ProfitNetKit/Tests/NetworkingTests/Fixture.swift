import Foundation
import XCTest

/// Loads the shared reference responses (copies of `api/fixtures`, kept in
/// sync by `ios/Scripts/sync-fixtures.sh`).
enum Fixture {
    static func data(_ name: String, file: StaticString = #filePath, line: UInt = #line) throws -> Data {
        guard let url = Bundle.module.url(
            forResource: name,
            withExtension: "json",
            subdirectory: "Fixtures"
        ) else {
            XCTFail("Missing fixture \(name).json", file: file, line: line)
            throw CocoaError(.fileNoSuchFile)
        }
        return try Data(contentsOf: url)
    }
}
