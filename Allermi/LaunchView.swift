/// Launch Screen
/// Created by Mercen on 2022/11/03.

import SwiftUI

// MARK: - Launch View
struct LaunchView: View {
    
    /// State Variables
    @State var animationStatus: Int = 0
    
    /// Local Functions
    private func updateAnimationStatus(time: CGFloat) {
        DispatchQueue.main.asyncAfter(
            deadline: .now() + time, execute: {
                withAnimation(.default) {
                    animationStatus += 1
                }
            })
    }
    
    var body: some View {
        
        // MARK: - View Changer
        if animationStatus == 6 {
            MainView()
        } else {
            VStack(spacing: 5) {
                
                // MARK: - Slogan
                HStack(spacing: 5) {
                    ForEach(Array("세상 모든 알레르기 환자를 위하여"
                        .components(separatedBy: " ")
                        .enumerated()), id: \.offset) { idx, text in
                            
                            /// Animation Activator
                            if idx <= animationStatus {
                                Text(text)
                                    .fontWeight(.bold)
                                    .font(.title3)
                                    .foregroundColor(.white)
                                    .onAppear {
                                        updateAnimationStatus(time: 0.1)
                                    }
                            }
                        }
                }
                
                // MARK: - Logo
                if animationStatus >= 5 {
                    Image("WhiteLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 270)
                        .onAppear {
                            updateAnimationStatus(time: 1)
                        }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.accentColor)
            .ignoresSafeArea()
            .transition(.backslide)
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}
