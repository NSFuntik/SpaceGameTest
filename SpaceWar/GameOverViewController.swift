//
//  GameOverViewController.swift
//  SpaceWar
//
//  Created by Mikhailov on 19.07.2020.
//

import UIKit

protocol IGameOverDelegate {
    func gameOverVCReplyButtonPressed(_ viewController: GameOverViewController)
}

class GameOverViewController: UIViewController {
    var delegate: IGameOverDelegate!

    @IBOutlet weak var scoreLabel: UILabel!
    @IBAction func resetButton(_ sender: UIButton) {
        delegate.gameOverVCReplyButtonPressed(self)
    }
}
