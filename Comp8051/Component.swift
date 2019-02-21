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
            if !active && newValue { // calls onEnable if being set from false to true
                onEnable()
            } else if active && !newValue { // calls onDisable if being set from true to false
                onDisable()
            }
            _active = newValue
        }
    }
    
    
    /* Functions to be implemented by subclasses */
    
    // called every frame
    func update(deltaTime : Float) {}
    
    // called when active is set to true
    func onEnable () {}
    
    // called when active is set to false
    func onDisable () {}
    
    // called when component is destroyed
    func onDestroy () {}
    
}
