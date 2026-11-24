import SwiftUI

// MARK: - Buttons

/// Filled, pill-shaped button for the main action of a screen.
public struct PNPrimaryButtonStyle: ButtonStyle {
    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        PNButtonLabel(configuration: configuration, isPrimary: true)
    }
}

/// Outlined, pill-shaped button for secondary actions.
public struct PNSecondaryButtonStyle: ButtonStyle {
    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        PNButtonLabel(configuration: configuration, isPrimary: false)
    }
}

private struct PNButtonLabel: View {
    let configuration: ButtonStyleConfiguration
    let isPrimary: Bool

    @Environment(\.isEnabled) private var isEnabled

    var body: some View {
        configuration.label
            .font(PNTextStyle.labelLarge.font)
            .multilineTextAlignment(.center)
            .foregroundStyle(foreground)
            .padding(.horizontal, PNSpacing.lg)
            .padding(.vertical, PNSpacing.sm)
            .frame(maxWidth: .infinity, minHeight: PNMetrics.minTouchTarget)
            .background(background, in: Capsule())
            .overlay(Capsule().strokeBorder(border, lineWidth: 1))
            .contentShape(Capsule())
            .opacity(configuration.isPressed ? 0.8 : 1)
    }

    private var foreground: Color {
        if !isEnabled {
            return PNColors.onSurface.opacity(0.38)
        }
        return isPrimary ? PNColors.onPrimary : PNColors.primary
    }

    private var background: Color {
        guard isPrimary else {
            return Color.clear
        }
        return isEnabled ? PNColors.primary : PNColors.onSurface.opacity(0.12)
    }

    private var border: Color {
        if isPrimary {
            return Color.clear
        }
        return isEnabled ? PNColors.outline : PNColors.onSurface.opacity(0.12)
    }
}

/// A primary or secondary button with an optional in-progress state.
/// While loading, the button is disabled and shows a spinner next to its title.
public struct PNButton: View {
    public enum Kind: Sendable {
        case primary
        case secondary
    }

    private let title: String
    private let kind: Kind
    private let isLoading: Bool
    private let action: () -> Void

    public init(
        _ title: String,
        kind: Kind = .primary,
        isLoading: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.kind = kind
        self.isLoading = isLoading
        self.action = action
    }

    public var body: some View {
        switch kind {
        case .primary:
            button.buttonStyle(PNPrimaryButtonStyle())
        case .secondary:
            button.buttonStyle(PNSecondaryButtonStyle())
        }
    }

    private var button: some View {
        Button(action: action) {
            HStack(spacing: PNSpacing.sm) {
                if isLoading {
                    ProgressView()
                        .accessibilityHidden(true)
                }
                Text(title)
            }
        }
        .disabled(isLoading)
    }
}

// MARK: - Fields

private struct PNFieldModifier: ViewModifier {
    let isError: Bool

    func body(content: Content) -> some View {
        content
            .font(PNTextStyle.bodyLarge.font)
            .foregroundStyle(PNColors.onSurface)
            .padding(.horizontal, PNSpacing.md)
            .padding(.vertical, PNSpacing.sm)
            .frame(minHeight: PNMetrics.minTouchTarget)
            .background(
                PNColors.surfaceContainer,
                in: RoundedRectangle(cornerRadius: PNRadius.small, style: .continuous)
            )
            .overlay(
                RoundedRectangle(cornerRadius: PNRadius.small, style: .continuous)
                    .strokeBorder(isError ? PNColors.error : PNColors.outlineVariant, lineWidth: 1)
            )
    }
}

public extension View {
    /// Styles a text field (or a row containing one) as a Livadă input.
    func pnFieldStyle(isError: Bool = false) -> some View {
        modifier(PNFieldModifier(isError: isError))
    }
}

// MARK: - Selection row

/// A full-width row with a checkbox, used for consents and multi-selection.
/// The whole row is the touch target (at least 44 pt high) and VoiceOver
/// reads it as a button with the selected trait.
public struct PNCheckboxRow: View {
    private let title: String
    @Binding private var isOn: Bool

    public init(_ title: String, isOn: Binding<Bool>) {
        self.title = title
        self._isOn = isOn
    }

    public var body: some View {
        Button {
            isOn.toggle()
        } label: {
            HStack(alignment: .center, spacing: PNSpacing.md) {
                Image(systemName: isOn ? "checkmark.square.fill" : "square")
                    .font(.title2)
                    .foregroundStyle(isOn ? PNColors.primary : PNColors.outline)
                    .accessibilityHidden(true)
                Text(title)
                    .font(PNTextStyle.bodyLarge.font)
                    .foregroundStyle(PNColors.onSurface)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.vertical, PNSpacing.sm)
            .frame(maxWidth: .infinity, minHeight: PNMetrics.minTouchTarget, alignment: .leading)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isOn ? [.isSelected] : [])
    }
}
