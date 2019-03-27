//
//  Input.swift
//  Comp8051
//
//  Created by Nathaniel on 2019-02-26.
//  Copyright © 2019 Paul. All rights reserved.
//

import CoreMotion
import UIKit

class Input {
    
    public let gravity = Gravity()
    
    public static let instance = Input()
    private let motion = CMMotionManager()
    //private lazy var tap = UITapGestureRecognizer(target: ViewController.instance, action:#selector(Input.instance.handleTap()))
    
    static func start () {
        instance.respond()
    }
    
    // hey, this is goofy, but it does work
    private func respond () {
        print("Input initialized.")
    }
    
    @objc func handleTap() {
        
    }
    
    init() {
        
        if motion.isDeviceMotionAvailable {
            motion.deviceMotionUpdateInterval = 1/30
            motion.startDeviceMotionUpdates(to: .main) {
                (data, error) in
                guard let data = data, error == nil else {
                    return
                }
                
                self.gravity.setGravity(gravity: Vector3(x: Float(data.gravity.x), y: Float(data.gravity.y), z: Float(data.gravity.z)))
            }
        } else {
            print("Error: Device motion not available. Defaulting gravity to (0, -1, 0).") // Gravity() already defaults
        }
    }
    
}
