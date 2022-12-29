/// View Preset
/// Created by Mercen on 2022/11/03.

import SwiftUI
import SlideOverCard

// MARK: - View Extension
extension View {
    func endTextEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
    }
    
    @ViewBuilder func customContainer(_ background: Color = .grayColor) -> some View {
        HStack {
            self
            Spacer()
        }
            .padding(15)
            .frame(maxWidth: .infinity)
            .background(background)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .padding([.top, .leading, .trailing], 15)
    }
    
    @ViewBuilder func customModal(_ information: Binding<Bool>) -> some View {
        self
            .slideOverCard(isPresented: information,
                           options: [.hideDismissButton],
                           style:
                            SOCStyle(innerPadding: 10,
                                     outerPadding: { () -> CGFloat in
                let width = UIScreen.main.bounds.size.width
                return width >= 500 ? 30 : 10
            }(),
                                     style: .halfGrayColor as Color)) {
                VStack(spacing: 5) {
                    HStack {
                        Spacer()
                        
                        /// Exit Button
                        Button(action: {
                            touch()
                            SOCManager.dismiss(isPresented: information)
                        }) {
                            Image(systemName: "xmark")
                                .font(Font.title.weight(.medium))
                                .foregroundColor(.accentColor)
                        }
                        .scaleButton()
                    }
                    
                    /// Title and Subtitle
                    Text("알레르미 도움말")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("연한 색은 교차 반응 식품입니다.")
                    
                    /// Example Information
                    HStack {
                        ForEach(0..<2) { idx in
                            Text(["알레르기 유발 식품", "교차 반응 식품"][idx])
                                .foregroundColor(Color(.systemBackground))
                                .padding([.leading, .trailing], 10)
                                .frame(height: 30)
                                .background([.accentColor, .lightColor][idx])
                                .clipShape(Capsule())
                        }
                    }
                    .padding(.vertical, 30)
                }
            }
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
    static let halfGrayColor = Color("HalfGrayColor")
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
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .opacity(configuration.isPressed ? 0.6 : 1)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}
