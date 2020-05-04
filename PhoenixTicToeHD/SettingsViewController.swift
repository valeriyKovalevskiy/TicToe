//
//  SettingsViewController.swift


import UIKit

class SettingsViewController: UIViewController {
	
	
	@IBOutlet var firstPlayerBtn: UIButton!
	@IBOutlet var secoondPlayerBtn: UIButton!
	
	
	override func viewDidLoad() {
		if Options.sharedOptions.playerSelected == 1 {
			firstPlayerBtn.isSelected = true
			secoondPlayerBtn.isSelected = false
		} else {
			secoondPlayerBtn.isSelected = true
			firstPlayerBtn.isSelected = false
		}
	}
	
	@IBAction func backTapped(sender: UIButton) {
		navigationController?.popViewController(animated: true)
	}
	
	@IBAction func firstPlayerTapped(_ sender: UIButton) {
		sender.isSelected = true
		secoondPlayerBtn.isSelected = false
		Options.sharedOptions.playerSelected = 1
	}
	
	@IBAction func secondPlayerTapped(_ sender: UIButton) {
		sender.isSelected = true
		firstPlayerBtn.isSelected = false
		Options.sharedOptions.playerSelected = 2
	}
	
    @IBAction func didTapped3x3Mode(_ sender: UIButton) {
        Options.sharedOptions.is3x3gameModeSelected = true
    }
    
    @IBAction func didTapped4x4Mode(_ sender: UIButton) {
        Options.sharedOptions.is3x3gameModeSelected = false
    }
}
