//
//  CameraTrack.swift
//  Comp8051
//
//  Created by Nathaniel on 2019-04-03.
//  Copyright © 2019 Paul. All rights reserved.
//

class CameraTrack : Component {
    
    private var trackedObj: GameObject
    private let shader: BaseEffect
    
    init (trackedObj: GameObject, shader: BaseEffect) {
        
        self.trackedObj = trackedObj
        self.shader = shader
    }
    
    override func lateUpdate(deltaTime: Float) {
        
        if var pos = gameObject?.worldTransform.position {
            
            pos.y = Float.lerp(start: pos.y, end: trackedObj.worldTransform.position.y, t: deltaTime * 3)
            
            gameObject!.worldTransform.position = pos
        }
    }
}
