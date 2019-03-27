//
//  SphereBehaviour.swift
//  Comp8051
//
//  Created by Nathaniel on 2019-02-25.
//  Copyright © 2019 Paul. All rights reserved.
//

class SphereBehaviour : Component {
    
    var velocity = Vector3()
    var g: Float = 9.81
    let stoppingPoint: Float = -2 + 1 + 0.05
    // sort-of arbitrary value, based of radius of sphere and where edge of platform is
    
    override func update(deltaTime: Float) {
        
        if var transform = gameObject?.worldTransform {
            
            // handle the ball's position
            let gravity = g * Input.instance.gravity.gravity
            
            transform.position += velocity * deltaTime + 1/2 * gravity * deltaTime * deltaTime
            velocity += gravity * deltaTime
            
            // stop moving the ball down if it's at the point where it should collide with the platform
            if transform.position.y <= stoppingPoint {
                transform.position.y = stoppingPoint
                velocity.y = 0
            }
            
            // and let's also just clamp the ball's position to something somewhat reasonable, so it doesn't get lost :)
            if transform.position.magnitude2D > 10 {
                transform.position.clampMagnitude2D(max: 10)
                velocity.x = 0
                velocity.y = 0
            }
            
            // handle the ball's rotation, in a dumb easy way
            transform.rotation.z = -transform.position.x
            
            // assign
            gameObject!.transform.position = transform.position
            gameObject!.transform.rotation = transform.rotation
            
        }
    }
}
