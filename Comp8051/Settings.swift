//
//  Settings.swift
//  Comp8051
//
//  Created by Jason Hutton on 2019-04-05.
//  Copyright © 2019 Paul. All rights reserved.
//

import Foundation

/*struct PropertyKey {
    static let setting = "setting"
    static let value = "value"
    static let defaultValue = "defaultValue"
}*/

enum Keys: String {
    case setting = "setting"
    case value = "value"
    case defaultValue = "defaultValue"
}

class Setting : NSObject, NSCoding {

    var setting : NSString = ""
    var value : NSString = ""
    var defaultValue : NSString = ""


    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(setting, forKey: Keys.setting.rawValue)
        aCoder.encode(value, forKey: Keys.value.rawValue)
        aCoder.encode(defaultValue, forKey: Keys.defaultValue.rawValue)
    }
    
    init(setting: String, value: String, defaultValue: String) {
        super.init()
        
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        guard let setting = aDecoder.decodeObject(forKey: Keys.setting.rawValue) as? String else {
            print("Unable to decode the name of a setting.")
            return nil
        }
        
        let value = aDecoder.decodeObject(forKey: Keys.value.rawValue) as! String
        let defaultValue = aDecoder.decodeObject(forKey: Keys.defaultValue.rawValue) as! String
        
        /*if let content = messageObject.value(forKey:"content") as? String {
            stringContent = content
        }*/
        self.init(setting: "", value: "0", defaultValue: "0")
    }
}
