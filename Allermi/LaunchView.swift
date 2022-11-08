/// Launch Screen
/// Created by Mercen on 2022/11/03.

import SwiftUI
import Alamofire
import RealmSwift
import SwiftSoup

// MARK: - Launch View
struct LaunchView: View {
    
    /// State Variables
    @State private var animationStatus: Int = 0
    @State private var dataLoadStatus: Bool = false
    @State private var errorOccurred: Bool = false
    @State private var registering: Bool = false
    
    /// Local Variables
    private var registered: Bool {
        return UserDefaults.standard.bool(forKey: "registered")
    }
    private var version: String? {
        return UserDefaults.standard.string(forKey: "version")
    }
    
    /// Local Functions
    // MARK: - Update Animation
    private func updateAnimationStatus(time: CGFloat) {
        DispatchQueue.main.asyncAfter(
            deadline: .now() + time, execute: {
                withAnimation(.default) {
                    animationStatus += 1
                }
            })
    }
    
    // MARK: - Decoding EUC-KR Data to UTF-8
    private func decodeString(_ data: Data) -> String {
        
        /// Pre-defining Variables
        let rawEncoding = CFStringConvertEncodingToNSStringEncoding(0x0422)
        let encoding = String.Encoding(rawValue: rawEncoding)
        
        var resultString: String = ""
        var idx: Int = 0
        
        /// Decoding Process
        while idx < data.count {
            let char = data[idx]
            if char < 0x80 {
                resultString += String(Character(UnicodeScalar(UInt32(char))!))
            } else if idx + 2 <= data.count {
                if let temp = String(data: data.subdata(in: idx..<idx+2), encoding: encoding) {
                    resultString += temp
                    idx += 1
                }
            }
            idx += 1
        }
        
        return resultString
    }
    
    // MARK: - Database Version Checker
    private func checkDatabase(completion:@escaping (((String) -> Void))) {
        AF.request("https://bigdata.gyeongnam.go.kr/bigdata/collect/view.gn?&apiIdx=501",
                   method: .get
        ) { $0.timeoutInterval = 10 }
            .validate()
            .responseData { response in
                switch response.result {
                case .success:
                    let result = String(decoding: response.data!, as: UTF8.self)
                    guard let ver = try? SwiftSoup.parse(result).select(".con")[0].text() else {
                        errorOccurred.toggle()
                        return
                    }
                    completion(ver)
                case .failure:
                    if version != nil {
                        completion(version!)
                    } else {
                        errorOccurred.toggle()
                    }
                }
            }
    }
    
    // MARK: - Database Downloader
    private func downloadDatabase() {
        AF.request("https://bigdata.gyeongnam.go.kr/index.gn?contentsSid=409&apiIdx=501",
                   method: .get
        ) { $0.timeoutInterval = 10 }
        .validate()
        .responseData { response in
            switch response.result {
            case .success:
                let decodedString: String = decodeString(response.data!)
                let realm = try! Realm()
                try! realm.write {
                    realm.deleteAll()
                    realm.add(csvParse(decodedString))
                }
                checkDatabase() { ver in
                    UserDefaults.standard.set(ver, forKey: "version")
                }
                withAnimation(.default) {
                    dataLoadStatus = false
                }
            case .failure:
                errorOccurred.toggle()
            }
        }
    }
    
    // MARK: - Init Function
    private func initFunction() {
        checkDatabase() { ver in
            if ver != version {
                withAnimation(.default) {
                    dataLoadStatus = true
                }
                downloadDatabase()
            }
        }
    }

    var body: some View {
        
        // MARK: - View Changer
        if animationStatus == 6 && !dataLoadStatus && !errorOccurred && registered {
            
            MainView()
            
        } else if registering {
            
            RegisterView()
            
        } else {
            VStack(spacing: 5) {
                
                Spacer()
                
                // MARK: - Slogan
                HStack(spacing: 5) {
                    ForEach(Array("세상 모든 알레르기 환자를 위하여"
                        .components(separatedBy: " ")
                        .enumerated()), id: \.offset) { idx, text in
                            
                            /// Animation Activator
                            if idx <= animationStatus {
                                Text(text)
                                    .fontWeight(.bold)
                                    .font(.title3)
                                    .foregroundColor(.white)
                                    .transition(.scale)
                                    .onAppear {
                                        updateAnimationStatus(time: 0.1)
                                    }
                            }
                        }
                }
                
                // MARK: - Logo
                if animationStatus >= 5 {
                    Image("WhiteLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 270)
                        .transition(.scale)
                        .onAppear {
                            updateAnimationStatus(time: 1)
                        }
                }
                
                if animationStatus >= 5 {
                    // MARK: - Loading
                    if dataLoadStatus {
                        HStack(spacing: 20) {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                            Text("최신 데이터베이스 다운로드 중")
                                .foregroundColor(.white)
                        }
                        .padding(.top, 30)
                        Spacer()
                    }
    
                    // MARK: - Register Button
                    else if !registered {
                        Spacer()
                        Button(action: {
                            withAnimation(.default) {
                                registering.toggle()
                            }
                        }) {
                            Text("시작하기")
                                .fontWeight(.bold)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                        }
                        .padding(30)
                    }
                } else {
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.accentColor.ignoresSafeArea())
            .onAppear(perform: initFunction)
            .transition(.backslide)
            
            // MARK: - 서버 오류 처리
            .alert(isPresented: $errorOccurred) {
                Alert(title: Text("오류"),
                      message: Text("서버에 연결할 수 없습니다"),
                      dismissButton: Alert.Button.default(Text("확인"), action: {
                    UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        exit(0)
                    }
                }))
            }
        }
    }
}
