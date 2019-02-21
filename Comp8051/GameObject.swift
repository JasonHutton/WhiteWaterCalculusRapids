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
    
    // The collection of Component objects attached to us
    var components : [Component] = []
    
    // The collection of child game objects
    var gameObjects : [GameObject] = []
    
    // Initialization
    init (tag : String) {
        
        self.tag = tag
    }
    
    // Add a component to this gameobject
    func addComponent(component : Component) {
        components.append(component)
        component.gameObject = self
    }
    
    // Remove a component from this game object, if we have it
    func removeComponent(component : Component) {
        
        // Figure out the index at which this component exists
        
        // Note the use of the === (three equals) operator,
        // which checks to see if two variables refer to the same object
        // (as opposed to "==", which checks to see if two variables
        // have the same value, which means different things for
        // different types of data)
        
        if let index = components.index(where: { $0 === component}) {
            components.remove(at: index)
        }
    }
    
    // Add a game object to the list of game objects to be updated
    func addGameObject(component : GameObject) {
        
        gameObjects.append(component)
    }
    
    // Remove a game object, if it exists
    func removeGameObject(gameObject : GameObject) {
        
        // Figure out the index at which this game object exists
        
        // Note the use of the === (three equals) operator,
        // which checks to see if two variables refer to the same object
        // (as opposed to "==", which checks to see if two variables
        // have the same value, which means different things for
        // different types of data)
        
        if let index = gameObjects.index(where: { $0 === gameObject}) {
            gameObjects.remove(at: index)
        }
    }
    
    // Update this object by updating all components
    func update(deltaTime : Float) {
        
        for component in self.components {
            component.update(deltaTime: deltaTime)
        }
        
        for gameObject in self.gameObjects {
            gameObject.update(deltaTime: deltaTime)
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
    
    // Returns the game object with the given tag
    func find (tag : String) -> GameObject? {
        
        for gameObject in gameObjects {
            if gameObject.tag == tag {
                return gameObject
            }
        }
        
        return nil;
    }
    
}
