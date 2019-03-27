//
//  GravityManager.swift
//  Comp8051
//
//  Created by Nathaniel on 2019-03-24.
//  Copyright © 2019 Paul. All rights reserved.
//

class GravityManager : Component {
    
    private let DOWN_VECTOR = Vector3(x:0, y:-1, z:0)
    
    override func update(deltaTime: Float) {
        
        var gravity = Input.instance.gravity
        
        // always point input gravity downward
        gravity.y = -gravity.y.magnitude
        
        // clamp angle to 45 degrees
        let angle = Vector3.dotProduct(left: gravity, right: DOWN_VECTOR) / gravity.magnitude2D
        if angle <= 0.5 {
            
            gravity = Vector3(x:gravity.x / gravity.x.magnitude, y:-1, z:0).normalized2D
        }
        
        // flip gravity if the tap input is enabled
        if Input.instance.tapped {
            
            gravity.y *= -1
        }
        
        print(gravity.description)
        
        PhysicsWrapper.setGravityX(gravity.x, y: gravity.y)
    }
}
