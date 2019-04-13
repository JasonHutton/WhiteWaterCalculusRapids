//
//  DeathWallBehaviour.swift
//  Comp8051
//
//  Created by Nathaniel on 2019-04-03.
//  Copyright © 2019 Paul. All rights reserved.
//

class DeathWallBehaviour : Component {
    
    private let trackedObj: GameObject
    private let acceleration: Float
    private var velocity: Float
    private let maxVelocity: Float
    private var maxDist: Float
    private let shader: BaseEffect
    
    init(trackedObj: GameObject, acceleration: Float, initialVelocity: Float, maxVelocity: Float, maxDist: Float, shader: BaseEffect) {
        
        self.trackedObj = trackedObj
        self.acceleration = acceleration
        velocity = initialVelocity
        self.maxVelocity = maxVelocity
        self.maxDist = maxDist
        self.shader = shader
    }
    
    override func lateUpdate(deltaTime: Float) {
        
        if var pos = gameObject?.transform.position {
            
            pos.y -= velocity * deltaTime
            velocity += acceleration * deltaTime
            velocity = velocity.clamp(max: maxVelocity)
            
            if pos.y - trackedObj.transform.position.y > maxDist {
                
                pos.y = trackedObj.transform.position.y + maxDist
            }
            
            let camPos = GameObject.root.getChild(tag: "Camera")!.worldTransform.position
   
            gameObject!.transform.position = pos
            shader.pointLightPosition = pos - camPos
        }
    }
}
