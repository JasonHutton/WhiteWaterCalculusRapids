//
//  BlockBody.swift
//  Comp8051
//
//  Created by Nathaniel on 2019-03-24.
//  Copyright © 2019 Paul. All rights reserved.
//

class BlockBody : Body {
    
    override func onEnable() {
        
        if let transform = gameObject?.worldTransform {
            
            if !initialized {
                
                PhysicsWrapper.addGroundBody(tag, posX: transform.position.x, posY: transform.position.y, scaleX: transform.scale.x, scaleY: transform.scale.y, rotation: transform.rotation.z)
                initialized = true
            }
        }
    }

}
