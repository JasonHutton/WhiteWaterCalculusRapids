//
//  KinematicBlockBody.swift
//  Comp8051
//
//  Created by Nathaniel on 2019-04-03.
//  Copyright © 2019 Paul. All rights reserved.
//

class KinematicBlockBody : Body {
    
    override func onEnable() {
        
        if let transform = gameObject?.worldTransform {
            
            if !initialized {
                
                PhysicsWrapper.addGroundBody(tag, posX: transform.position.x, posY: transform.position.y, scaleX: transform.scale.x, scaleY: transform.scale.y, rotation: transform.rotation.z)
                initialized = true
            }
        }
    }
    
    override func update(deltaTime: Float) {
        
        if let transform = gameObject?.worldTransform {
            
            var cTransform = CTransform()
            cTransform.position = transform.position.convertToCVector()
            cTransform.rotation = transform.rotation.z
            
            gameObject!.worldTransform = transform
            PhysicsWrapper.setBodyPosition(tag, transform: cTransform)
        }
    }
    
}
