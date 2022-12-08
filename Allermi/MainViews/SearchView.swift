/// Search View
/// Created by Mercen on 2022/11/19.

import SwiftUI
import RealmSwift
import Kingfisher

// MARK: - Search View
struct SearchView: View {

    /// State Variables
    @State var selected: Int = -1
    
    /// Static Variables
    let searchText: String
    
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
                LazyVStack(spacing: 0) {
                    ForEach(allergyData, id: \.self) { data in
                        VStack(spacing: 0) {
                            DetailView(selected: $selected, data: data)
                        }
                    }
                }
                .padding(.bottom, 15)
            }
            .mask(
                VStack(spacing: 0) {
                    LinearGradient(gradient: Gradient(colors: [.black.opacity(0.6), .black]),
                                   startPoint: .top,
                                   endPoint: .bottom
                    )
                    .frame(height: 15)
                    Rectangle()
                        .fill(Color.black)
                        .ignoresSafeArea()
                }
            )
        }
    }
}
