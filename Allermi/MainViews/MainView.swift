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
    @State private var settings: Bool = false
    
    /// Local Variables
    private var searchState: Bool {
        return !searchText.isEmpty
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            if !settings {
                // MARK: - Logo
                if !searchState {
                    Spacer()
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
                    if typedText.isEmpty && !searchState && !focusState {
                        Text("식품명을 입력해 검색하세요")
                            .foregroundColor(.gray)
                    }
                    
                    /// Text Container
                    HStack {
                        
                        /// Text Field
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
            }
            
            if searchState {
                SearchView(searchText: searchText)
                    .transition(.move(edge: .bottom))
                    .ignoresSafeArea(.keyboard)
            }
            
            // MARK: - Settings
            else {
                Spacer()
                ZStack {
                    if settings {
                        SelectionView(selection: $settings)
                            .transition(.move(edge: .bottom))
                    }
                    
                    // MARK: - Settings Button
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: {
                                touch()
                                endTextEditing()
                                withAnimation(.default) {
                                    settings.toggle()
                                }
                            }) {
                                Image(systemName: settings ? "xmark" : "gearshape.fill")
                                    .font(Font.title.weight(.medium))
                                    .foregroundColor(.accentColor)
                                    .rotationEffect(.degrees(settings ? -180 : 0))
                            }
                            .scaleButton()
                        }
                        
                        /// Sending button to top
                        if settings {
                            Spacer()
                        }
                    }
                }
            }
            
        }
        .padding(searchState ? 0 : 30)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onTapGesture(perform: endTextEditing)
    }
}
