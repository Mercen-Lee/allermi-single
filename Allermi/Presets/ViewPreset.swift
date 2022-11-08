/// View Preset
/// Created by Mercen on 2022/11/03.

import SwiftUI

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
}
