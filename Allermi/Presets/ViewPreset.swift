/// View Preset
/// Created by Mercen on 2022/11/03.

import SwiftUI

// MARK: - View Extension
extension View {
    func endTextEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
    }
}

public let springAnimation: Animation = .spring(dampingFraction: 0.75, blendDuration: 0.5)

// MARK: - Transition Extension
extension AnyTransition {
    static var backslide: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .move(edge: .trailing),
            removal: .move(edge: .leading))
    }
}

// MARK: - Color Extension
extension Color {
    static let lightColor = Color("LightColor")
    static let grayColor = Color("GrayColor")
}

// MARK: - Button Style
extension Button {
    @ViewBuilder func scaleButton() -> some View {
        self
            .buttonStyle(ScaleButtonStyle())
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.8 : 1)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}
