/// Main CSV File Controller
/// Created by Mercen on 2022/11/03.

import Foundation
import Alamofire

// MARK: - Decoding EUC-KR Data to UTF-8
func decodeString(_ data: Data) -> String {
    
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

// MARK: - CSV Downloader
func csvDownload() {
    AF.request("https://bigdata.gyeongnam.go.kr/index.gn?contentsSid=409&apiIdx=501",
               method: .get
    ) { $0.timeoutInterval = 10 }
    .validate()
    .responseData { response in
        switch response.result {
        case .success:
            let decodedString: String = decodeString(response.data!)
            print(csvParse(decodedString)[0])
        case .failure(let error):
            print("통신 오류!\nCode:\(error._code), Message: \(error.errorDescription!)")
        }
    }
}
