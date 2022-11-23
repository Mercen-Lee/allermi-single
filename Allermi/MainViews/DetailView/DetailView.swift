/// Detail View
/// Created by Mercen on 2022/11/22.

import SwiftUI
import MarqueeText
import Kingfisher

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
        
        // MARK: - Head
        VStack(alignment: .leading, spacing: 30) {
            ZStack(alignment: .topTrailing) {
                
                // MARK: - Image
                KFImage(URL(string: data.imageURL))
                    .placeholder {
                        Image(systemName: "fork.knife.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color(.systemBackground))
                    }
                    .retry(maxCount: 3, interval: .seconds(5))
                    .cacheMemoryOnly()
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .background(Color(.systemBackground).opacity(0.5))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .matchedGeometryEffect(id: namespacer("image"), in: animation)
                
                // MARK: - Exit Button
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
                .padding(15)
            }
            MarqueeText(
                text: data.productName,
                font: UIFont.boldSystemFont(ofSize: 30),
                leftFade: 5,
                rightFade: 5,
                startDelay: 2
            )
            .matchedGeometryEffect(id: namespacer("text"), in: animation)
            Spacer()
        }
        .padding(30)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .matchedGeometryEffect(id: namespacer("container"), in: animation)
    }
}
