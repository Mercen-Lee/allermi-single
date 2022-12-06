/// Selection View
/// Created by Mercen on 2022/11/20.

import SwiftUI
import Collections

// MARK: - Settings View
struct SelectionView: View {
    
    /// Bindings
    @Binding var selection: Bool
    
    /// State Variables
    @State private var selectedAllergy: [String] = [String]()
    @State private var title: String = String()
    
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
    private var allergy: [String]? {
        return UserDefaults.standard.array(forKey: "allergy") as? [String]
    }
    
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
    private func loadAllergy() {
        if allergy == nil {
            title = "알레르미 시작하기"
        } else {
            selectedAllergy = allergy!
            title = "알레르미 필터 설정"
        }
    }
    
    private func chooseColor(_ value: String) -> Color {
        if selectedAllergy.contains(value) {
            return .accentColor
        } else if relatedAllergy.contains(value) {
            return .lightColor
        } else {
            return .grayColor
        }
    }

    // MARK: - Custom WrappingHStack
    private func wrappingHStack(in geometry: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        return ZStack(alignment: .topLeading) {
            ForEach(viewList, id: \.self) { allergy in
                itemCell(for: allergy)
                    .padding([.bottom, .trailing], 7)
                    .alignmentGuide(.leading, computeValue: { value in
                        if (abs(width - value.width) > geometry.size.width) {
                            width = 0
                            height -= value.height
                        }
                        let result = width
                        if allergy == viewList.last! {
                            width = 0
                        } else {
                            width -= value.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: { _ in
                        let result = height
                        if allergy == viewList.last! {
                            height = 0
                        }
                        return result
                    })
            }
        }
    }
    
    // MARK: - Allergy Cell
    private func itemCell(for value: String) -> some View {
        Button(action: {
            touch()
            var majorAllergy = String()
            for key in allergyList.keys {
                if allergyList[key]!.contains(value) || key == value {
                    majorAllergy = key
                }
            }
            withAnimation(springAnimation) {
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
    }
    
    var body: some View {
        
        ZStack {
            
            // MARK: - Allergy Selection
            GeometryReader { geometry in
                ScrollView(showsIndicators: false) {
                    wrappingHStack(in: geometry)
                        .padding(.top, 150)
                        .padding(.bottom, 80)
                }
            }
            
            // MARK: - ScrollView Fader
            .mask(
                VStack(spacing: 0) {
                    ForEach(0..<2) { idx in
                        LinearGradient(gradient:
                                        Gradient(
                                            colors: idx == 0 ? [.clear, .black]
                                            : [.black, .clear]),
                                       startPoint: .top,
                                       endPoint: .bottom
                        )
                        .frame(height: 50)
                        if idx == 0 {
                            Rectangle().fill(Color.black)
                        }
                    }
                }
                    .padding(.top, 100)
                    .padding(.bottom, 40)
            )
            
            VStack(alignment: .leading, spacing: 5) {
                // MARK: - Title
                Text(title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 50)
                
                // MARK: - Subtitle
                Text("보유하고 계신 알레르기를 선택해주세요.")
                
                Spacer()
                
                // MARK: - Complete Button
                Button(action: {
                    touch()
                    withAnimation(springAnimation) {
                        UserDefaults.standard.set(selectedAllergy, forKey: "allergy")
                        selection.toggle()
                    }
                }) {
                    Text("완료하기")
                        .foregroundColor(Color(.systemBackground))
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                }
                .scaleButton()
                .disabled(selectedAllergy.isEmpty)
            }
        }
        .onAppear(perform: loadAllergy)
    }
}
