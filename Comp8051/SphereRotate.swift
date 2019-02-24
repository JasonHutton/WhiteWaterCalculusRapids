//
//  SphereRotate.swift
//  Comp8051
//
//  Created by Nathaniel on 2019-02-23.
//  Copyright © 2019 Paul. All rights reserved.
//

class SphereRotate : Component {
    
    var rotation: Float = 0
    
    override func update(deltaTime: Float) {
        rotation += Float.pi * deltaTime
        rotation = rotation.truncatingRemainder(dividingBy: Float.pi * 2)
        
        gameObject?.transform.rotation.z += 3.14 * deltaTime
    }
}
