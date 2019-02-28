//
//  Model.swift
//  Comp8051
//
//  Created by Paul on 2019-02-15.
//  Copyright © 2019 Paul. All rights reserved.
//

import GLKit
import Foundation

class Model {
    public var vertices: [Vertex] = []
    public var indices: [GLubyte] = []
    public var name : String
    public var modelViewMatrix : GLKMatrix4
    
    public init(modelName: String){
        name = modelName
        
        // set mvm to 0 matrix
        modelViewMatrix = GLKMatrix4Identity
        
        // get the full path for the model file
        let path = Bundle.main.path(forResource: modelName, ofType: "obj")
        
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
                
            case "o":
                break // does nothing for now
            case "v":
                vertices.append(Vertex(x: Float(separator[1])!, y: Float(separator[2])!, z: Float(separator[3])!, r: 1, g: 1, b: 1, a: 1))
            case "vt":
                break // does nothing for now
            case "vn":
                break // does nothing for now
            case "s":
                break // does nothing for now
            case "f":
                // for the 3 indices, grab the first charcter, e.g. for f 1//2//3 4//5//6 7//8//9, indices would be 1, 4, and 7
                indices.append(GLubyte(separator[1].components(separatedBy: "//")[0])!-1)
                indices.append(GLubyte(separator[2].components(separatedBy: "//")[0])!-1)
                indices.append(GLubyte(separator[3].components(separatedBy: "//")[0])!-1)
            case "#":
                break // this is a comment, do nothing
            case "":
                break // this is an empty line, do nothing
            default:
                // this is something that shouldn't be in an obj file, print it
                print("Invalid separator '" + separator[0] + "' in model " + name + ", line " + (offset+1).description)
            }
        }
    }
}
