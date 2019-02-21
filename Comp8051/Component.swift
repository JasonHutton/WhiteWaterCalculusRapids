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
    
    // whether the component is activated
    private var _active : Bool = true
    var active : Bool {
        get {
            return _active
        }
        set {
            if !active && newValue {
                onEnable()
            }
            else if active && !newValue {
                onDisable()
            }
            _active = newValue
        }
    }
    
    // called every frame
    func update(deltaTime : Float) {
        // does nothing by default, to be implemented by subclasses
    }
    
    // called when active is set to true
    func onEnable () {
        // does nothing by default, to be implemented by subclasses
    }
    
    // called when active is set to false
    func onDisable () {
        // does nothing by default, to be implemented by subclasses
    }
}
