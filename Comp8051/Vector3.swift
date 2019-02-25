//
//  Vector3.swift
//  Comp8051
//
//  Created by Nathaniel on 2019-02-23.
//  Copyright © 2019 Paul. All rights reserved.
//

struct Vector3 {
    var x: Float
    var y: Float
    var z: Float
    
    init(x: Float, y: Float, z: Float) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    // addition operator
    static func +(left: Vector3, right: Vector3) -> Vector3 {
        return Vector3(x: left.x + right.x, y: left.y + right.y, z: left.z + right.z)
    }
    
    static func +=(left: inout Vector3, right: Vector3) {
        left.x += right.x
        left.y += right.y
        left.z += right.z
    }
    
    // subtraction operator
    static func -(left: Vector3, right: Vector3) -> Vector3 {
        return Vector3(x: left.x - right.x, y: left.y - right.y, z: left.z - right.z)
    }
    
    static func -=(left: inout Vector3, right: Vector3) {
        left.x -= right.x
        left.y -= right.y
        left.z -= right.z
    }
    
    // multiplication operator
    static func *(left: Vector3, right: Vector3) -> Vector3 {
        return Vector3(x: left.x * right.x, y: left.y * right.y, z: left.z * right.z)
    }
    
    static func *=(left: inout Vector3, right: Vector3) {
        left.x *= right.x
        left.y *= right.y
        left.z *= right.z
    }
    
    static func *(left: Vector3, right: Float) -> Vector3 {
        return Vector3(x: left.x * right, y: left.y * right, z: left.z * right)
    }
    
    static func *=(left: inout Vector3, right: Float) {
        left.x *= right
        left.y *= right
        left.z *= right
    }
    
    // division operator
    static func /(left: Vector3, right: Vector3) -> Vector3 {
        return Vector3(x: left.x / right.x, y: left.y / right.y, z: left.z / right.z)
    }
    
    static func /=(left: inout Vector3, right: Vector3) {
        left.x /= right.x
        left.y /= right.y
        left.z /= right.z
    }
    
}
