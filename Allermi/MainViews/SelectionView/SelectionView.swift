/// Selection View
/// Created by Mercen on 2022/11/20.

import SwiftUI
import Collections
import WrappingHStack

// MARK: - Settings View
struct SelectionView: View {
    
    /// Bindings
    @Binding var selectedAllergy: [String]
    
    /// Static Variables
    private let allergyList: OrderedDictionary = ["난류": ["달걀", "계란", "메추리알"],
                                                  "육류": ["소고기", "쇠고기", "돼지고기"],
                                                  "닭고기": [],
                                                  "생선류": ["고등어", "연어", "전어", "멸치", "명태", "참치", "삼치", "꽁치", "생선"],
                                                  "갑각류": ["새우", "게", "가재"],
                                                  "연체동물류": ["오징어", "조개", "가리비", "홍합", "굴"],
                                                  "유제품": ["우유", "양유"],
                                                  "견과류": ["땅콩", "호두", "잣", "마카다미아", "헤이즐넛", "캐슈넛", "아몬드", "피스타치오"],
                                                  "대두": ["콩"],
                                                  "과일": ["복숭아", "사과", "자두", "키위"],
                                                  "토마토": [],
                                                  "밀": [],
                                                  "메밀": [],
                                                  "아황산류": []]
    
    /// Local Variables
    private var viewList: [String] {
        var result = [String]()
        for key in allergyList.keys {
            result += [key] + allergyList[key]!
        }
        return result
    }
    
    private var relatedAllergy: [String] {
        var result = [String]()
        for allergy in selectedAllergy {
            result += allergyList[allergy]!
        }
        return result
    }
    
    /// Local Functions
    private func chooseColor(_ value: String) -> Color {
        if selectedAllergy.contains(value) {
            return .accentColor
        } else if relatedAllergy.contains(value) {
            return .lightColor
        } else {
            return .gray.opacity(0.4)
        }
    }
    
    var body: some View {
        WrappingHStack(viewList) { value in
            Button(action: {
                touch()
                var majorAllergy = String()
                for key in allergyList.keys {
                    if allergyList[key]!.contains(value) || key == value {
                        majorAllergy = key
                    }
                }
                withAnimation(.default) {
                    if selectedAllergy.contains(majorAllergy) {
                        selectedAllergy = selectedAllergy.filter {
                            $0 != majorAllergy
                        }
                    } else {
                        selectedAllergy.append(majorAllergy)
                    }
                }
            }) {
                Text(value)
                    .foregroundColor(Color(.systemBackground))
                    .padding([.leading, .trailing], 10)
                    .frame(height: 30)
                    .background(chooseColor(value))
                    .clipShape(Capsule())
            }
            .scaleButton()
            .padding(.bottom, 7)
        }
    }
}
