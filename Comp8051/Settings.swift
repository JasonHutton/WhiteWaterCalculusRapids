//
//  Settings.swift
//  Comp8051
//
//  Created by Jason Hutton on 2019-04-05.
//  Copyright © 2019 Paul. All rights reserved.
//

import Foundation

class Setting : NSObject {
    private(set) var name : String // Name of the setting
    private var value : String? // Current value
    private(set) var defaultValue : String // Default value of the setting
    private var lastValue : String? // Last value the setting had. (Used to know when to save.)
    
    init(name: String, defaultValue: String) {
        self.name = name
        self.defaultValue = defaultValue
        self.lastValue = self.value
    }
    
    public func setValue(value: String) {
        self.value = value
        
        if(self.getValue() != self.lastValue) {
            UserDefaults.standard.set(self.getValue(), forKey: self.name)
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
    
    // Setting names must all be listed in here. This is intended to avoid typos mostly.
    public enum Names : String {
        case playMusic = "playMusic"
        case playSound = "playSound"
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
    
    func setSetting(name: String, value: String) {
        for setting in allSettings {
            if(setting.name == name) {
                setting.setValue(value: value)
            }
        }
    }
    
    func setSetting(name: String, value: Bool) {
        if(value == true) {
            self.setSetting(name: name, value: "1")
        } else {
            self.setSetting(name: name, value: "0")
        }
    }
}

