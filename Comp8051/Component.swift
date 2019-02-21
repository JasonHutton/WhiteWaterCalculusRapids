//
//  File.swift
//  Comp8051
//
//  Created by Nathaniel on 2019-02-20.
//  Copyright © 2019 Paul. All rights reserved.
//

class Component {
    
    // The game object this component is attached to
    weak var gameObject : GameObject?
    
    // To be implemented in subclasses
    func update(deltaTime : Float) {
        // Update this component
        fatalError("Subclasses need to implement the update method.")
    }
}
