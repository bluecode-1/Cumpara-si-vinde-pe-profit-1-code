import Core
import Foundation

/// Secure storage for the session tokens. Implemented by the keychain store.
public protocol TokenStore: Sendable {
    func load() throws -> TokenPair?
    func save(_ tokens: TokenPair) throws
    func clear() throws
}

/// A token store that keeps tokens in memory. Used by tests and previews.
public final class InMemoryTokenStore: TokenStore, @unchecked Sendable {
    private let lock = NSLock()
    private var tokens: TokenPair?

    public init(tokens: TokenPair? = nil) {
        self.tokens = tokens
    }

    public func load() throws -> TokenPair? {
        lock.lock()
        defer { lock.unlock() }
        return tokens
    }

    public func save(_ tokens: TokenPair) throws {
        lock.lock()
        defer { lock.unlock() }
        self.tokens = tokens
    }

    public func clear() throws {
        lock.lock()
        defer { lock.unlock() }
        tokens = nil
    }
}
