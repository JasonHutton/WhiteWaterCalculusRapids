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
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        self.init()
        
        guard let setting = aDecoder.decodeObject(forKey: Keys.setting.rawValue) as? String else {
            print("Unable to decode the name of a setting.")
            return nil
        }
        
        let value = aDecoder.decodeInteger(forKey: Keys.value.rawValue)
        let defaultValue = aDecoder.decodeInteger(forKey: Keys.defaultValue.rawValue)
    }
}
