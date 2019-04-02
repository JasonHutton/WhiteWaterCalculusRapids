//
//  SphereBody.swift
//  Comp8051
//
//  Created by Nathaniel on 2019-03-24.
//  Copyright © 2019 Paul. All rights reserved.
//

class SphereBody : Body {
    
    override init(tag: String) {
        
        super.init(tag: tag)
        ContactPublisher.subscribe(body: self)
    }
    
    override func onEnable() {
        
        if let transform = gameObject?.worldTransform {
            
            if !initialized {
                
                PhysicsWrapper.addBallBody(tag, posX: transform.position.x, posY: transform.position.y, radius: transform.scale.x / 2)
                
                initialized = true
            }
        }
    }
    
    override func update(deltaTime: Float) {
        
        if gameObject != nil {
            
            let transform = PhysicsWrapper.getBodyTransform(tag)
            gameObject!.transform.position = Vector3.convertFromCVector(cVector: transform.position)
            gameObject!.transform.rotation.z = transform.rotation / 2
        }
    }
    
    override func onCollisionEnter (tag: String) {
        
        print(tag)
    }
}
