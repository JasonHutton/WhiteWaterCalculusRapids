//
//  SphereRotate.swift
//  Comp8051
//
//  Created by Nathaniel on 2019-02-23.
//  Copyright © 2019 Paul. All rights reserved.
//

class SphereRotate : Component {
    
    var rotationx: Float = 0
    var rotationy: Float = 0
    var rotationz: Float = 0
    
    init(rotx: Float, roty: Float, rotz: Float) {
        rotationx = rotx
        rotationy = roty
        rotationz = rotz
    }
    
    override func update(deltaTime: Float) {
        gameObject?.transform.rotation.x += rotationx * 3.14 * deltaTime
        gameObject?.transform.rotation.y += rotationy * 3.14 * deltaTime
        gameObject?.transform.rotation.z += rotationz * 3.14 * deltaTime
    }
}
