import Core
import Foundation

/// Builds and performs requests. Knows nothing about token refresh.
struct HTTPTransport: Sendable {
    let baseURL: URL
    let session: URLSession

    func perform(_ endpoint: Endpoint, accessToken: String?) async throws -> (Data, HTTPURLResponse) {
        let request = try makeRequest(endpoint, accessToken: accessToken)
        do {
            let (data, response) = try await session.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw AppError.unknown
            }
            return (data, httpResponse)
        } catch let error as AppError {
            throw error
        } catch is CancellationError {
            throw CancellationError()
        } catch let error as URLError {
            if error.code == .cancelled {
                throw CancellationError()
            }
            throw AppError.network
        } catch {
            // Any other failure of the URL loading system means the request
            // did not complete; the UI shows the connection message.
            throw AppError.network
        }
    }

    func makeRequest(_ endpoint: Endpoint, accessToken: String?) throws -> URLRequest {
        var base = baseURL.absoluteString
        while base.hasSuffix("/") {
            base.removeLast()
        }
        let path = endpoint.path.hasPrefix("/") ? endpoint.path : "/" + endpoint.path
        guard let url = URL(string: base + path) else {
            throw AppError.unknown
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.setValue("application/json, application/problem+json", forHTTPHeaderField: "Accept")
        request.setValue(Self.acceptLanguage, forHTTPHeaderField: "Accept-Language")
        if let body = endpoint.body {
            request.httpBody = body
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        if let accessToken {
            request.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        }
        return request
    }

    /// `en` when the user's preferred language is English, otherwise `ro`.
    private static var acceptLanguage: String {
        let preferred = Locale.preferredLanguages.first ?? "ro"
        return preferred.hasPrefix("en") ? "en" : "ro"
    }
}
