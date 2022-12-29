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
            
            // MARK: - Product Search List
            ScrollViewReader { value in
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(allergyData, id: \.self) { data in
                            DetailView(selected: $selected, data: data)
                                .id(data.productNumber)
                        }
                    }
                    .padding(.bottom, 15)
                }
                
                // MARK: - Auto Scrolling Function
                .onChange(of: selected) { idx in
                    withAnimation(springAnimation) {
                        value.scrollTo(idx, anchor: .top)
                    } 
                }
            }
            .mask(
                VStack(spacing: 0) {
                    LinearGradient(gradient: Gradient(colors: [.black.opacity(0.3), .black]),
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
