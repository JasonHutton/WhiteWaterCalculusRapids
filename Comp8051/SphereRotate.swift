//
//  SphereRotate.swift
//  Comp8051
//
//  Created by Nathaniel on 2019-02-23.
//  Copyright © 2019 Paul. All rights reserved.
//

class SphereRotate : Component {
    
    var rotation: Vector3
    
    init(rotx: Float, roty: Float, rotz: Float) {
        rotation = Vector3(x: rotz * 3.14 , y:roty * 3.14 , z:rotz * 3.14 )
    }
    
    override func update(deltaTime: Float) {
        gameObject?.transform.rotation += rotation * deltaTime
    }
}
