import Core
import Foundation
import Networking
import Security

/// A failure reported by the Security framework.
public struct KeychainError: Error, Equatable, Sendable {
    public let status: OSStatus

    public init(status: OSStatus) {
        self.status = status
    }
}

/// Stores the token pair as one generic-password keychain item.
///
/// The item is accessible after the first unlock and never leaves this
/// device (`kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly`), so it is not
/// included in backups or iCloud Keychain.
public final class KeychainTokenStore: TokenStore, @unchecked Sendable {
    private let service: String
    private let account: String

    public init(service: String = "ro.profitnet.app.session", account: String = "tokens") {
        self.service = service
        self.account = account
    }

    public func load() throws -> TokenPair? {
        var query = baseQuery()
        query[kSecReturnData as String] = true
        query[kSecMatchLimit as String] = kSecMatchLimitOne

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        if status == errSecItemNotFound {
            return nil
        }
        guard status == errSecSuccess else {
            throw KeychainError(status: status)
        }
        guard let data = item as? Data else {
            return nil
        }
        // An item that cannot be decoded (for example after a format change)
        // is treated as "no session".
        return try? JSONDecoder().decode(TokenPair.self, from: data)
    }

    public func save(_ tokens: TokenPair) throws {
        let data = try JSONEncoder().encode(tokens)

        let attributesToUpdate: [String: Any] = [
            kSecValueData as String: data,
        ]
        let updateStatus = SecItemUpdate(
            baseQuery() as CFDictionary,
            attributesToUpdate as CFDictionary
        )
        if updateStatus == errSecSuccess {
            return
        }
        guard updateStatus == errSecItemNotFound else {
            throw KeychainError(status: updateStatus)
        }

        var attributes = baseQuery()
        attributes[kSecValueData as String] = data
        attributes[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        let addStatus = SecItemAdd(attributes as CFDictionary, nil)
        guard addStatus == errSecSuccess else {
            throw KeychainError(status: addStatus)
        }
    }

    public func clear() throws {
        let status = SecItemDelete(baseQuery() as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError(status: status)
        }
    }

    private func baseQuery() -> [String: Any] {
        [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
        ]
    }
}
