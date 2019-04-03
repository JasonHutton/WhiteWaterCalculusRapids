//
//  CollisionSound.swift
//  Comp8051
//
//  Created by Jason Hutton on 2019-04-03.
//  Copyright © 2019 Paul. All rights reserved.
//

import Foundation

class CollisionSound : Component {
    var sound : SoundEffect
    
    init(sound: SoundEffect) {
        self.sound = sound
    }
    
    public func Collide() {
        self.sound.playSound()
    }
}
