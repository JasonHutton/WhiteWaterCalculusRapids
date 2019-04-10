//
//  CameraTrack.swift
//  Comp8051
//
//  Created by Nathaniel on 2019-04-03.
//  Copyright © 2019 Paul. All rights reserved.
//

class CameraTrack : Component {
    
    private var trackedObj: GameObject
    
    init (trackedObj: GameObject) {
        
        self.trackedObj = trackedObj
    }
    
    override func lateUpdate(deltaTime: Float) {
        
        if var pos = gameObject?.worldTransform.position {
            
            pos.y = Float.lerp(start: pos.y, end: trackedObj.worldTransform.position.y, t: deltaTime * 3)
            
            gameObject!.worldTransform.position = pos
        }
    }
}
