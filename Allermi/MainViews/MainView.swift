/// Main View Interface
/// Created by Mercen on 2022/11/03.

import SwiftUI

// MARK: - Main View
struct MainView: View {
    
    /// State Variables
    @State private var searchText = ""

    var body: some View {
        VStack(spacing: 30) {
            
            // MARK: - Logo
            Image("WhiteLogo")
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .foregroundColor(.accentColor)
                .frame(width: 230)
            
            // MARK: - Text Input
            TextField("식품명을 입력해 검색하세요", text: $searchText)
                .multilineTextAlignment(.center)
                .padding(20)
                .background(Color.gray.opacity(0.2))
                .clipShape(Capsule())
        }
        .padding()
    }
}
