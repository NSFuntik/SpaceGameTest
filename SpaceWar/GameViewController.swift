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
        if #available(iOS 13.0, *) {
            pauseViewController = storyboard?.instantiateViewController(identifier: "PauseViewController") as? PauseViewController
            gameOverViewController = storyboard?.instantiateViewController(withIdentifier: "gameOverViewController") as? GameOverViewController
        }
        pauseViewController.delegate = self
        gameOverViewController.delegate = self
        
        //MARK: - Load the SKScene from 'GameScene.sks'
        
        guard let view = self.view as! SKView? else { return }
        guard let scene = SKScene(fileNamed: "GameScene") else { return }
        
        gameScene = scene as? GameScene
        gameScene.gameViewControllerBridge = self
        gameScene.gameOverViewControllerBridge = gameOverViewController
        
        gameScene.didFinishScene = { [weak self] in
            let webVC = WebViewController()
            self?.gameScene.isHidden = true
            webVC.delegate = self
            self?.openDeepLink()
            LinksService.shared.setCompletion { [weak self] in
                self?.present(webVC, animated: true)
            }
        }
        view.ignoresSiblingOrder = false
        view.showsFPS = true
        view.showsNodeCount = true
        
        view.presentScene(gameScene)
    }
    
    override var shouldAutorotate: Bool {  return true }
    override var prefersStatusBarHidden: Bool { return true }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        UIDevice.current.userInterfaceIdiom == .phone ? .allButUpsideDown: .all
    }
    
    func showPauseScreen(_ viewController: UIViewController) {
        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.view.frame = view.bounds
        //animation
        viewController.view.alpha = 0
        UIView.animate(withDuration: 0.5) {
            viewController.view.alpha = 1
        }
    }
    
    func hidePauseScreen(viewController: UIViewController){
        viewController.willMove(toParent: nil)
        viewController.removeFromParent()
        //animation
        viewController.view.alpha = 1
        UIView.animate(withDuration: 0.5,
                       animations: { viewController.view.alpha = 0   })
        { (completed) in
            viewController.view.removeFromSuperview()
        }
    }
    
    @IBAction func pauseButtonPressed(_ sender: UIButton?) {
        gameScene.pauseTheGame()
        showPauseScreen(pauseViewController)
    }
    override func viewDidAppear(_ animated: Bool) {
        self.pauseButtonPressed(nil)
    }
}

extension GameViewController {
    private func openDeepLink() {
        let appURLScheme = "testspace://"
        guard let appURL = URL(string: appURLScheme) else { return }
        if UIApplication.shared.canOpenURL(appURL) {
            UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
        } else {
            print("can't load link")
        }
    }    
}
