//
//  Body.swift
//  Comp8051
//
//  Created by Nathaniel on 2019-04-01.
//  Copyright © 2019 Paul. All rights reserved.
//

class Body: Component {
    
    public private(set) var tag: String;
    public var initialized = false;
    
    init(tag: String) {
        
        self.tag = tag
    }
    
    // called when an attached body collides with another
    func onCollisionEnter (tag: String) {}
    
    // called when an attached body stops colliding with another
    func onCollisionExit (tag: String) {}
}
