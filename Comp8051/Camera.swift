//
//  Camera.swift
//  Comp8051
//
//  Created by Nathaniel on 2019-02-27.
//  Copyright © 2019 Paul. All rights reserved.
//

class Camera : Component {
    
    static var instance: GameObject?
    
    override init() {
        super.init()
        Camera.instance = gameObject
    }
}
