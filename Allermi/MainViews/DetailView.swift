//
//  DetailView.swift
//  Allermi
//
//  Created by Mercen on 2022/12/08.
//

import SwiftUI
import Kingfisher

// MARK: - Detail View
struct DetailView: View {
    
    /// Namespaces
    @Namespace private var animation
    
    /// Bindings
    @Binding var selected: Int
    
    /// Static Variables
    let data: AllergyData
    
    /// Local Variables
    private var allergy: [String]? {
        return UserDefaults.standard.array(forKey: "allergy") as? [String]
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
        LazyVStack(spacing: 0) {
            // MARK: - Data Cell
            Button(action: {
                touch()
                print(selected)
                print(data.productNumber)
                withAnimation(springAnimation) {
                    if selected == data.productNumber {
                        selected = -1
                    } else {
                        selected = data.productNumber
                    }
                }
            }) {
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
                        Text(data.productName)
                            .font(.title2)
                            .fontWeight(.bold)
                        Text(hasAllergy(Array(data.allergyList)) ?? "알레르기 해당 없음")
                    }
                }
                .customContainer(hasAllergy(Array(data.allergyList)) == nil ? .grayColor : .lightColor)
                .matchedGeometryEffect(id: "\(data.productNumber) container", in: animation)
            }
            .scaleButton()
            if selected == data.productNumber {
                ForEach([data.companyName, data.ingredients, data.nutrient], id: \.self) { text in
                    Text(text)
                        .multilineTextAlignment(.leading)
                        .font(.caption)
                        .customContainer()
                        .zIndex(-1)
                        .transition(.move(edge: .top)
                            .combined(with: .opacity))
                }
            }
        }
    }
}
