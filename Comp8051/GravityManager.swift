//
//  GravityManager.swift
//  Comp8051
//
//  Created by Nathaniel on 2019-03-24.
//  Copyright © 2019 Paul. All rights reserved.
//

class GravityManager : Component {
    private var gravity = Vector3()
    private var gravityChanged = Bool()
    
    override init() {
        gravity = Input.instance.gravity.gravity
        gravityChanged = true
    }
    
    override func update(deltaTime: Float) {
        if(gravityChanged) {
            PhysicsWrapper.setGravityX(gravity.x, y: gravity.y)
            gravityChanged = false
        }
        
        if(!gravity.EqualTo(other: Input.instance.gravity.gravity)) {
            gravity = Input.instance.gravity.gravity
            gravityChanged = true
        }
    }
}
