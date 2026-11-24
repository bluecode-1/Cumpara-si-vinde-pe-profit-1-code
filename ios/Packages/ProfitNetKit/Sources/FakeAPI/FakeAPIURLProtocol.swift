#if DEBUG
import Foundation

/// Routes every request of a session to `FakeAPIServer`.
final class FakeAPIURLProtocol: URLProtocol {
    /// The API version prefix of the base URL; removed before routing.
    private static let versionPrefix = "/v1"

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        guard let url = request.url else {
            client?.urlProtocol(self, didFailWithError: URLError(.badURL))
            return
        }

        var path = url.path
        if path.hasPrefix(Self.versionPrefix) {
            path = String(path.dropFirst(Self.versionPrefix.count))
        }

        let result = FakeAPIServer.shared.handle(
            method: (request.httpMethod ?? "GET").uppercased(),
            path: path,
            authorization: request.value(forHTTPHeaderField: "Authorization"),
            body: Self.bodyData(of: request)
        )

        var headers: [String: String] = [:]
        if let contentType = result.contentType {
            headers["Content-Type"] = contentType
        }
        guard let response = HTTPURLResponse(
            url: url,
            statusCode: result.status,
            httpVersion: "HTTP/1.1",
            headerFields: headers
        ) else {
            client?.urlProtocol(self, didFailWithError: URLError(.badServerResponse))
            return
        }

        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        if !result.body.isEmpty {
            client?.urlProtocol(self, didLoad: result.body)
        }
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {
        // Responses are delivered synchronously; nothing to cancel.
    }

    /// `URLSession` hands the body to a `URLProtocol` as a stream, so
    /// `httpBody` is usually nil here.
    static func bodyData(of request: URLRequest) -> Data? {
        if let body = request.httpBody {
            return body
        }
        guard let stream = request.httpBodyStream else {
            return nil
        }
        stream.open()
        defer { stream.close() }

        var data = Data()
        let bufferSize = 4096
        var buffer = [UInt8](repeating: 0, count: bufferSize)
        while stream.hasBytesAvailable {
            let count = stream.read(&buffer, maxLength: bufferSize)
            if count <= 0 {
                break
            }
            data.append(contentsOf: buffer[0..<count])
        }
        return data
    }
}
#endif
