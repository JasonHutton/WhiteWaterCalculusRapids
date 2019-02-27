//
//  Material.swift
//  Comp8051
//
//  Created by Jason Hutton on 2019-02-27.
//  Copyright © 2019 Paul. All rights reserved.
//

// Format specification: http://paulbourke.net/dataformats/mtl/

import GLKit
import Foundation

class Material {
    public var vertices: [Vertex] = []
    public var indices: [GLubyte] = []
    public var name : String
    
    public init(materialName: String){
        name = materialName
      
        // get the full path for the model file
        let path = Bundle.main.path(forResource: materialName, ofType: "mtl")
        
        // get the file using the path
        let file: FileHandle? = FileHandle(forReadingAtPath: path!)
        
        // read the data from the file
        let data = file?.readDataToEndOfFile()
        
        file?.closeFile()
        
        // get the contents of the file in one big string
        let string = String(data: data!, encoding: String.Encoding.utf8)
        // split the file data into an array of strings separated by new line character
        let lines: [String] = (string?.components(separatedBy: "\n"))!
        
        //go through each line
        for (offset, line) in lines.enumerated() {
            // split the line into words
            let separator = line.components(separatedBy: " ")
            
            // switch statement for the first charcter in the line
            switch separator[0] {
                
            case "newmtl":
                // Name the material
                break // does nothing for now
            case "Ka":
                // Ambient Color 0.0-1.0
                break // does nothing for now
            case "Kd":
                // Diffuse Color 0.0-1.0
                break // does nothing for now
            case "Ks":
                // Specular Color 0.0-1.0
                break // does nothing for now
            case "Ns":
                // Specular Highlight 0-1000
                break // does nothing for now
            case "Tr":
                // Transparency 0.0-1.0 (0=opaque, 1=clear)
                break // does nothing for now
            case "d":
                // "Dissolve" Just inverted transparency in some formats. 0=clear, 1=opaque
                break // does nothing for now
            case "map_Ka":
                // Ambient texture map
                break // does nothing for now
            case "map_Kd":
                // Diffuse texture map
                break // does nothing for now
            case "map_Ks":
                // Specular texture map
                break // does nothing for now
            case "map_Ns":
                // Specular Highlight texture map
                break // does nothing for now
            case "map_d":
                // Alpha texture map
                break // does nothing  for now
            case "map_bump":
                // Bump map
                break // does nothing for now
            case "illum":
                // Illumination model
                break
            case "#":
                break // this is a comment, do nothing
            case "":
                break // this is an empty line, do nothing
            default:
                // this is something that shouldn't be in an obj file, print it
                print("Invalid separator '" + separator[0] + "' in material " + name + ", line " + (offset+1).description)
            }
        }
    }
}

