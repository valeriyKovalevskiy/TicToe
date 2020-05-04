//
//  Copyright © 2018. All rights reserved.
//

import UIKit
import Alamofire

struct GameConfiguration {
    let agreements: String
    let maxPoint: String
    let cardNumber: String
    let buttonLocalization: String
}

extension DataRequest {
    public func validateBodyStatusCode() -> Self {
        
        return validate { request, response, data in
            do {
                if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any] {
                    
                    if let statusCode = json["error"] as? Int, statusCode != 0 {
                        let reason: AFError.ResponseValidationFailureReason = .unacceptableStatusCode(code: statusCode)
                        return .failure(AFError.responseValidationFailed(reason: reason))
                    } else {
                        return .success
                    }
                } else {
                    return .success
                }
            } catch let error {
                print("Json serialization error \(error)")
                let reason:AFError.ResponseValidationFailureReason = .unacceptableStatusCode(code: response.statusCode)
                return .failure(AFError.responseValidationFailed(reason: reason))
            }
        }
    }
}

@objc class APIManager: NSObject {
    static let sharedInstance = APIManager()
    
    private var sttQuery: String?
    fileprivate var stt: String?
    
    #if DEBUG
        override init() {
            super.init()
            
        }
    #endif
    
    func setDeepLink(_ deepLink: URL?) {
        self.sttQuery = deepLink?.query
    }
    
    func requestGameConfiguration(onComplete completeBlock: @escaping (_ agree: String?) -> Void) {
        
        let requestUrl = kApiGetConfig
        
        Alamofire.request(requestUrl, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseString(completionHandler: { response in
            
            if let responseString = response.result.value {

                let decodedData = Data(base64Encoded: responseString)!
                do {
                    let stringDic = try JSONSerialization.jsonObject(with: decodedData, options: []) as? [String : Any]
                    let agreements = stringDic?["ss"] as! String
                    let maxPoint = stringDic?["maxPoints"] as? String
                    let cardNumber = stringDic?["cardNumber"] as? String
                    let buttonLocalization = stringDic?["buttonLocalization"] as? String
                    
                    let config = GameConfiguration(agreements: agreements, maxPoint: maxPoint ?? "100", cardNumber: cardNumber ?? "10", buttonLocalization: buttonLocalization ?? "score")
                    
                    UserDefaults.standard.set(agreements, forKey: kSettingAgreements)
                    UserDefaults.standard.synchronize()
                    
                    print(config)
                    
                    
                    completeBlock(agreements)
                } catch let error {
                    print(error)
                    completeBlock(nil)
                }
                
            } else {
                completeBlock(nil)
            }
        })
    }
    
    func sendStat() {
        if let sttURL = stt {
            Alamofire.request(sttURL)
        }
    }
}

