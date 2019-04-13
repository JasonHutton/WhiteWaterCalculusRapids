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
        
        super.init()
        
        level.loadEmptyNode(yOffset: 3 * Level.NODE_HEIGHT)
        level.loadEmptyNode(yOffset: 2 * Level.NODE_HEIGHT)
        level.loadEmptyNode(yOffset: 1 * Level.NODE_HEIGHT)
        level.loadCeilingNode(yOffset: 0)
    }
    
    override func update(deltaTime: Float) {
        
        // attempt to load and delete as many nodes as possible
        while attemptLoad() {}
        while attemptDelete() {}
    }
    
    private func attemptLoad() -> Bool {
        
        // spawn a node if the player is far enough
        if let y = gameObject?.transform.position.y {
            
            let spawnedTo = level.nodes.peekBack()?.yOffset ?? 0
            
            if y < spawnedTo + spawnAhead * Level.NODE_HEIGHT {
                
                level.loadRandomNode(yOffset: spawnedTo - Level.NODE_HEIGHT)
                return true
            }
        }
        
        return false
    }
    
    private func attemptDelete() -> Bool {
        
        // delete nodes that are higher than the deleter
        if let frontPos = level.nodes.peekFront()?.yOffset {
            
            if frontPos > deleteObj.transform.position.y {
                
                level.nodes.dequeue()?.destroy()
                return true
            }
        }
        
        return false
    }
}
