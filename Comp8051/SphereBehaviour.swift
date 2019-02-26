//
//  SphereBehaviour.swift
//  Comp8051
//
//  Created by Nathaniel on 2019-02-25.
//  Copyright © 2019 Paul. All rights reserved.
//

class SphereBehaviour : Component {
    
    var velocity = Vector3()
    var gravity = Vector3(x: 0, y: -9.81, z: 0)
    let stoppingPoint: Float = -2 + 0.5 + 0.05
    
    override func update(deltaTime: Float) {
        
        if var pos = gameObject?.worldTransform.position {
            
            pos += velocity * deltaTime + 1/2 * gravity * deltaTime * deltaTime
            velocity += gravity * deltaTime
            
            if pos.y < stoppingPoint {
                pos.y = stoppingPoint
            }
            
            gameObject!.transform.position = pos
            
        }
    }
}
