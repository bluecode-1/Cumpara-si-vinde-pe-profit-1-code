import CryptoKit
import Foundation
import Security

/// `URLSessionDelegate` that performs public-key pinning.
///
/// A pin is the Base64-encoded SHA-256 digest of a certificate's public key
/// in the external representation returned by `SecKeyCopyExternalRepresentation`
/// (PKCS#1 for RSA, ANSI X9.63 for EC). Note that this is not the same digest
/// as an SPKI pin (HPKP style); generate pins with `PinningDelegate.pin(for:)`.
///
/// With an empty pin set, pinning is disabled and the system's default trust
/// evaluation applies. That is the current configuration: real pins are added
/// once the production domain exists.
public final class PinningDelegate: NSObject, URLSessionDelegate, @unchecked Sendable {
    private let pinnedKeyHashes: Set<String>

    public init(pinnedKeyHashes: Set<String> = []) {
        self.pinnedKeyHashes = pinnedKeyHashes
        super.init()
    }

    public var isEnabled: Bool {
        !pinnedKeyHashes.isEmpty
    }

    public func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    ) {
        guard isEnabled,
              challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
              let trust = challenge.protectionSpace.serverTrust
        else {
            completionHandler(.performDefaultHandling, nil)
            return
        }

        // The chain must be valid for the system first; pinning is an
        // additional check, not a replacement.
        var evaluationError: CFError?
        guard SecTrustEvaluateWithError(trust, &evaluationError) else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }

        let certificates = (SecTrustCopyCertificateChain(trust) as? [SecCertificate]) ?? []
        for certificate in certificates {
            if let pin = Self.pin(for: certificate), pinnedKeyHashes.contains(pin) {
                completionHandler(.useCredential, URLCredential(trust: trust))
                return
            }
        }
        completionHandler(.cancelAuthenticationChallenge, nil)
    }

    /// The pin of a certificate's public key, or `nil` if it cannot be read.
    public static func pin(for certificate: SecCertificate) -> String? {
        guard let key = SecCertificateCopyKey(certificate),
              let keyData = SecKeyCopyExternalRepresentation(key, nil) as Data?
        else {
            return nil
        }
        return pin(forPublicKeyData: keyData)
    }

    /// Base64 of the SHA-256 digest of raw public key bytes.
    public static func pin(forPublicKeyData data: Data) -> String {
        Data(SHA256.hash(data: data)).base64EncodedString()
    }
}
