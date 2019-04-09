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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scoreLabel.text = "Your Score: \(ViewController.instance!.score)"
    }
    @IBAction func backToMenu(_ sender: Any) {
        ViewController.instance?.quit()
        //dismiss(animated: true, completion: nil)
    }
}
