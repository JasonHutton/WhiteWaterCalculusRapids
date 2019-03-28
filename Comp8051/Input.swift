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
    
    public var gravity = Vector3()
    public var tapped = false
    
    public static let instance = Input()
    private let motion = CMMotionManager()
    
    static func start () {
        instance.respond()
    }
    
    // hey, this is goofy, but it does work
    private func respond () {
        print("Input initialized.")
    }
    
    init() {
        
        if motion.isDeviceMotionAvailable {
            motion.deviceMotionUpdateInterval = 1/30
            motion.startDeviceMotionUpdates(to: .main) {
                (data, error) in
                guard let data = data, error == nil else {
                    return
                }
                
                self.gravity = Vector3(x:Float(data.gravity.x), y:Float(data.gravity.y), z: 0).normalized2D
            }
        } else {
            self.gravity = Vector3(x:0, y:-1, z: 0)
            print("Error: Device motion not available. Defaulting gravity to (0, -1, 0).")
        }
    }
}
