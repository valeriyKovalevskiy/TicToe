//
//  SettingsViewController.swift


import UIKit

class ScoreViewController: UIViewController {
	
	
	@IBOutlet var firstScore: UILabel!
	@IBOutlet var secondScore: UILabel!
	
	override func viewDidLoad() {
		firstScore.text = "\(Options.sharedOptions.firstPlayerScore)"
		secondScore.text = "\(Options.sharedOptions.secondPlayerScore)"
	}
	
	@IBAction func backTapped(sender: UIButton) {
		navigationController?.popViewController(animated: true)
	}
	
}
