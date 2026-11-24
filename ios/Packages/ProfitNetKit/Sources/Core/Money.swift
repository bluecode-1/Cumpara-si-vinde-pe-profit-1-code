import Foundation

/// ISO 4217 currencies supported by the contract.
public enum Currency: String, Codable, Sendable, CaseIterable {
    case ron = "RON"
    case eur = "EUR"
}

/// A monetary amount in minor units (bani / euro cents).
public struct Money: Codable, Equatable, Hashable, Sendable {
    public let amountMinor: Int
    public let currency: Currency

    public init(amountMinor: Int, currency: Currency) {
        self.amountMinor = amountMinor
        self.currency = currency
    }
}
