//
//  File.swift
//  Comp8051
//
//  Created by Nathaniel on 2019-02-20.
//  Copyright © 2019 Paul. All rights reserved.
//

class GameObject {
    
    // Unique identifier tag string
    var tag : String
    
    // reference to parent game object, if it exists
    var parent : GameObject?
    
    // The collection of Component objects attached to us
    var components : [Component] = []
    
    // The collection of child game objects
    var children : [GameObject] = []
    
    // Initialization, adds itself to parent's collection
    init (tag : String, parent: GameObject?) {
        
        self.tag = tag
        self.parent = parent
        
        parent!.addChild(component: self)
    }
    
    // Update this object by updating all components
    func update(deltaTime : Float) {
        
        for component in self.components {
            component.update(deltaTime: deltaTime)
        }
        
        for child in self.children {
            child.update(deltaTime: deltaTime)
        }
    }
    
    
    /* Component Functions */
    
    // Add a component to this gameobject
    func addComponent(component : Component) {
        components.append(component)
        component.gameObject = self
    }
    
    // Remove a component from this game object, if we have it
    func removeComponent(component : Component) {
        
        if let index = components.index(where: { $0 === component}) {
            components.remove(at: index)
        }
    }
    
    // Returns the first component of type T attached to this
    // game object
    func getComponent<T: Component>() -> T? {
        
        for component in self.components {
            if let theComponent = component as? T {
                return theComponent
            }
        }
        
        return nil;
    }
    
    // Returns an array of all components of type T
    // (this returned array might be empty)
    func getComponents<T: Component>() -> [T] {
        
        var foundComponents : [T] = []
        
        for component in self.components {
            if let theComponent = component as? T {
                foundComponents.append(theComponent)
            }
        }
        
        return foundComponents
    }

    
    /* Children Functions */
    
    // Add a game object to the list of game objects to be updated
    func addChild(component : GameObject) {
        
        children.append(component)
    }
    
    // Remove a game object, if it exists
    func removeChild(gameObject : GameObject) {
        
        if let index = children.index(where: { $0 === gameObject}) {
            children.remove(at: index)
        }
    }
    
    // Returns the game object with the given tag
    func getChild (tag : String) -> GameObject? {
        
        for child in children {
            if child.tag == tag {
                return child
            }
        }
        
        return nil;
    }
    
}
