import Foundation

/// What the stub server answers to one request.
enum StubResponse {
    case http(status: Int, body: Data, contentType: String)
    case failure(URLError)

    static func json(_ status: Int, _ body: Data) -> StubResponse {
        .http(status: status, body: body, contentType: "application/json")
    }

    static func problem(_ status: Int, code: String) -> StubResponse {
        let body = Data(#"{"type":"about:blank","title":"t","status":\#(status),"code":"\#(code)"}"#.utf8)
        return .http(status: status, body: body, contentType: "application/problem+json")
    }

    static func empty(_ status: Int) -> StubResponse {
        .http(status: status, body: Data(), contentType: "application/json")
    }
}

/// A request as seen by the stub server.
struct RecordedRequest {
    let method: String
    let path: String
    let authorization: String?
    let body: Data?
}

/// `URLProtocol` that answers every request with a programmable handler and
/// records what it saw. Tests in one process run serially, so the shared
/// state is only protected against the URL loading threads.
final class StubURLProtocol: URLProtocol {
    typealias Handler = (RecordedRequest) -> StubResponse

    private static let lock = NSLock()
    private static var handler: Handler?
    private static var recorded: [RecordedRequest] = []

    static func setHandler(_ newHandler: @escaping Handler) {
        lock.lock()
        defer { lock.unlock() }
        handler = newHandler
        recorded = []
    }

    static func reset() {
        lock.lock()
        defer { lock.unlock() }
        handler = nil
        recorded = []
    }

    static var requests: [RecordedRequest] {
        lock.lock()
        defer { lock.unlock() }
        return recorded
    }

    static func requestCount(path: String) -> Int {
        requests.filter { $0.path == path }.count
    }

    private static func record(_ request: RecordedRequest) -> Handler? {
        lock.lock()
        defer { lock.unlock() }
        recorded.append(request)
        return handler
    }

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
        let recordedRequest = RecordedRequest(
            method: request.httpMethod ?? "GET",
            path: url.path,
            authorization: request.value(forHTTPHeaderField: "Authorization"),
            body: Self.bodyData(of: request)
        )
        guard let handler = Self.record(recordedRequest) else {
            client?.urlProtocol(self, didFailWithError: URLError(.resourceUnavailable))
            return
        }

        switch handler(recordedRequest) {
        case .failure(let error):
            client?.urlProtocol(self, didFailWithError: error)
        case .http(let status, let body, let contentType):
            guard let response = HTTPURLResponse(
                url: url,
                statusCode: status,
                httpVersion: "HTTP/1.1",
                headerFields: ["Content-Type": contentType]
            ) else {
                client?.urlProtocol(self, didFailWithError: URLError(.badServerResponse))
                return
            }
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            if !body.isEmpty {
                client?.urlProtocol(self, didLoad: body)
            }
            client?.urlProtocolDidFinishLoading(self)
        }
    }

    override func stopLoading() {}

    /// `URLSession` passes the body to a `URLProtocol` as a stream.
    private static func bodyData(of request: URLRequest) -> Data? {
        if let body = request.httpBody {
            return body
        }
        guard let stream = request.httpBodyStream else {
            return nil
        }
        stream.open()
        defer { stream.close() }

        var data = Data()
        var buffer = [UInt8](repeating: 0, count: 4096)
        while stream.hasBytesAvailable {
            let count = stream.read(&buffer, maxLength: buffer.count)
            if count <= 0 {
                break
            }
            data.append(contentsOf: buffer[0..<count])
        }
        return data
    }
}
