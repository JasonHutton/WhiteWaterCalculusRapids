//
//  SoundEffect.swift
//  Comp8051
//
//  Created by Jason Hutton on 2019-04-03.
//  Copyright © 2019 Paul. All rights reserved.
//

import AVFoundation

class SoundEffect : Component {
    
    var player: AVAudioPlayer!
    var soundFile: String
    var path: String
    var url: URL
    
    init(soundFile: String) {
        self.soundFile = soundFile
        self.path = Bundle.main.path(forResource: self.soundFile, ofType: "mp3")!
        self.url = URL(fileURLWithPath: self.path)
    }
    
    public func playSound() {
        do {
            player = try AVAudioPlayer(contentsOf: self.url)
            player.prepareToPlay()
            player.play()
        } catch let error as NSError{
            print(error.description)
        }
    }
}
