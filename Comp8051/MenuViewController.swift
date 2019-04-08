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
    
    @IBOutlet weak var audioButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //scoreLabel.text = "Score: \(score)"
        
        Settings.instance.playMusic(soundFile: "menu")
    }
    @IBAction func toggleAudio(_ sender: Any) {
        if(Settings.instance.getSetting(name: Settings.Names.playMusic.rawValue)) {
            Settings.instance.setSetting(name: Settings.Names.playMusic.rawValue, value: false)
            Settings.instance.player.pause()
            audioButton.setTitle("Un-mute Audio", for: .normal)
        } else {
            Settings.instance.setSetting(name: Settings.Names.playMusic.rawValue, value: true)
            Settings.instance.player.play()
            audioButton.setTitle("Mute Audio", for: .normal)
        }
    }
}
