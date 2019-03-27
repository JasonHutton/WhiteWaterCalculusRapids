//
//  GravityManager.swift
//  Comp8051
//
//  Created by Nathaniel on 2019-03-24.
//  Copyright © 2019 Paul. All rights reserved.
//

class GravityManager : Component {
    
    override func update(deltaTime: Float) {
        
        var gravity = Input.instance.gravity
        
        gravity.y = -gravity.y.magnitude
        
        // clamp angle to 45 degrees
        
        
        // flip gravity if the tap input is enabled
        if Input.instance.tapped {
            
            gravity.y *= -1
        }
        
        PhysicsWrapper.setGravityX(gravity.x, y: gravity.y)
    }
}
