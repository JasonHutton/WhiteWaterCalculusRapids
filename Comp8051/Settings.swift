//
//  Settings.swift
//  Comp8051
//
//  Created by Jason Hutton on 2019-04-05.
//  Copyright © 2019 Paul. All rights reserved.
//

import Foundation

class Setting : NSObject {
    private(set) var name : String
    private var value : String?
    private(set) var defaultValue : String
    
    init(name: String, defaultValue: String) {
        self.name = name
        self.defaultValue = defaultValue
    }
    
    public func setValue(value: String) {
        self.value = value
    }
    
    public func getValue() -> String {
        return self.value ?? self.defaultValue
    }
}

class Settings : NSObject {

    private var allSettings = [Setting]()
    
    public static let instance = Settings()
    
    static func start () {
        instance.respond()
    }
    
    // hey, this is goofy, but it does work
    private func respond () {
        print("Settings initialized.")
    }
    
    override init() {
        allSettings += [Setting(name: "playMusic", defaultValue: "1")]
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
    
    func load() {
        for setting in allSettings {
            setting.setValue(value: UserDefaults.standard.string(forKey: setting.name) ?? setting.getValue())
        }
    }
    
    func save(key: String, value: String) {
        for setting in allSettings {
            UserDefaults.standard.set(setting.getValue(), forKey: setting.name)
        }
    }
}

