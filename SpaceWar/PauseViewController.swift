//
//  PauseViewController.swift
//  SpaceWar
//
//  Created by Mikhailov on 17.07.2020.
//

import UIKit
import FBSDKLoginKit

protocol PauseVCDelegate {
    func pauseVCPlayButton(_ viewController: PauseViewController)
    func pauseVCSoundButton(_ viewController: PauseViewController)
    func pauseVCMusicButton(_ viewController: PauseViewController)
}

class PauseViewController: UIViewController {
    
    @IBOutlet weak var musicButton: UIButton!
    
    var delegate: PauseVCDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoginScreen()
        
    }
    
    
    @IBAction func musicButtonPress(_ sender: UIButton) {
        delegate.pauseVCMusicButton(self)
    }
    @IBAction func playButtonPess(_ sender: UIButton) {
        delegate.pauseVCPlayButton(self)
    }
    
    @IBAction func menuButtonPress(_ sender: FBLoginButton) {
        
    }
    
    @IBAction func storeButtonPress(_ sender: UIButton) {
    }
    
    func showLoginScreen() {
        let loginButton = FBLoginButton()
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.permissions = ["public_profile", "email"]
        view.addSubview(loginButton)
        NSLayoutConstraint(item: loginButton, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: loginButton, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: -150).isActive = true
        loginButton.alpha = 0
        UIView.animate(withDuration: 0.5) {
            loginButton.alpha = 1
        }
    }
}

