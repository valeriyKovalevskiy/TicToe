//
//  Options.swift

import Foundation

private let kFirstPlayerScore = "firstPlayerScore"
private let kSecondPlayerScore = "secondPlayerScore"
private let kPlayerSelected = "playerSelected"
private let kGameModeSelected = "gameModeSelected"


class Options {
    static let sharedOptions = Options()
    
	var firstPlayerScore: Int {
        set {
            UserDefaults.standard.set(newValue, forKey: kFirstPlayerScore)
            UserDefaults.standard.synchronize()
        }
		get {
			return UserDefaults.standard.integer(forKey: kFirstPlayerScore)
		}
    }
	
	init() {
		if playerSelected == 0 {
			playerSelected = 1
		}
	}
	
	var secondPlayerScore: Int {
		set {
			UserDefaults.standard.set(newValue, forKey: kSecondPlayerScore)
			UserDefaults.standard.synchronize()
		}
		get {
			return UserDefaults.standard.integer(forKey: kSecondPlayerScore)
		}
	}
	
	var playerSelected: Int {
		set {
			UserDefaults.standard.set(newValue, forKey: kPlayerSelected)
			UserDefaults.standard.synchronize()
		}
		get {
			return UserDefaults.standard.integer(forKey: kPlayerSelected)
		}
	}
    
    var is3x3gameModeSelected: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kGameModeSelected)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: kGameModeSelected)
        }
    }
	
}
