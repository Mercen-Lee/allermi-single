/// Main View Interface
/// Created by Mercen on 2022/11/03.

import SwiftUI
import RealmSwift

// MARK: - Main View
struct MainView: View {
    
    /// State Variables
    @State private var focusState: Bool = false
    @State private var typedText: String = ""
    @State private var searchText: String = ""
    
    /// Local Variables
    private var searchState: Bool {
        return !searchText.isEmpty
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            // MARK: - Logo
            if !searchState {
                Image("WhiteLogo")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.accentColor)
                    .frame(width: 230)
                    .padding(.bottom, 30)
            }
            
            // MARK: - Text Input
            ZStack {
                
                /// Placeholder
                if searchText.isEmpty && !searchState && !focusState {
                    Text("식품명을 입력해 검색하세요")
                        .foregroundColor(.gray)
                }
                
                /// Text Field
                HStack {
                    TextField("", text: $typedText, onEditingChanged: { editingChanged in
                        focusState = editingChanged
                    }, onCommit: {
                        if !typedText.isEmpty {
                            withAnimation(.default) {
                                searchText = typedText
                            }
                        }
                    })
                    .multilineTextAlignment(searchState ? .leading : .center)
                    Spacer()
                    
                    /// Erase Button
                    if !searchText.isEmpty || searchState {
                        Button(action: {
                            withAnimation(.default) {
                                typedText = ""
                                searchText = ""
                            }
                        }) {
                            Image(systemName: "xmark.circle.fill")
                        }
                    }
                }
                .padding(20)
                .frame(maxWidth: searchState ? .infinity : 500)
                .background(Color.gray.opacity(0.2)
                    .clipShape(RoundedRectangle(cornerRadius: searchState ? 0 : 20))
                    .ignoresSafeArea(edges: .top))
                .keyboardType(.webSearch)
            }
            
            if searchState {
                SearchView(searchText: searchText)
                    .transition(.move(edge: .bottom))
                    .ignoresSafeArea(.keyboard)
            }
        }
        .padding(searchState ? 0 : 30)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onTapGesture(perform: endTextEditing)
    }
}
