//
//  ViewController.swift
//
import UIKit
import LBConfettiView


class ViewController4x4: UIViewController {

    //MARK: - Outlets
    @IBOutlet var winLabel: UIImageView!
    @IBOutlet var playerImageView: UIImageView!
    
    //MARK: - Properties
    var confettiView: ConfettiView?
    var gameIsActive = true
    var gameState = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    var activePlayer = 1 //cross
    let winningCombinations = [[0,1,2,3],[4,5,6,7],[8,9,10,11],[12,13,14,15],[0,4,8,12],[1,5,9,13],[2,6,10,14],[3,7,11,15],[0,5,10,15],[3,6,9,12]]
    let firstPlayerImage = UIImage(named: "player_1")
    let secondPlayerImage = UIImage(named: "player_2")
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    //MARK: - Actions
    @IBAction func buttonTapped(_ sender: UIButton) {
        if (gameState[sender.tag-1] == 0) && gameIsActive == true {
            gameState[sender.tag-1] = activePlayer

            if (activePlayer == 1) {
                sender.setImage(firstPlayerImage, for: .normal)
                playerImageView.image = secondPlayerImage
                activePlayer = 2
            } else {
                sender.setImage(secondPlayerImage, for: .normal)
                playerImageView.image = firstPlayerImage
                activePlayer = 1
            }
        }
        
        for combination in winningCombinations {
            if gameState[combination[0]] != 0 && gameState[combination[0]] == gameState[combination[1]] && gameState[combination[1]] == gameState[combination[2]] && gameState[combination[2]] == gameState[combination[3]] {
                gameIsActive = false

                if gameState[combination[0]] == 1 {
                    Options.sharedOptions.firstPlayerScore += 1
                    playerImageView.image = firstPlayerImage
                } else {
                    Options.sharedOptions.secondPlayerScore += 1
                    playerImageView.image = secondPlayerImage
                }
                winLabel.isHidden = false
                showConfetti()
            }
        }
    }
    
    @IBAction func btnResetTapped(sender: UIButton) {
        
        gameState = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
        gameIsActive = true
        activePlayer = 1
        hideConfetti()
        winLabel.isHidden = true
        
        for i in 1...16 {
            let button = view.viewWithTag(i) as! UIButton
            button.setImage(UIImage(named: "non_player"), for: .normal)
        }
    }
    
    @IBAction func backTapped(sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Private methods
    private func showConfetti() {
        let confettiView = ConfettiView(frame: self.view.bounds)
        self.view.addSubview(confettiView)
        confettiView.start()
        self.confettiView = confettiView
    }

    private func hideConfetti() {
        self.view.subviews.forEach { (view) in
            if let confetti = view as? ConfettiView {
                confetti.removeFromSuperview()
            }
        }
    }

    
}

