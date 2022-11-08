/// Register View Interface
/// Created by Mercen on 2022/11/06.

import SwiftUI
import Collections
import WrappingHStack

// MARK: - Register View
struct RegisterView: View {
    
    /// State Variables
    @State private var registered: Bool = false
    
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

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            // MARK: - Title
            Text("알레르미 시작하기")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 50)
            
            // MARK: - Subtitle
            Text("보유하고 계신 알레르기를 선택해주세요.")
            
            // MARK: - Allergy Selection
            ScrollView {
                WrappingHStack(viewList) { value in
                    Button(action: {
                        
                    }) {
                        Text(value)
                            .foregroundColor(Color(.systemBackground))
                            .padding([.leading, .trailing], 10)
                            .frame(height: 30)
                            .background(Color.accentColor)
                            .clipShape(Capsule())
                    }
                    .padding(.bottom, 7)
                }
                .padding(.top, 30)
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
                        .frame(height: 30)
                        if idx == 0 {
                            Rectangle().fill(Color.black)
                        }
                    }
                }
             )
            
            Spacer()
            
            // MARK: - Complete Button
            Button(action: {
                withAnimation(.default) {
                    registered.toggle()
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
        }
        .padding()
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
