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

class Model : Equatable {
    
    public static var iterator: Int = 0
    public var id: Int
    public var vertices: [Vertex] = [] // Vertices data
    public var vertexPositions:[GLKVector3] = []
    public var normals:[GLKVector3] = []
    public var textureCoords:[GLKVector2] = []
    public var faces: [Face] = [] // Faces
    public var vertexIndices: [GLuint] = []
    public var vertexTextureIndices: [GLuint] = []
    public var vertexNormalIndices: [GLuint] = []
    public var materials: [String] = [] // Material names
    private var currentGroup: String // Current group name
    private var currentObject: String // Current object name
    public var name : String
    public var modelViewMatrix : GLKMatrix4
    
    private var vao = GLuint()
    private var ebo = GLuint()
    private var vbo = GLuint()
    var texture: GLuint = 0
    
    var shader: BaseEffect!
    
    public init(modelName: String, shader: BaseEffect, texture: String? = nil){
        
        id = Model.iterator
        Model.iterator += 1
        
        name = modelName
        self.shader = shader
        currentGroup = "" // Set to default group
        currentObject = "" // Set to default object
        
        // set mvm to 0 matrix
        modelViewMatrix = GLKMatrix4Identity
        
        let lines: [String] = TextLoader.loadFile(fileName: modelName, fileType: "obj")!

        var i = GLuint(0);
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
                if(texture == nil){
                    loadTexture(separator[1])
                } else{
                    loadTexture(texture!)
                }
                break
            case "v":
                // vertex coordinates
                vertexPositions.append(GLKVector3Make(Float(separator[1])!, Float(separator[2])!, Float(separator[3])!))
            case "vt":
                // Vertex Texture Coordinates (u, [v ,w])
                textureCoords.append(GLKVector2Make(Float(separator[1])!, Float(separator[2])!))
                break
            case "vn":
                // Vertex Normals (x, y, z) May not be unit vectors.
                normals.append(GLKVector3Make(Float(separator[1])!, Float(separator[2])!, Float(separator[3])!))
                break
            case "s":
                // Smooth shading across polygons
                break // does nothing for now
            case "f":
                for vert in 1...3 {
                    vertexIndices.append(i);
                    
                    let vertexIndex = Int(separator[vert].components(separatedBy: "/")[0])
                    let vertexTextureIndex = Int(separator[vert].components(separatedBy: "/")[1])
                    let vertexNormalIndex = Int(separator[vert].components(separatedBy: "/")[2])
                    
                    var vertex = Vertex()
                    vertex.x = vertexPositions[vertexIndex!-1].x
                    vertex.y = vertexPositions[vertexIndex!-1].y
                    vertex.z = vertexPositions[vertexIndex!-1].z
                    vertex.u = textureCoords[vertexTextureIndex!-1].x
                    vertex.v = textureCoords[vertexTextureIndex!-1].y
                    vertex.nx = normals[vertexNormalIndex!-1].x
                    vertex.ny = normals[vertexNormalIndex!-1].y
                    vertex.nz = normals[vertexNormalIndex!-1].z
                    
                    vertices.append(vertex)
                    i += 1
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
        glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER), vertexIndices.count * MemoryLayout<GLuint>.size, vertexIndices, GLenum(GL_STATIC_DRAW))
        
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
        
        
        glEnableVertexAttribArray(VertexAttributes.texCoord.rawValue)
        glVertexAttribPointer(
            VertexAttributes.texCoord.rawValue,
            2,
            GLenum(GL_FLOAT),
            GLboolean(GL_FALSE),
            GLsizei(MemoryLayout<Vertex>.size), BUFFER_OFFSET((3+4) * MemoryLayout<GLfloat>.size)) // x, y, z | r, g, b, a | u, v :: offset is (3+4)*sizeof(GLfloat)
        
        glEnableVertexAttribArray(VertexAttributes.normal.rawValue)
        glVertexAttribPointer(
            VertexAttributes.normal.rawValue,
            3,
            GLenum(GL_FLOAT),
            GLboolean(GL_FALSE),
            GLsizei(MemoryLayout<Vertex>.size), BUFFER_OFFSET((3+4+2) * MemoryLayout<GLfloat>.size)) // x, y, z | r, g, b, a | u, v | nx, ny, nz :: offset is (3+4+2)*sizeof(GLfloat)
        
        glBindVertexArrayOES(0)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), 0)
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), 0)
    }
    func BUFFER_OFFSET(_ n: Int) -> UnsafeRawPointer? {
        return UnsafeRawPointer(bitPattern: n)
    }
    
    func render(){
        shader.modelViewMatrix = modelViewMatrix
        shader.texture = self.texture
        shader.prepareToDraw()
        
        glBindVertexArrayOES(vao);
        
        glDrawElements(GLenum(GL_TRIANGLES),     // 1
            GLsizei(vertexIndices.count),   // 2
            GLenum(GL_UNSIGNED_INT), // 3
            nil)                      // 4
        
        glBindVertexArrayOES(0)
    }
    
    func loadTexture(_ filename: String) {
        
        let path = Bundle.main.path(forResource: filename, ofType: nil)!
        let option = [ GLKTextureLoaderOriginBottomLeft: true]
        do {
            let info = try GLKTextureLoader.texture(withContentsOfFile: path, options: option as [String : NSNumber]?)
            self.texture = info.name
        } catch {
            
        }
    }
    
    static func == (lhs: Model, rhs: Model) -> Bool {
        return lhs.id == rhs.id
    }
    
    deinit{
        glDeleteBuffers(1, &vao)
        glDeleteBuffers(1, &vbo)
        glDeleteBuffers(1, &ebo)
    }
}

class Face {
    public var group: String
    public var object: String
    public var material: String
    
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
