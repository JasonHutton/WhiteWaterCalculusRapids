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
    
    @IBAction func backToMenu(_ sender: Any) {
        GameViewController.instance?.quit()
        //dismiss(animated: true, completion: nil)
    }
}
