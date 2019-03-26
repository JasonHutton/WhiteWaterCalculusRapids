//
//  Gravity.swift
//  Comp8051
//
//  Created by Jason Hutton on 2019-03-25.
//  Copyright © 2019 Paul. All rights reserved.
//

import Foundation

class Gravity {
    private static let instance = Gravity()
    private(set) static var gravity = Vector3()
    private(set) static var defaultGravity = Vector3(x: 0, y: -1, z: 0).normalized
    private static var inverted = Bool(booleanLiteral: false)
    
    static func start () {
        instance.respond()
        
        gravity = self.defaultGravity
    }
    
    static func invertGravity() {
        if(inverted) { inverted = false } else { inverted = true }
        var g = gravity.y
        if(inverted) {
            g = -g
        }
        setGravity(x: gravity.x, y: g, z: gravity.y)
    }
    
    // hey, this is goofy, but it does work
    private func respond () {
        print("Gravity initialized.")
    }
    
    static func setGravity(gravity: Vector3) {
        var g = gravity.y
        if(inverted) {
            g = -g
        }
        self.gravity = Vector3(x: gravity.x, y: g, z: 0).normalized
    }
    
    static func setGravity(x: Float, y: Float, z: Float) {
        setGravity(gravity: Vector3(x: x, y: y, z: z))
    }
}
