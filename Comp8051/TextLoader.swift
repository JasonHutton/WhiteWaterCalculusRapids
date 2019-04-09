//
//  TextLoader.swift
//  Comp8051
//
//  Created by Jason Hutton on 2019-04-07.
//  Copyright © 2019 Paul. All rights reserved.
//

import Foundation

class TextLoader {

    public static func loadFile(fileName: String, fileType: String) -> [String]? {
        let string = loadFile(fileName: fileName, fileType: fileType) as String?
        
        // split the file data into an array of strings separated by new line character
        return string?.components(separatedBy: "\n")
    }
   
    public static func loadFile(fileName: String, fileType: String) -> String? {
    
        // get the full path for the model file
        let path = Bundle.main.path(forResource: fileName, ofType: fileType)
        
        // get the file using the path
        let file: FileHandle? = FileHandle(forReadingAtPath: path!)
        
        // read the data from the file
        let data = file?.readDataToEndOfFile()
        
        file?.closeFile()
        
        // get the contents of the file in one big string
        return String(data: data!, encoding: String.Encoding.utf8)
    }
    
    public static func loadFiles(fileType: String) -> [String] {
        
        var files = [String]()
        
        let paths = Bundle.main.paths(forResourcesOfType: ".json", inDirectory: "")
        
        for path in paths {
            
            if let file = FileHandle(forReadingAtPath: path) {
                
                let data = file.readDataToEndOfFile()
                file.closeFile()
                if let string = String(data: data, encoding: String.Encoding.utf8) {
                    
                    files.append(string)
                }
            }
        }
        
        return files
    }
}
