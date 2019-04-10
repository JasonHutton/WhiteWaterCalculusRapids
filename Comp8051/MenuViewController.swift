//
//  MenuViewController.swift
//  Comp8051
//
//  Created by Paul on 2019-04-08.
//  Copyright © 2019 Paul. All rights reserved.
//

import Foundation
import GLKit

class MenuViewController: GLKViewController {
    static var instance: MenuViewController?

    @IBOutlet weak var audioButton: UIButton!
    
    @IBOutlet weak var topScore: UILabel!
    
    @IBOutlet weak var secondScore: UILabel!
    
    @IBOutlet weak var thirdScore: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //scoreLabel.text = "Score: \(score)"
        MenuViewController.instance = self
        Settings.instance.playMusic(soundFile: "menu")
        
        topScore.text = "Top Score: \(Settings.instance.getSetting(name: "highScore1") as Int)"
        secondScore.text = "Second Score: \(Settings.instance.getSetting(name: "highScore2") as Int)"
        thirdScore.text = "Third Score: \(Settings.instance.getSetting(name: "highScore3") as Int)"
    }
    
    @IBAction func toggleAudio(_ sender: Any) {
        if(Settings.instance.getSetting(name: Settings.Names.playMusic.rawValue)) {
            Settings.instance.setSetting(name: Settings.Names.playMusic.rawValue, value: false)
            Settings.instance.player.pause()
            let btnImage = UIImage(named: "mute")
            audioButton.setImage(btnImage, for: .normal)
        } else {
            Settings.instance.setSetting(name: Settings.Names.playMusic.rawValue, value: true)
            Settings.instance.player.play()
            let btnImage = UIImage(named: "notMute")
            audioButton.setImage(btnImage, for: .normal)
        }
    }
}
