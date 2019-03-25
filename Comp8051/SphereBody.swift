//
//  SphereBody.swift
//  Comp8051
//
//  Created by Nathaniel on 2019-03-24.
//  Copyright © 2019 Paul. All rights reserved.
//

class SphereBody : Component {
    
    private var tag: String;
    
    init(tag: String) {
        
        self.tag = tag
        super.init()
        
        if let transform = gameObject?.worldTransform {
            
            PhysicsWrapper.addBallBody(tag, posX: transform.position.x, posY: transform.position.y, radius: transform.scale.x / 2)
        }
    }
    
    override func update(deltaTime: Float) {
        
        if var transform = gameObject?.worldTransform {
            
            let pos = Vector3.convert(cVector3:PhysicsWrapper.getBodyPos(tag));
            
            transform.position = pos;
        }
    }
}
