//
//  GameViewController.swift
//  SpaceWar
//
//  Created by Mikhailov on 06.07.2020.
//

import UIKit
import SpriteKit
//import GameplayKit

class GameViewController: UIViewController {
    
    var gameScene: GameScene!
    var pauseViewController: PauseViewController!
    var gameOverViewController: GameOverViewController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //gameScene.resetTheGame()
        if #available(iOS 13.0, *) {
            pauseViewController = storyboard?.instantiateViewController(identifier: "PauseViewController") as? PauseViewController
            gameOverViewController = storyboard?.instantiateViewController(withIdentifier: "gameOverViewController") as? GameOverViewController
        }
        
        pauseViewController.delegate = self
        gameOverViewController.delegate = self
        //self.view = SKView(frame: UIScreen.main.bounds)
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                scene.scaleMode = .resizeFill
                gameScene = scene as? GameScene
                gameScene.gameViewControllerBridge = self
                gameScene.gameOverViewControllerBridge = gameOverViewController
                gameScene.didFinishScene = { [weak self] in
                        let vc = WebViewController()
                        self?.gameScene.isHidden = true
                        vc.delegate = self as? WebCompletionDelegate
                        self?.openDeepLink()
                        LinksService.shared.setCompletion { [weak self] in
                            self?.present(vc, animated: true)
                        }
                }
                view.presentScene(scene)
                
            }
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
        
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func showPauseScreen(_ viewController: UIViewController) {
        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.view.frame = view.bounds
        viewController.view.alpha = 0
        UIView.animate(withDuration: 0.5) {
            viewController.view.alpha = 1
        }
    }
    
    func hidePauseScreen(viewController: UIViewController){
        viewController.willMove(toParent: nil)
        viewController.removeFromParent()
        viewController.view.alpha = 1
        UIView.animate(withDuration: 0.5,
                       animations: {
                        viewController.view.alpha = 0   })
        { (completed) in
            viewController.view.removeFromSuperview()
        }
    }
    
    @IBAction func pauseButtonPressed(_ sender: UIButton?) {
        gameScene.pauseTheGame()
        showPauseScreen(pauseViewController)
        //present(pauseViewController, animated: true, completion: nil)
    }
    
}

extension GameViewController: PauseVCDelegate {
    func pauseVCSoundButton(_ viewController: PauseViewController) {
        print("sound")
    }
    
    func pauseVCMusicButton(_ viewController: PauseViewController) {
        gameScene.musicOn = !gameScene.musicOn
        gameScene.musicOnOrOff()
        
        let image = gameScene.musicOn ? UIImage(named: "onButton") : UIImage(named: "offButton")
        viewController.musicButton.setImage(image, for: .normal)
    }
    
    func pauseVCPlayButton(_ viewController: PauseViewController) {
        hidePauseScreen(viewController: pauseViewController)
        gameScene.unpauseTheGame()
    }
}

extension GameViewController: GameOverDelegate {
    func gameOverVCReplyButtonPressed(_ viewController: GameOverViewController) {
        hidePauseScreen(viewController: gameOverViewController)
        gameScene.restartGame()
    }
}

extension GameViewController {
    override func viewDidAppear(_ animated: Bool) {
        self.pauseButtonPressed(nil)
    }
    
    private func openDeepLink() {
        let appURLScheme = "testspace://"
        guard let appURL = URL(string: appURLScheme) else {
            return
        }
        if UIApplication.shared.canOpenURL(appURL) {
            UIApplication.shared.open(appURL,
                                      options: [:],
                                      completionHandler: nil)
        }
        else {
            print("can't load link")
        }
    }
}

extension GameViewController: WebCompletionDelegate {

    func webViewDidDisappear() {
        gameScene.isHidden = false
    }

}
