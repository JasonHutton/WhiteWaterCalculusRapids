//
//  SphereTranslate.swift
//  Comp8051
//
//  Created by Paul on 2019-02-23.
//  Copyright © 2019 Paul. All rights reserved.
//

class SphereTranslate : Component {
    
    var translationx: Float = 0
    var translationy: Float = 0
    var translationz: Float = 0
    
    init(transx: Float, transy: Float, transz: Float) {
        translationx = transx
        translationy = transy
        translationz = transz
    }
    
    override func update(deltaTime: Float) {
        gameObject?.transform.position.x += translationx * deltaTime
        gameObject?.transform.position.y += translationy * deltaTime
        gameObject?.transform.position.z += translationz * deltaTime
    }
}

