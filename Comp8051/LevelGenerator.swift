//
//  LevelGenerator.swift
//  Comp8051
//
//  Created by Nathaniel on 2019-04-09.
//  Copyright © 2019 Paul. All rights reserved.
//

class LevelGenerator : Component {
    
    private let deleteObj: GameObject
    private let spawnAhead: Float
    private let level: Level
    
    init(deleteObj: GameObject, spawnAhead: Float, level: Level) {
        
        self.deleteObj = deleteObj
        self.spawnAhead = spawnAhead
        self.level = level
        
        level.loadEmptyNode(yOffset: Level.NODE_HEIGHT)
        level.loadEmptyNode(yOffset: 0)
    }
    
    override func update(deltaTime: Float) {
        
        // spawn a node if the player is far enough
        if let y = gameObject?.transform.position.y {
            
            let spawnedTo = level.nodes.peekBack()?.yOffset ?? 0
            
            if y - spawnAhead * Level.NODE_HEIGHT < spawnedTo {
                
                level.loadRandomNode(yOffset: spawnedTo - Level.NODE_HEIGHT)
            }
            
        }
        
        // delete nodes that are higher than the deleter
        if let frontPos = level.nodes.peekFront()?.yOffset {
            
            if frontPos > deleteObj.transform.position.y {
                
                level.nodes.dequeue()?.destroy()
            }
        }
    }
}
