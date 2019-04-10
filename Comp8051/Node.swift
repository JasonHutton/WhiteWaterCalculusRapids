//
//  Node.swift
//  Comp8051
//
//  Created by Nathaniel on 2019-04-09.
//  Copyright © 2019 Paul. All rights reserved.
//

class Node {
    
    let yOffset: Float
    private var gameObjects = [GameObject]()
    
    init(y: Float) {
        yOffset = y
    }
    
    func add(gameObject: GameObject) {
        
        gameObjects.append(gameObject)
    }
    
    func destroy() {
        
        for obj in gameObjects {
            
            obj.destroy()
        }
        
        gameObjects.removeAll()
    }
}
