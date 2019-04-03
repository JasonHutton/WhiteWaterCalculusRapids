//
//  DeathWallBehaviour.swift
//  Comp8051
//
//  Created by Nathaniel on 2019-04-03.
//  Copyright © 2019 Paul. All rights reserved.
//

class DeathWallBehaviour : Component {
    
    override func update(deltaTime: Float) {
        
        if var pos = gameObject?.transform.position {
            
            pos.y -= 0.05
            gameObject!.transform.position = pos
        }
    }
}
