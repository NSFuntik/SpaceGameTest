//
//  GameVCDelegates.swift
//  SpaceWar
//
//  Created by Mikhailov on 15.11.2020.
//

import UIKit

extension GameViewController: IPauseVCDelegate, IGameOverDelegate, IWebCompletionDelegate {
    
    func pauseVCMusicButton(_ viewController: PauseViewController) {
        gameScene.musicOn = !gameScene.musicOn
        gameScene.musicToggle()
        
        let image = gameScene.musicOn ? UIImage(named: "onButton") : UIImage(named: "offButton")
        viewController.musicButton.setImage(image, for: .normal)
    }
    
    func pauseVCPlayButton(_ viewController: PauseViewController) {
        hidePauseScreen(viewController: pauseViewController)
        gameScene.unpauseTheGame()
    }
    func gameOverVCReplyButtonPressed(_ viewController: GameOverViewController) {
        hidePauseScreen(viewController: gameOverViewController)
        gameScene.restartGame()
    }
    
    func webViewDidDisappear() {
        gameScene.isHidden = false
    }
}
