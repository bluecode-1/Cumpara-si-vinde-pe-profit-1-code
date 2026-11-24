import Core
import Networking
import XCTest

final class ProblemDecoderTests: XCTestCase {
    func testUsesCodeFromBodyAndStatusFromResponse() {
        let body = Data(
            """
            {"type":"about:blank","title":"t","status":400,"detail":"must not be shown","code":"SOME_CODE"}
            """.utf8
        )
        // The HTTP status wins over the `status` member of the body.
        XCTAssertEqual(ProblemDecoder.error(from: body, status: 409), AppError(code: "SOME_CODE", status: 409))
    }

    func testEmptyBodyFallsBackToUnknown() {
        XCTAssertEqual(
            ProblemDecoder.error(from: Data(), status: 500),
            AppError(code: AppError.Code.unknown, status: 500)
        )
    }

    func testNonJSONBodyFallsBackToUnknown() {
        XCTAssertEqual(
            ProblemDecoder.error(from: Data("<html>Bad gateway</html>".utf8), status: 502),
            AppError(code: AppError.Code.unknown, status: 502)
        )
    }

    func testMissingOrEmptyCodeFallsBackByStatus() {
        let noCode = Data(#"{"type":"about:blank","title":"t","status":429}"#.utf8)
        XCTAssertEqual(
            ProblemDecoder.error(from: noCode, status: 429),
            AppError(code: AppError.Code.rateLimited, status: 429)
        )
        let emptyCode = Data(#"{"code":""}"#.utf8)
        XCTAssertEqual(
            ProblemDecoder.error(from: emptyCode, status: 401),
            AppError(code: AppError.Code.unauthorized, status: 401)
        )
    }
}
