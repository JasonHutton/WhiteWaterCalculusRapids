//
//  GravityManager.swift
//  Comp8051
//
//  Created by Nathaniel on 2019-03-24.
//  Copyright © 2019 Paul. All rights reserved.
//

class GravityManager : Component {
    
    override func update(deltaTime: Float) {
        
        PhysicsWrapper.setGravityX(Input.instance.gravity.gravity.x, y: Input.instance.gravity.gravity.y)
    }
}
