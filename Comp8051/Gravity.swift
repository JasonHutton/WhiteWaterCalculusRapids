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
        self.gravity = self.defaultGravity
        inverted = Bool(booleanLiteral: false)
    }
    
    func invertGravity() {
        if(inverted) {
            inverted = false
        } else {
            inverted = true
        }

        setGravity(x: self.gravity.x, y: self.gravity.y, z: self.gravity.z)
    }
    
    // hey, this is goofy, but it does work
    private func respond () {
        print("Gravity initialized.")
    }
    
    func setGravity(gravity: Vector3) {
        var g = -1//self.gravity.y // This is initially set to the default gravity.y and never actually set from inputs.
        if(inverted) {
            g = 1//-g
        }
        self.gravity = Vector3(x: gravity.x, y: Float(g), z: 0)
        print(self.gravity.y)
    }
    
    func setGravity(x: Float, y: Float, z: Float) {
        setGravity(gravity: Vector3(x: x, y: y, z: z))
    }
}
