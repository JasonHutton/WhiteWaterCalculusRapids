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
    var url: URL
    
    init(soundFile: String) {
        self.soundFile = soundFile
        let path = Bundle.main.path(forResource: self.soundFile, ofType: "mp3")!
        self.url = URL(fileURLWithPath: path)
    }
    
    public func playSound() {
        do {
            player = try AVAudioPlayer(contentsOf: self.url)
            player.prepareToPlay()
            
            if(Settings.instance.getSetting(name: Settings.Names.playSound.rawValue)) {
                player.play()
            }
        } catch let error as NSError{
            print(error.description)
        }
    }
}
