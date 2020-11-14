//
//  PauseViewController.swift
//  SpaceWar
//
//  Created by Mikhailov on 17.07.2020.
//

import UIKit

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
       
    }
    
    
    @IBAction func musicButtonPress(_ sender: UIButton) {
        delegate.pauseVCMusicButton(self)
    }
    @IBAction func playButtonPess(_ sender: UIButton) {
        delegate.pauseVCPlayButton(self)
    }
    
    @IBAction func menuButtonPress(_ sender: UIButton) {
    }
    
    @IBAction func storeButtonPress(_ sender: UIButton) {
    }
}
