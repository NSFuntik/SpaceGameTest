//
//  PauseViewController.swift
//  SpaceWar
//
//  Created by Mikhailov on 17.07.2020.
//

import UIKit
import FBSDKLoginKit

protocol IPauseVCDelegate {
    func pauseVCPlayButton(_ viewController: PauseViewController)
    func pauseVCMusicButton(_ viewController: PauseViewController)
}

class PauseViewController: UIViewController {
    
    var delegate: IPauseVCDelegate!
    @IBOutlet weak var musicButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoginButton()
    }
    
    @IBAction func musicButtonPress(_ sender: UIButton) {
        delegate.pauseVCMusicButton(self)
    }
    @IBAction func playButtonPess(_ sender: UIButton) {
        delegate.pauseVCPlayButton(self)
    }
    
    @IBAction func menuButtonPress(_ sender: FBLoginButton) {
        let webVC = WebViewController()
        addChild(webVC)
        view.addSubview(webVC.view)
        webVC.view.frame = view.bounds
        
        // animation
        webVC.view.alpha = 0
        UIView.animate(withDuration: 0.5) {
            webVC.view.alpha = 1
        }
    }
    
    func showLoginButton() {
        let loginButton = FBLoginButton()
        loginButton.permissions = ["public_profile", "email"]
        view.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: loginButton,
                           attribute: NSLayoutConstraint.Attribute.centerX,
                           relatedBy: NSLayoutConstraint.Relation.equal,
                           toItem: view,
                           attribute: NSLayoutConstraint.Attribute.centerX,
                           multiplier: 1,
                           constant: 0)
            .isActive = true
        NSLayoutConstraint(item: loginButton,
                           attribute: NSLayoutConstraint.Attribute.bottom,
                           relatedBy: NSLayoutConstraint.Relation.equal,
                           toItem: view,
                           attribute: NSLayoutConstraint.Attribute.bottom,
                           multiplier: 1,
                           constant: -150)
            .isActive = true
        // animation
        loginButton.alpha = 0
        UIView.animate(withDuration: 0.5) {
            loginButton.alpha = 1
        }
    }
}

