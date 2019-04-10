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

    @IBOutlet weak var musicButton: UIButton!
    @IBOutlet weak var soundButton: UIButton!
    @IBOutlet weak var topScore: UILabel!
    
    @IBOutlet weak var secondScore: UILabel!
    
    @IBOutlet weak var thirdScore: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //scoreLabel.text = "Score: \(score)"
        MenuViewController.instance = self
        Settings.instance.playMusic(soundFile: "menu")
        
        topScore.text = "1st: \(Settings.instance.getSetting(name: "highScore1") as Int)"
        secondScore.text = "2nd: \(Settings.instance.getSetting(name: "highScore2") as Int)"
        thirdScore.text = "3rd: \(Settings.instance.getSetting(name: "highScore3") as Int)"
        
        
        if(!Settings.instance.getSetting(name: Settings.Names.playMusic.rawValue)) {
            let btnImage = UIImage(named: "musicMute")
            musicButton.setImage(btnImage, for: .normal)
        } else {
            let btnImage = UIImage(named: "musicNotMute")
            musicButton.setImage(btnImage, for: .normal)
        }
        
        if(!Settings.instance.getSetting(name: Settings.Names.playSound.rawValue)) {
            let btnImage = UIImage(named: "mute")
            soundButton.setImage(btnImage, for: .normal)
        } else {
            let btnImage = UIImage(named: "notMute")
            soundButton.setImage(btnImage, for: .normal)
        }
        
    }
    
    @IBAction func toggleMusic(_ sender: Any) {
        if(Settings.instance.getSetting(name: Settings.Names.playMusic.rawValue)) {
            Settings.instance.setSetting(name: Settings.Names.playMusic.rawValue, value: false)
            Settings.instance.player.pause()
            let btnImage = UIImage(named: "musicMute")
            musicButton.setImage(btnImage, for: .normal)
        } else {
            Settings.instance.setSetting(name: Settings.Names.playMusic.rawValue, value: true)
            Settings.instance.player.play()
            let btnImage = UIImage(named: "musicNotMute")
            musicButton.setImage(btnImage, for: .normal)
        }
    }
    
    @IBAction func toggleSound(_ sender: Any) {
        if(Settings.instance.getSetting(name: Settings.Names.playSound.rawValue)) {
            Settings.instance.setSetting(name: Settings.Names.playSound.rawValue, value: false)
            let btnImage = UIImage(named: "mute")
            soundButton.setImage(btnImage, for: .normal)
        } else {
            Settings.instance.setSetting(name: Settings.Names.playSound.rawValue, value: true)
            let btnImage = UIImage(named: "notMute")
            soundButton.setImage(btnImage, for: .normal)
        }
    }}
