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
    
    //private(set) static var gravity = Vector3()
    public static var gravity = Vector3()
    
    private static let instance = Input()
    private let motion = CMMotionManager()
    //private lazy var tap = UITapGestureRecognizer(target: ViewController.instance, action:#selector(Input.instance.handleTap()))
    
    static func start () {
        instance.respond()
        Gravity.start()
    }
    
    // hey, this is goofy, but it does work
    private func respond () {
        print("Input initialized.")
    }
    
    @objc func handleTap() {
        
    }
    
    init() {
        //tap.
        //let gr = UIGestureRecognizer()
        //gr.addg
        
        if motion.isDeviceMotionAvailable {
            motion.deviceMotionUpdateInterval = 1/30
            motion.startDeviceMotionUpdates(to: .main) {
                (data, error) in
                guard let data = data, error == nil else {
                    return
                }
                
                Gravity.setGravity(gravity: Vector3(x: Float(data.gravity.x), y: Float(data.gravity.y), z: Float(data.gravity.z)))
                Input.gravity = Gravity.gravity
                
            }
        } else {
            print("Error: Device motion not available. Defaulting gravity to (0, -1, 0).")
            Input.gravity = Gravity.defaultGravity
        }
    }
    
}
