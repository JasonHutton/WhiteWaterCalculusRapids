//
//  VectorExtensions.swift
//  Comp8051
//
//  Created by Jason Hutton on 2019-03-27.
//  Copyright © 2019 Paul. All rights reserved.
//

import Foundation

extension Vector3 {
    static func Equals(vec1: Vector3, vec2: Vector3) -> Bool {
        if(vec1.x != vec2.x) { return false }
        if(vec1.y != vec2.y) { return false }
        if(vec1.z != vec2.z) { return false }
        
        return true
    }
    
    func EqualTo(other: Vector3) -> Bool {
        return Vector3.Equals(vec1: self, vec2: other)
    }
}
