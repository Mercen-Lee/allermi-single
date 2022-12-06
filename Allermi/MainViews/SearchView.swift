/// Search View
/// Created by Mercen on 2022/11/19.

import SwiftUI
import RealmSwift
import Kingfisher
import MarqueeText

// MARK: - Search View
struct SearchView: View {

    /// Namespaces
    @Namespace private var animation
    
    /// Binding Variables
    @Binding var selected: Int
    
    /// Static Variables
    let searchText: String
    
    /// Local Variables
    private var allergy: [String]? {
        return UserDefaults.standard.array(forKey: "allergy") as? [String]
    }
    
    private var allergyData: [AllergyData] {
        let realm = try! Realm()
        return Array(realm.objects(AllergyData.self)
            .filter("productName CONTAINS %@", "\(searchText)"))
    }
    
    /// Local Functions
    private func hasAllergy(_ data: [String]) -> String? {
        let filtered = allergy!.filter { data.contains($0) }
        if filtered.isEmpty {
            return nil
        } else {
            return "\(filtered.joined(separator: ", ")) 일치"
        }
    }

    var body: some View {
        if allergyData.isEmpty {
            
            Text("검색 결과가 없습니다")
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        } else {
            
            // MARK: - Data List
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(allergyData, id: \.self) { data in
                        if selected == -1 || selected == data.productNumber {
                            // MARK: - Data Cell
                            Button(action: {
                                touch()
                                withAnimation(springAnimation) {
                                    if selected == data.productNumber {
                                        selected = -1
                                    } else {
                                        selected = data.productNumber
                                    }
                                }
                            }) {
                                VStack {
                                    HStack(spacing: 15) {
                                        
                                        /// Food Image
                                        KFImage(URL(string: data.imageURL))
                                            .placeholder {
                                                Image(systemName: "fork.knife.circle.fill")
                                                    .resizable()
                                                    .frame(width: 40, height: 40)
                                                    .foregroundColor(Color(.systemBackground))
                                            }
                                            .retry(maxCount: 3, interval: .seconds(5))
                                            .cancelOnDisappear(true)
                                            .cacheMemoryOnly()
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 70, height: 70)
                                            .background(Color(.systemBackground).opacity(0.5))
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                        
                                        /// Allergy Informations
                                        VStack(alignment: .leading, spacing: 0) {
                                            MarqueeText(
                                                text: data.productName,
                                                font: UIFont.boldSystemFont(ofSize: 22),
                                                leftFade: 5,
                                                rightFade: 5,
                                                startDelay: 2
                                            )
                                            MarqueeText(
                                                text: hasAllergy(Array(data.allergyList)) ?? "알레르기 해당 없음",
                                                font: UIFont.preferredFont(forTextStyle: .body),
                                                leftFade: 5,
                                                rightFade: 5,
                                                startDelay: 2
                                            )
                                        }
                                        Spacer()
                                    }
                                    if selected == data.productNumber {
                                        Text("aaa")
                                    }
                                }
                                .padding(15)
                                .frame(maxWidth: .infinity)
                                .background(hasAllergy(Array(data.allergyList)) == nil ? .grayColor : .lightColor)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .padding([.top, .leading, .trailing], 15)
                                .matchedGeometryEffect(id: "\(data.productNumber) container", in: animation)
                            }
                            .scaleButton()
                        }
                    }
                }
                .padding(.bottom, 15)
            }
            .mask(
                VStack(spacing: 0) {
                    LinearGradient(gradient: Gradient(colors: [.black.opacity(0.5), .black]),
                                   startPoint: .top,
                                   endPoint: .bottom
                    )
                    .frame(height: 15)
                    Rectangle()
                        .fill(Color.black)
                        .ignoresSafeArea(edges: .bottom)
                }
            )
        }
    }
}
