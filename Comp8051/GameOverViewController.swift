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
        let score = ViewController.instance?.score
        
        if score! > Settings.instance.getSetting(name: "highScore1") {
            Settings.instance.setSetting(name: "highScore1", value: score!, explicitSave: true)
            message.text = "1st Place!"
        } else if score! > Settings.instance.getSetting(name: "highScore2") {
            Settings.instance.setSetting(name: "highScore2", value: score!, explicitSave: true)
            message.text = "2nd Place!"
        } else if score! > Settings.instance.getSetting(name: "highScore3") {
            Settings.instance.setSetting(name: "highScore3", value: score!, explicitSave: true)
            message.text = "3rd Place!"
        }
        
        scoreLabel.text = "Your Score: \(ViewController.instance!.score)"
    }
    @IBAction func backToMenu(_ sender: Any) {
        ViewController.instance?.quit()
        //dismiss(animated: true, completion: nil)
    }
}
