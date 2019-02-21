//
//  ECS.swift
//  Comp8051
//
//  Created by Nathaniel on 2019-02-20.
//  Copyright © 2019 Paul. All rights reserved.
//

public class ECS {
    
    // singleton instance
    static let instance = ECS()
    
    var gameObjects : [GameObject] = []
    
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
    
    // Update all game objects
    func update(deltaTime : Float) {
        
        for gameObject in self.gameObjects {
            gameObject.update(deltaTime: deltaTime)
        }
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
