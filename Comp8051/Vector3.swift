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
    
    
    /* INITIALIZERS */
    
    init () {
        x = 0
        y = 0
        z = 0
    }
    
    init(x: Float, y: Float, z: Float) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    
    /* PROPERTIES */
    
    var magnitude: Float {
        get {
            return (x * x + y * y + z * z).squareRoot()
        }
    }
    
    var magnitude2D: Float {
        get {
            return (x * x + y * y).squareRoot()
        }
    }
    
    var normalized: Vector3 {
        get {
            let m = magnitude
            return Vector3(x: x / m, y: y / m, z: z / m)
        }
    }
    
    var normalized2D: Vector3 {
        get {
            let m = magnitude2D
            return Vector3(x: x / m, y: y / m, z: z)
        }
    }
    
    var description: String {
        get {
            return "(" + x.description + ", " + y.description + ", " + z.description + ")"
        }
    }
    
    
    /* FUNCTIONS */
    
    mutating func clampMagnitude (max: Float) {
        let m = max / magnitude
        x *= m
        y *= m
        z *= m
    }
    
    mutating func clampMagnitude2D (max: Float) {
        let m = max / magnitude2D
        x *= m
        y *= m
    }
    
    static func convertFromCVector (cVector: CVector) -> Vector3 {
        return Vector3 (x:cVector.x, y:cVector.y, z:0);
    }
    
    func convertToCVector () -> CVector {
        var cVec = CVector()
        cVec.x = x
        cVec.y = y
        
        return cVec
    }
    
    
    /* OPERATORS */
    
    // addition operators
    static func +(left: Vector3, right: Vector3) -> Vector3 {
        return Vector3(x: left.x + right.x, y: left.y + right.y, z: left.z + right.z)
    }
    
    static func +=(left: inout Vector3, right: Vector3) {
        left.x += right.x
        left.y += right.y
        left.z += right.z
    }
    
    // subtraction operators
    static func -(left: Vector3, right: Vector3) -> Vector3 {
        return Vector3(x: left.x - right.x, y: left.y - right.y, z: left.z - right.z)
    }
    
    static func -=(left: inout Vector3, right: Vector3) {
        left.x -= right.x
        left.y -= right.y
        left.z -= right.z
    }
    
    // multiplication operators
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
    
    static func *(left: Float, right: Vector3) -> Vector3 {
        return Vector3(x: right.x * left, y: right.y * left, z: right.z * left)
    }
    
    static func *=(left: inout Vector3, right: Float) {
        left.x *= right
        left.y *= right
        left.z *= right
    }
    
    // division operators
    static func /(left: Vector3, right: Vector3) -> Vector3 {
        return Vector3(x: left.x / right.x, y: left.y / right.y, z: left.z / right.z)
    }
    
    static func /=(left: inout Vector3, right: Vector3) {
        left.x /= right.x
        left.y /= right.y
        left.z /= right.z
    }
    
    static func /(left: Vector3, right: Float) -> Vector3 {
        return Vector3(x: left.x / right, y: left.y / right, z: left.z / right)
    }
    
    static func /=(left: inout Vector3, right: Float) {
        left.x /= right
        left.y /= right
        left.z /= right
    }
    
}
