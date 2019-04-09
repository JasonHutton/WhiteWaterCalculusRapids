//
//  ContextCollisionSounds.swift
//  Comp8051
//
//  Created by Jason Hutton on 2019-04-09.
//  Copyright © 2019 Paul. All rights reserved.
//

import Foundation

class ContextCollisionSounds : CollisionSound {
    var sounds : [String: SoundEffect?] = [:]
    
    init(sound: SoundEffect, sounds: [String: SoundEffect?]) {
        self.sounds = sounds
        
        super.init(sound: sound)
    }
    
    public override func Collide(tag: String) {
        
        var sound : SoundEffect?
        
        var foundOne : Bool = false
        for s in sounds {
            if(tag.contains(s.key)) {
                foundOne = true
                sound = s.value
                break
            }
        }
        
        if(foundOne != true) { // We're not just checking for sound == nil here as we're using that as a valid value
            sound = self.sound
        }
        
        sound?.playSound()
    }
}
