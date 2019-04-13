//
//  Settings.swift
//  Comp8051
//
//  Created by Jason Hutton on 2019-04-05.
//  Copyright © 2019 Paul. All rights reserved.
//

import Foundation
import AVFoundation

class Setting : NSObject {
    private(set) var name : String // Name of the setting
    private var value : String? // Current value
    private(set) var defaultValue : String // Default value of the setting
    private var lastValue : String? // Last value the setting had. (Used to know when to save.)
    private(set) var deferSave : Bool // Don't save unless explicitly asked to.
    
    init(name: String, defaultValue: String, deferSave: Bool = false) {
        self.name = name
        self.value = nil
        self.defaultValue = defaultValue
        self.lastValue = self.value
        self.deferSave = deferSave
    }
    
    public func setValue(value: String, explicitSave: Bool = false) {
        self.value = value
        
        if(self.getValue() != self.lastValue) {
            if(self.deferSave == false || explicitSave == true) {
                UserDefaults.standard.set(self.getValue(), forKey: self.name)
            }
        }
        
        self.lastValue = self.value
    }
    
    public func getValue() -> String {
        if(self.value == nil) {
            self.setValue(value: UserDefaults.standard.string(forKey: self.name) ?? self.defaultValue)
        }
        
        assert(self.value != nil)
        
        return self.value!
    }
}

class Settings : NSObject {

    private var allSettings = [Setting]()
    public var player: AVAudioPlayer!
    
    // Setting names must all be listed in here. This is intended to avoid typos mostly.
    public enum Names : String {
        case playMusic = "playMusic"
        case playSound = "playSound"
        case highScore1 = "highScore1"
        case highScore2 = "highScore2"
        case highScore3 = "highScore3"
    }
    
    public static let instance = Settings()
    
    static func start () {
        instance.respond()
    }
    
    // hey, this is goofy, but it does work
    private func respond () {
        print("Settings initialized.")
    }
    
    override init() {
        // Create new settings here.
        allSettings += [Setting(name: Settings.Names.playMusic.rawValue, defaultValue: "1")]
        allSettings += [Setting(name: Settings.Names.playSound.rawValue, defaultValue: "1")]
        allSettings += [Setting(name: Settings.Names.highScore1.rawValue, defaultValue: "0", deferSave: true)]
        allSettings += [Setting(name: Settings.Names.highScore2.rawValue, defaultValue: "0", deferSave: true)]
        allSettings += [Setting(name: Settings.Names.highScore3.rawValue, defaultValue: "0", deferSave: true)]
    }
    
    func getSetting(name: String) -> String {
        for setting in allSettings {
            if(setting.name == name) {
                return setting.getValue()
            }
        }
    
        assert(false)
    }
    
    func getSetting(name: String) -> Bool {
        let value = self.getSetting(name: name) as String
        
        if(value == "0") {
            return false
        } else {
            return true
        }
    }
    
    func getSetting(name: String) -> Int {
        return Int(self.getSetting(name: name) as String) ?? 0
    }
    
    func setSetting(name: String, value: String, explicitSave: Bool = false) {
        for setting in allSettings {
            if(setting.name == name) {
                setting.setValue(value: value, explicitSave: explicitSave)
            }
        }
    }
    
    func setSetting(name: String, value: Bool, explicitSave: Bool = false) {
        if(value == true) {
            self.setSetting(name: name, value: "1", explicitSave: explicitSave)
        } else {
            self.setSetting(name: name, value: "0", explicitSave: explicitSave)
        }
    }
    
    func setSetting(name: String, value: Int, explicitSave: Bool = false) {
        self.setSetting(name: name, value: String(value), explicitSave: explicitSave)
    }
    
    func playMusic(soundFile: String, numberOfLoops: Int) {
        let path = Bundle.main.path(forResource: soundFile, ofType: "mp3")!
        let url = URL(fileURLWithPath: path)
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            player.numberOfLoops = numberOfLoops
            
            if(Settings.instance.getSetting(name: Settings.Names.playMusic.rawValue)){
                player.play()
            }
        } catch let error as NSError{
            print(error.description)
        }
    }
}

