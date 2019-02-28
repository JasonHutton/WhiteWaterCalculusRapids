//
//  Model.swift
//  Comp8051
//
//  Created by Paul on 2019-02-15.
//  Copyright © 2019 Paul. All rights reserved.
//

// Format specification: http://paulbourke.net/dataformats/obj/

import GLKit
import Foundation

class Model {
    public var vertices: [Vertex] = [] // Vertices data
    public var faces: [Face] = [] // Faces
    public var vertexIndices: [GLubyte] = []
    public var vertexTextureIndices: [GLubyte] = []
    public var vertexNormalIndices: [GLubyte] = []
    public var materials: [String] = [] // Material names
    private var currentMaterial: String // Current material name
    private var currentGroup: String // Current group name
    private var currentObject: String // Current object name
    public var name : String
    public var modelViewMatrix : GLKMatrix4
    
            var vao = GLuint()
    private var ebo = GLuint()
    private var vbo = GLuint()
    var shader: BaseEffect!
    
    public init(modelName: String, shader: BaseEffect){
        name = modelName
        self.shader = shader
        currentMaterial = "" // Set to default material
        currentGroup = "" // Set to default group
        currentObject = "" // Set to default object
        
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
                // Object name
                break // does nothing for now
            case "g":
                // Polygon group name
                break // does nothing for now
            case "mtllib":
                // External material file name
                materials.append(separator[1])
                break
            case "usemtl":
                // Specify material name to be used for following elements
                currentMaterial = separator[1]
                break
            case "v":
                vertices.append(Vertex(x: Float(separator[1])!, y: Float(separator[2])!, z: Float(separator[3])!, r: 1, g: 1, b: 1, a: 1))
            case "vt":
                // Vertex Texture Coordinates (u, [v ,w])
                break // does nothing for now
            case "vn":
                // Vertex Normals (x, y, z) May not be unit vectors.
                break // does nothing for now
            case "s":
                // Smooth shading across polygons
                break // does nothing for now
            case "f":              
                for vert in 1...3 {
                    let vertexIndex = separator[vert].components(separatedBy: "/")[0]
                    let vertexTextureIndex = separator[vert].components(separatedBy: "/")[1]
                    let vertexNormalIndex = separator[vert].components(separatedBy: "/")[2]
                    
                    if !vertexIndex.isEmpty {
                        vertexIndices.append(GLubyte(vertexIndex)!-1)
                    }
                    if !vertexTextureIndex.isEmpty {
                        vertexTextureIndices.append(GLubyte(vertexTextureIndex)!-1)
                    }
                    if !vertexNormalIndex.isEmpty {
                        vertexNormalIndices.append(GLubyte(vertexNormalIndex)!-1)
                    }
                }
                break
            case "#":
                break // this is a comment, do nothing
            case "":
                break // this is an empty line, do nothing
            default:
                // this is something that shouldn't be in an obj file, print it
                print("Invalid separator '" + separator[0] + "' in model " + name + ", line " + (offset+1).description)
            }
        }
        
        glGenVertexArraysOES(1, &vao) // GPU에 VertexArrayObject를 생성해서 미리 정점과 인덱스를 CPU에서 GPU로 모두 복사한다
        glBindVertexArrayOES(vao)
        
        
        glGenBuffers(GLsizei(1), &vbo)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vbo)
        let count = vertices.count
        let size =  MemoryLayout<Vertex>.size
        glBufferData(GLenum(GL_ARRAY_BUFFER), count * size, vertices, GLenum(GL_STATIC_DRAW))
        
        glGenBuffers(GLsizei(1), &ebo)
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), ebo)
        glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER), vertexIndices.count * MemoryLayout<GLubyte>.size, vertexIndices, GLenum(GL_STATIC_DRAW))
        
        
        // 현재 vao가 바인딩 되어 있어서 아래 함수를 실행하면 정점과 인덱스 데이터가 모두 vao에 저장된다.
        glEnableVertexAttribArray(VertexAttributes.position.rawValue)
        glVertexAttribPointer(
            VertexAttributes.position.rawValue,
            3,
            GLenum(GL_FLOAT),
            GLboolean(GL_FALSE),
            GLsizei(MemoryLayout<Vertex>.size), BUFFER_OFFSET(0))
        
        
        glEnableVertexAttribArray(VertexAttributes.color.rawValue)
        glVertexAttribPointer(
            VertexAttributes.color.rawValue,
            4,
            GLenum(GL_FLOAT),
            GLboolean(GL_FALSE),
            GLsizei(MemoryLayout<Vertex>.size), BUFFER_OFFSET(3 * MemoryLayout<GLfloat>.size)) // x, y, z | r, g, b, a :: offset is 3*sizeof(GLfloat)
        
        // 바인딩을 끈다
        glBindVertexArrayOES(0)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), 0)
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), 0)
    }
    func BUFFER_OFFSET(_ n: Int) -> UnsafeRawPointer? {
        return UnsafeRawPointer(bitPattern: n)
    }
    
    func render(){
        shader.modelViewMatrix = modelViewMatrix
        shader.prepareToDraw()
        
        glBindVertexArrayOES(vao);
        
        glDrawElements(GLenum(GL_TRIANGLES),     // 1
            GLsizei(vertexIndices.count),   // 2
            GLenum(GL_UNSIGNED_BYTE), // 3
            nil)                      // 4
        
        glBindVertexArrayOES(0)
    }
}

class Face {
    public var group: String
    public var object: String
    public var material: String
    //public var vertexIndices: [GLubyte] = []
    //public var vertexTextureIndices: [GLubyte] = []
    //public var vertexNormalIndices: [GLubyte] = []
    
    init(objectName: String, groupName: String, materialName: String) {
        object = objectName
        group = groupName
        material = materialName
    }
}

class VertexIndexData {
    public var index: GLubyte
    public var textureIndex: GLubyte
    public var normalIndex: GLubyte
    
    init(vertexIndex: GLubyte, vertexTextureIndex: GLubyte, vertexNormalIndex: GLubyte) {
        index = vertexIndex
        textureIndex = vertexTextureIndex
        normalIndex = vertexNormalIndex
    }
}
