//
//  FloatExtensions.swift
//  Comp8051
//
//  Created by Nathaniel on 2019-04-03.
//  Copyright © 2019 Paul. All rights reserved.
//

extension Float {
    
    static func lerp(start: Float, end: Float, t: Float) -> Float {
        
        return (1 - t) * start + t * end
    }
}
