//
//  File.swift
//  Comp8051
//
//  Created by Nathaniel on 2019-02-20.
//  Copyright © 2019 Paul. All rights reserved.
//

class GameObject {
    
    // root game object in hierarchy
    static let root = GameObject(tag: "Root")
    
    // Unique identifier tag string
    private(set) var tag : String
    
    // reference to parent game object, if it exists
    weak var parent : GameObject?
    
    // whether the game object is activated
    var active : Bool = true
    
    var transform = Transform()
    
    // the transform, relative to all the transforms above in the hierarchy
    var worldTransform: Transform {
        
        get {
            
            var gameObject: GameObject? = self
            var transform = Transform()
            
            while (gameObject != nil) {
                
                transform += gameObject!.transform
                gameObject = gameObject!.parent
            }
            
            return transform
        }
        
        set {
            
            if let parentTransform = parent?.worldTransform {
                
                self.transform = newValue - parentTransform
            } else {
                
                self.transform = newValue
            }
        }
    }
    
    // collection of components
    private var components : [Component] = []
    
    // collection of child game objects
    private var children : [GameObject] = []
    
    // Initialization, adds itself to parent's collection
    init (tag : String) {
        
        self.tag = tag
    }
    
    // Update this object by updating all components
    // Should ONLY be called by the view controller
    func update (deltaTime : Float) {
        
        for component in self.components {
            if component.active {
                component.update(deltaTime: deltaTime)
            }
        }
        
        for child in self.children {
            if child.active {
                child.update(deltaTime: deltaTime)
            }
        }
    }
    
    // Update this object by updating all components
    // Should ONLY be called by the view controller
    func lateUpdate (deltaTime : Float) {
        
        for component in self.components {
            if component.active {
                component.lateUpdate(deltaTime: deltaTime)
            }
        }
        
        for child in self.children {
            if child.active {
                child.lateUpdate(deltaTime: deltaTime)
            }
        }
    }
    
    // remove references to this gameobject and all children and allow components to clean up
    func destroy () {
        
        parent?.removeChild(gameObject: self)
        
        for component in components {
            component.onDestroy()
        }
        components.removeAll()
        
        for gameObject in children {
            gameObject.destroy()
        }
        children.removeAll()
    }
    
    
    /* Component Functions */
    
    // Add a component to this gameobject
    func addComponent(component : Component) {
        components.append(component)
        component.gameObject = self
        
        if (component.active)
        {
            component.onEnable()
        }
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
    func addChild(gameObject : GameObject) {
        
        children.append(gameObject)
        gameObject.parent = self
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
