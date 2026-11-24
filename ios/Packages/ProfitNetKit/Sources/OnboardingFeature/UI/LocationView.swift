import Core
import DesignSystem
import SwiftUI

/// Step 6: the home area, from the device location or from the city list.
@MainActor
struct LocationView: View {
    @Bindable var viewModel: LocationViewModel

    var body: some View {
        OnboardingScaffold(
            title: L10n.string(.locationTitle),
            subtitle: L10n.string(.locationSubtitle)
        ) {
            if viewModel.state.isSaving {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .accessibilityHidden(true)
            }
            ErrorMessageView(error: viewModel.state.error)
        } actions: {
            PNButton(L10n.string(.locationUseMine), isLoading: viewModel.state.isLocating) {
                Task { await viewModel.useMyLocation() }
            }
            .disabled(viewModel.state.isSaving)
            .accessibilityIdentifier(OnboardingID.locationUseMine)

            PNButton(L10n.string(.locationPickCity), kind: .secondary) {
                viewModel.showCityPicker()
            }
            .disabled(viewModel.state.isBusy)
            .accessibilityIdentifier(OnboardingID.locationPickCity)
        }
        .announcesError(viewModel.state.error)
        .sheet(isPresented: $viewModel.state.isCityPickerPresented) {
            cityPicker
        }
    }

    private var cityPicker: some View {
        NavigationStack {
            List {
                ForEach(Array(viewModel.cities.enumerated()), id: \.offset) { index, city in
                    Button {
                        Task { await viewModel.pickCity(city) }
                    } label: {
                        Text(verbatim: city.name)
                            .pnTextStyle(.bodyLarge)
                            .foregroundStyle(PNColors.onSurface)
                            .frame(
                                maxWidth: .infinity,
                                minHeight: PNMetrics.minTouchTarget,
                                alignment: .leading
                            )
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .accessibilityIdentifier(OnboardingID.locationCityPrefix + String(index))
                }
            }
            .navigationTitle(L10n.string(.locationPickCity))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
