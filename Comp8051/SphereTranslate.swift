//
//  SphereTranslate.swift
//  Comp8051
//
//  Created by Paul on 2019-02-23.
//  Copyright © 2019 Paul. All rights reserved.
//

class SphereTranslate : Component {
    
    var translation: Float = 0
    
    override func update(deltaTime: Float) {
        translation += deltaTime
        
        gameObject?.transform.position.y -= deltaTime
    }
}

