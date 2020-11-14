//
//  GameOverViewController.swift
//  SpaceWar
//
//  Created by Mikhailov on 19.07.2020.
//

import UIKit

protocol GameOverDelegate {
    func gameOverVCReplyButtonPressed(_ viewController: GameOverViewController)
}

class GameOverViewController: UIViewController {

    @IBOutlet weak var scoreLabel: UILabel!
    
    var delegate: GameOverDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func resetButton(_ sender: UIButton) {
        delegate.gameOverVCReplyButtonPressed(self)
    }
    
}
