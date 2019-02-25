//
//  Transform.swift
//  Comp8051
//
//  Created by Nathaniel on 2019-02-23.
//  Copyright © 2019 Paul. All rights reserved.
//

struct Transform {
    var position = Vector3(x: 0, y: 0, z: 0)
    var scale = Vector3(x: 1, y: 1, z: 1)
    var rotation = Vector3(x: 0, y: 0, z: 0)
    
    // addition operator
    static func +(left: Transform, right: Transform) -> Transform {
        
        var transform = Transform()
        
        transform.position = left.position + right.position
        transform.scale = left.scale * right.scale
        transform.rotation = left.rotation + right.rotation // this probably won't give predictable results
        
        return transform
    }
    
    static func +=(left: inout Transform, right: Transform) {
        
        left.position += right.position
        left.scale *= right.scale
        left.rotation += right.rotation // this probably won't give predictable results
    }
    
    // subtraction operator
    static func -(left: Transform, right: Transform) -> Transform {
        
        var transform = Transform()
        
        transform.position = left.position - right.position
        transform.scale = left.scale / right.scale
        transform.rotation = left.rotation - right.rotation // this probably won't give predictable results
        
        return transform
    }
    
}
