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
    private static var iterator = 0
    
    init(tag: String) {
        
        self.tag = tag + " " + String(Body.iterator)
        Body.iterator += 1
    }
    
    // called when an attached body collides with another
    func onCollisionEnter (tag: String) {
        
        if let cs: CollisionSound = self.gameObject?.getComponent() {
            
            cs.Collide()
        }
    }
    
    // called when an attached body stops colliding with another
    func onCollisionExit (tag: String) {}
}
