/// Detail View
/// Created by Mercen on 2022/11/22.

import SwiftUI
import MarqueeText

// MARK: - Detail View
struct DetailView: View {
    
    /// Static Variables
    let data: AllergyData
    
    /// Local Variables
    var animation: Namespace.ID
    
    /// Local Functions
    private func namespacer(_ name: String) -> String {
        return "\(data.productNumber) \(name)"
    }
    var body: some View {
        VStack {
            Text(data.productName)
                .font(.largeTitle)
                .fontWeight(.bold)
                .matchedGeometryEffect(id: namespacer("text"), in: animation)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .matchedGeometryEffect(id: namespacer("container"), in: animation)
                .padding()
        }
    }
}
