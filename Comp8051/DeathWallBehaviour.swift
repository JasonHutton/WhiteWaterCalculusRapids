//
//  DeathWallBehaviour.swift
//  Comp8051
//
//  Created by Nathaniel on 2019-04-03.
//  Copyright © 2019 Paul. All rights reserved.
//

class DeathWallBehaviour : Component {
    
    private let player: GameObject
    private let acceleration: Float
    private var velocity: Float
    private var maxDist: Float
    private let shader: BaseEffect
    
    init(player: GameObject, acceleration: Float, initialVelocity: Float, maxDist: Float, shader: BaseEffect) {
        
        self.player = player
        self.acceleration = acceleration
        velocity = initialVelocity
        self.maxDist = maxDist
        self.shader = shader
    }
    
    override func update(deltaTime: Float) {
        
        if var pos = gameObject?.transform.position {
            
            pos.y -= velocity * deltaTime
            velocity += acceleration * deltaTime
            
            if pos.y - player.transform.position.y > maxDist {
                
                pos.y = player.transform.position.y + maxDist
            }
            
            gameObject!.transform.position = pos
            shader.pointLightPosition = pos
        }
    }
}
