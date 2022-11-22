/// Detail View
/// Created by Mercen on 2022/11/22.

import SwiftUI
import MarqueeText

// MARK: - Detail View
struct DetailView: View {
    
    /// Bindings
    @Binding var detailState: Bool
    
    /// Static Variables
    let data: AllergyData
    
    /// Local Variables
    var animation: Namespace.ID
    
    /// Local Functions
    private func namespacer(_ name: String) -> String {
        return "\(data.productNumber) \(name)"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            HStack {
                Spacer()
                Button(action: {
                    touch()
                    withAnimation(springAnimation) {
                        detailState = false
                    }
                }) {
                    Image(systemName: "xmark")
                        .font(Font.title.weight(.medium))
                        .foregroundColor(.accentColor)
                }
                .scaleButton()
            }
            Text(data.productName)
                .font(.title)
                .fontWeight(.bold)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity)
                .matchedGeometryEffect(id: namespacer("text"), in: animation)
            Spacer()
        }
        .padding(15)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .matchedGeometryEffect(id: namespacer("container"), in: animation)
    }
}
