/// Search View
/// Created by Mercen on 2022/11/19.

import SwiftUI
import RealmSwift
import Kingfisher
import MarqueeText

// MARK: - Search View
struct SearchView: View {
    
    /// Static Variables
    let searchText: String
    
    /// Local Variables
    private var allergyData: [AllergyData] {
        let realm = try! Realm()
        return Array(realm.objects(AllergyData.self)
            .filter("productName CONTAINS %@", "\(searchText)"))
    }
    
    var body: some View {
        if allergyData.isEmpty {
            
            Text("검색 결과가 없습니다")
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        } else {
            
            // MARK: - Data List
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(allergyData, id: \.self) { data in
                        
                        // MARK: - Data Cell
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
                                .background(Color.gray.opacity(0.2))
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
                                     text: "알레르기 해당 없음",
                                     font: UIFont.preferredFont(forTextStyle: .body),
                                     leftFade: 5,
                                     rightFade: 5,
                                     startDelay: 2
                                )
                            }
                            
                            Spacer()
                        }
                        .padding(15)
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .padding([.top, .leading, .trailing], 15)
                    }
                }
                .padding(.bottom, 15)
            }
        }
    }
}
