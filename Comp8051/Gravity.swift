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
    private(set) var gravity = Vector3()
    private(set) var defaultGravity = Vector3(x: 0, y: -1, z: 0).normalized
    private var inverted = Bool()
    
    static func start () {
        instance.respond()
    }
    
    init() {
        gravity = self.defaultGravity
        inverted = Bool(booleanLiteral: false)
    }
    
    func invertGravity() {
        if(inverted) {
            inverted = false
        } else {
            inverted = true
        }

        setGravity(x: gravity.x, y: gravity.y, z: gravity.z)
    }
    
    // hey, this is goofy, but it does work
    private func respond () {
        print("Gravity initialized.")
    }
    
    func setGravity(gravity: Vector3) {
        var g = gravity.y // This is initially set to the default gravity.y and never actually set from inputs.
        if(inverted) {
            g = -g
        }
        self.gravity = Vector3(x: gravity.x, y: g, z: 0).normalized
    }
    
    func setGravity(x: Float, y: Float, z: Float) {
        setGravity(gravity: Vector3(x: x, y: y, z: z))
    }
}
