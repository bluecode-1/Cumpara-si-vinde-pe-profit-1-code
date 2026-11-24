import DesignSystem
import SwiftData
import SwiftUI

/// The app entry point. Builds the dependencies once and shows `RootView`.
@main
@MainActor
struct ProfitNetApp: App {
    @State private var appModel: AppModel

    init() {
        PNFonts.registerIfNeeded()
        let dependencies = AppDependencies.live()
        _appModel = State(initialValue: AppModel(dependencies: dependencies))
    }

    var body: some Scene {
        WindowGroup {
            RootView(appModel: appModel)
                .modelContainer(appModel.dependencies.modelContainer)
        }
    }
}
