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
    
    func clamp(min: Float) -> Float {
        
        if self < min {
            
            return min
        }
        
        return self
    }
    
    func clamp(max: Float) -> Float {
        
        if self > max {
            
            return max
        }
        
        return self
    }
    
    func clamp(min: Float, max: Float) -> Float {
        
        if self < min {
            
            return min
        }
        
        if self > max {
            
            return max
        }
        
        return self
    }
}
