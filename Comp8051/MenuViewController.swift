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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //scoreLabel.text = "Score: \(score)"
        
        Settings.instance.playMusic(soundFile: "menu")
    }
}
