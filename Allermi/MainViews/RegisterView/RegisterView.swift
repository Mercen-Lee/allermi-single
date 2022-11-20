/// Register View Interface
/// Created by Mercen on 2022/11/06.

import SwiftUI

// MARK: - Register View
struct RegisterView: View {
    
    /// Bindings
    @Binding var registering: Bool
    
    /// State Variables
    @State private var selectedAllergy: [String] = [String]()
    
    var body: some View {
        
        ZStack {
            
            // MARK: - Allergy Selection
            ScrollView(showsIndicators: false) {
                SelectionView(selectedAllergy: $selectedAllergy)
                    .padding(.top, 150)
            }
            
            // MARK: - ScrollView Fader
            .mask(
                VStack(spacing: 0) {
                    ForEach(0..<2) { idx in
                        LinearGradient(gradient:
                                        Gradient(
                                            colors: idx == 0 ? [.clear, .black]
                                            : [.black, .clear]),
                                       startPoint: .top,
                                       endPoint: .bottom
                        )
                        .frame(height: 50)
                        if idx == 0 {
                            Rectangle().fill(Color.black)
                        }
                    }
                }
                    .padding(.top, 100)
                    .padding(.bottom, 40)
            )
            
            VStack(alignment: .leading, spacing: 5) {
                // MARK: - Title
                Text("알레르미 시작하기")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 50)
                
                // MARK: - Subtitle
                Text("보유하고 계신 알레르기를 선택해주세요.")
                
                Spacer()
                
                // MARK: - Complete Button
                Button(action: {
                    touch()
                    withAnimation(.default) {
                        UserDefaults.standard.set(selectedAllergy, forKey: "allergy")
                        registering.toggle()
                    }
                }) {
                    Text("완료하기")
                        .foregroundColor(Color(.systemBackground))
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                }
                .disabled(selectedAllergy.isEmpty)
            }
        }
        .padding(30)
    }
}
