//
//  GameOverViewController.swift
//  Comp8051
//
//  Created by Paul on 2019-04-08.
//  Copyright © 2019 Paul. All rights reserved.
//

import Foundation
import UIKit

class GameOverViewController: UIViewController {
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var message: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let score = ViewController.instance!.score
        let topScore = Settings.instance.getSetting(name: "highScore1") as Int
        let secondScore = Settings.instance.getSetting(name: "highScore2") as Int
        
        if score > Settings.instance.getSetting(name: "highScore1") {
            Settings.instance.setSetting(name: "highScore1", value: score, explicitSave: true)
            Settings.instance.setSetting(name: "highScore2", value: topScore, explicitSave: true)
            Settings.instance.setSetting(name: "highScore3", value: secondScore, explicitSave: true)
            
            message.text = "1st Place!"
        } else if score > Settings.instance.getSetting(name: "highScore2") {
            Settings.instance.setSetting(name: "highScore2", value: score, explicitSave: true)
            Settings.instance.setSetting(name: "highScore3", value: secondScore, explicitSave: true)
            
            message.text = "2nd Place!"
        } else if score > Settings.instance.getSetting(name: "highScore3") {
            Settings.instance.setSetting(name: "highScore3", value: score, explicitSave: true)

            message.text = "3rd Place!"
        }
        
        scoreLabel.text = "Your Score: \(ViewController.instance!.score)"
        
        MenuViewController.instance?.topScore.text = "Top Score: \(Settings.instance.getSetting(name: "highScore1") as Int)"
        MenuViewController.instance?.secondScore.text = "Second Score: \(Settings.instance.getSetting(name: "highScore2") as Int)"
        MenuViewController.instance?.thirdScore.text = "Third Score: \(Settings.instance.getSetting(name: "highScore3") as Int)"
    }
    @IBAction func backToMenu(_ sender: Any) {
        ViewController.instance?.quit()
        //dismiss(animated: true, completion: nil)
    }
}
