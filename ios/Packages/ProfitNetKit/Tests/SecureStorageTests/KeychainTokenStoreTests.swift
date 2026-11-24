import Core
import SecureStorage
import Security
import XCTest

/// Round-trip tests against the real keychain.
///
/// Package tests run without a host app; on some simulator / toolchain
/// combinations such a process has no keychain access
/// (`errSecMissingEntitlement`). In that case the tests are skipped rather
/// than failed; the UI tests exercise the keychain inside the app.
final class KeychainTokenStoreTests: XCTestCase {
    private var store: KeychainTokenStore!

    override func setUpWithError() throws {
        try super.setUpWithError()
        store = KeychainTokenStore(
            service: "ro.profitnet.tests." + UUID().uuidString,
            account: "tokens"
        )
        do {
            try store.clear()
        } catch let error as KeychainError {
            throw XCTSkip("Keychain is not available in this test process (OSStatus \(error.status))")
        }
    }

    override func tearDownWithError() throws {
        try? store?.clear()
        store = nil
        try super.tearDownWithError()
    }

    private func saveOrSkip(_ tokens: TokenPair) throws {
        do {
            try store.save(tokens)
        } catch let error as KeychainError where error.status == errSecMissingEntitlement {
            throw XCTSkip("Keychain is not available in this test process (OSStatus \(error.status))")
        }
    }

    func testLoadReturnsNilWhenEmpty() throws {
        XCTAssertNil(try store.load())
    }

    func testSaveThenLoadRoundTrips() throws {
        let tokens = TokenPair(accessToken: "a", refreshToken: "r", expiresInSeconds: 900)
        try saveOrSkip(tokens)
        XCTAssertEqual(try store.load(), tokens)
    }

    func testSaveReplacesExistingTokens() throws {
        try saveOrSkip(TokenPair(accessToken: "a1", refreshToken: "r1", expiresInSeconds: 900))
        let newer = TokenPair(accessToken: "a2", refreshToken: "r2", expiresInSeconds: 600)
        try saveOrSkip(newer)
        XCTAssertEqual(try store.load(), newer)
    }

    func testClearRemovesTokens() throws {
        try saveOrSkip(TokenPair(accessToken: "a", refreshToken: "r", expiresInSeconds: 900))
        try store.clear()
        XCTAssertNil(try store.load())
    }

    func testClearOnEmptyStoreDoesNotThrow() throws {
        XCTAssertNoThrow(try store.clear())
    }
}
