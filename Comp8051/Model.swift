//
//  Model.swift
//  Comp8051
//
//  Created by Paul on 2019-02-15.
//  Copyright © 2019 Paul. All rights reserved.
//

import GLKit
import Foundation

struct Model {
    public var vertices: [Vertex] = []
    public var indices: [GLubyte] = []
    public var name : String
    public var modelViewMatrix : GLKMatrix4
    
    public init(modelName: String){
        name = modelName
        
        modelViewMatrix = GLKMatrix4Identity
        
        let path = Bundle.main.path(forResource: modelName, ofType: "obj")
        
        let file: FileHandle? = FileHandle(forReadingAtPath: path!)
        
        let data = file?.readDataToEndOfFile()
        
        file?.closeFile()
        
        let string = String(data: data!, encoding: String.Encoding.utf8)
        let lines: [String] = (string?.components(separatedBy: "\n"))!
        
        for line in lines {
            let separator = line.components(separatedBy: " ")
            
            switch separator[0] {
                case "v":
                    vertices.append(Vertex(x: Float(separator[1])!, y: Float(separator[2])!, z: Float(separator[3])!, r: 1, g: 1, b: 1, a: 1))
                //case "vt":
                //case "vn":
                case "f":
                    indices.append(GLubyte(separator[1].components(separatedBy: "//")[0])!-1)
                    indices.append(GLubyte(separator[2].components(separatedBy: "//")[0])!-1)
                    indices.append(GLubyte(separator[3].components(separatedBy: "//")[0])!-1)
                default:
                    print("wrong model format")
            }
        }
    }
}
