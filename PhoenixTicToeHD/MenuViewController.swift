//
//  ViewController.swift


import UIKit
import GameKit

import GLKit

class MenuViewController: UIViewController {
	
    let identifier3x3 = "ViewController3x3"
    let identifier4x4 = "ViewController4x4"

	var isAuthenticated: Bool? {
		didSet {
			if isAuthenticated != oldValue, isAuthenticated == true {
				UserDefaults.standard.set(isAuthenticated, forKey: "isAuthenticated")
				UserDefaults.standard.synchronize()
			}
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		isAuthenticated = UserDefaults.standard.object(forKey: "isAuthenticated") as? Bool
	}
	
	var firstLoad = true
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		if firstLoad {
			firstLoad = false
		}
	}
    
    @IBAction func didTappedPlayButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if Options.sharedOptions.is3x3gameModeSelected {
            let vc = storyboard.instantiateViewController(withIdentifier: identifier3x3)
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = storyboard.instantiateViewController(withIdentifier: identifier4x4)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}

