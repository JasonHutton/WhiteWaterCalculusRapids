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
    func addParentGameObject(gameObject : GameObject) {
        
        gameObjects.append(gameObject)
    }
    
    // Remove a game object, if it exists
    func removeParentGameObject(gameObject : GameObject) {
        
        if let index = gameObjects.index(where: { $0 === gameObject}) {
            gameObjects.remove(at: index)
        }
    }
    
    // Returns the game object with the given tag
    func getParentGameObject (tag : String) -> GameObject? {
        
        for gameObject in gameObjects {
            if gameObject.tag == tag {
                return gameObject
            }
        }
        
        return nil;
    }
    
    // Update all game objects
    func update(deltaTime : Float) {
        
        for gameObject in self.gameObjects {
            gameObject.update(deltaTime: deltaTime)
        }
    }
}
