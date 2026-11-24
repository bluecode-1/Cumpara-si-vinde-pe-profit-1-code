#if DEBUG
import Foundation

/// Demo mode: an in-process API that answers with the files from
/// `api/fixtures` (docs/06-flux-onboarding.md §5). The enum is not called
/// `FakeAPI` so that it does not share its name with the module.
///
/// Everything in this module is compiled only in debug builds.
public enum DemoAPI {
    /// Launch argument that enables the fake API: `-FAKE_API 1`.
    public static let launchArgument = "-FAKE_API"
    /// Environment variable that enables the fake API: `FAKE_API=1`.
    public static let environmentKey = "FAKE_API"
    /// The only SMS code the fake API accepts.
    public static let validCode = "123456"

    /// Whether the process was launched with the fake API enabled.
    public static func isRequested(
        arguments: [String] = ProcessInfo.processInfo.arguments,
        environment: [String: String] = ProcessInfo.processInfo.environment
    ) -> Bool {
        if let index = arguments.firstIndex(of: launchArgument) {
            let valueIndex = arguments.index(after: index)
            if valueIndex < arguments.endIndex {
                let value = arguments[valueIndex]
                return value != "0" && value.lowercased() != "false" && value.lowercased() != "no"
            }
            return true
        }
        if let value = environment[environmentKey] {
            return value == "1" || value.lowercased() == "true" || value.lowercased() == "yes"
        }
        return false
    }

    /// Makes every request of sessions created from `configuration` go to
    /// the fake server instead of the network.
    public static func install(in configuration: URLSessionConfiguration) {
        var classes: [AnyClass] = [FakeAPIURLProtocol.self]
        classes.append(contentsOf: configuration.protocolClasses ?? [])
        configuration.protocolClasses = classes
    }

    /// Forgets all in-memory changes (profile, consents).
    public static func reset() {
        FakeAPIServer.shared.reset()
    }
}
#endif
