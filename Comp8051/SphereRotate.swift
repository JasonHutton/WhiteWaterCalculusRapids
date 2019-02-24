//
//  SphereRotate.swift
//  Comp8051
//
//  Created by Nathaniel on 2019-02-23.
//  Copyright © 2019 Paul. All rights reserved.
//

class SphereRotate : Component {
    
    override func update(deltaTime: Float) {
        gameObject?.transform.rotation.z += 3.14 * deltaTime
    }
}
