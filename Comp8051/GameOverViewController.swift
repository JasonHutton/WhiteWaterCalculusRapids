//
//  GameOverViewController.swift
//  Comp8051
//
//  Created by Paul on 2019-04-08.
//  Copyright © 2019 Paul. All rights reserved.
//

import Foundation
import GLKit

class GameOverViewController: GLKViewController {
    
    @IBAction func backToMenu(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
