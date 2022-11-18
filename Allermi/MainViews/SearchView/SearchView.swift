/// Main View Interface
/// Created by Mercen on 2022/11/19.

import SwiftUI

// MARK: - Search View
struct SearchView: View {
    
    /// Static Variables
    private let searchText: String
    
    var body: some View {
        ScrollView {
            Text("a")
                .frame(maxWidth: .infinity)
                .frame(height: 100)
                .background(Color.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .padding(20)
        }
    }
}
