//
//  ViewController.swift
//  Comp8051
//
//  Created by Paul on 2019-02-13.
//  Copyright © 2019 Paul. All rights reserved.
//

import GLKit

extension Array {
    func size() -> Int {
        return MemoryLayout<Element>.stride * self.count
    }
}

class ViewController: GLKViewController {
    
    private var rotation: Float = 0.0
    
    private var context: EAGLContext?
    
    private var ebo = GLuint()
    private var vbo = GLuint()
    
    private var vaoList: [GLuint] = []

    private var effect = GLKBaseEffect()
    
    let sphere = Model(modelName: "ICOSphere")
    let surface = Model(modelName: "UnitSurface")
    var models : [Model] = []
    
    private var modelViewMatrix : GLKMatrix4?
    
    private func setupGL() {
        // 1
        context = EAGLContext(api: .openGLES3)
        // 2
        EAGLContext.setCurrent(context)
        
        if let view = self.view as? GLKView, let context = context {
            // 3
            view.context = context
            // 4
            delegate = self
        }
        
        // 1
        let vertexAttribColor = GLuint(GLKVertexAttrib.color.rawValue)
        // 2
        let vertexAttribPosition = GLuint(GLKVertexAttrib.position.rawValue)
        // 3
        let vertexSize = MemoryLayout<Vertex>.stride
        // 4
        let colorOffset = MemoryLayout<GLfloat>.stride * 3
        // 5
        let colorOffsetPointer = UnsafeRawPointer(bitPattern: colorOffset)
        
        models = [sphere, surface]
        
        for model in models {
            var vao = GLuint()

            // 1
            glGenVertexArraysOES(1, &vao)
            // 2
            glBindVertexArrayOES(vao)
            
            glGenBuffers(1, &vbo)
            glBindBuffer(GLenum(GL_ARRAY_BUFFER), vbo)
            
            //for model in models {
                glBufferData(GLenum(GL_ARRAY_BUFFER), // 1
                    model.vertices.size(),         // 2
                    model.vertices,                // 3
                    GLenum(GL_STATIC_DRAW))  // 4
            //}

            glEnableVertexAttribArray(vertexAttribPosition)
            glVertexAttribPointer(vertexAttribPosition,       // 1
                3,                          // 2
                GLenum(GL_FLOAT),           // 3
                GLboolean(UInt8(GL_FALSE)), // 4
                GLsizei(vertexSize),        // 5
                nil)                        // 6
            
            glEnableVertexAttribArray(vertexAttribColor)
            glVertexAttribPointer(vertexAttribColor,
                                  4,
                                  GLenum(GL_FLOAT),
                                  GLboolean(UInt8(GL_FALSE)),
                                  GLsizei(vertexSize),
                                  colorOffsetPointer)
            
            glGenBuffers(1, &ebo)
            glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), ebo)
            
            //for model in models {
                glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER),
                             model.indices.size(),
                             model.indices,
                             GLenum(GL_STATIC_DRAW))
           // }
            
            glBindVertexArrayOES(0)
            glBindBuffer(GLenum(GL_ARRAY_BUFFER), 0)
            glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), 0)
            vaoList.append(vao)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGL()
    }
    
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        // 1
        glClearColor(0.85, 0.85, 0.85, 1.0)
        // 2
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
        
        modelViewMatrix = GLKMatrix4MakeTranslation(0.0, 0.0, -6.0)
        for i in 0 ..< models.count {
            if(i == 0){
                modelViewMatrix = GLKMatrix4Translate(modelViewMatrix!, 0.0, 2.0, 0.0)
            } else if(i == 1){
                modelViewMatrix = GLKMatrix4Translate(modelViewMatrix!, 0.0, -3.0, 0.0)
            }
            effect.transform.modelviewMatrix = modelViewMatrix!
            
            effect.prepareToDraw()
            glBindVertexArrayOES(vaoList[i]);
            //glUniformMatrix4fv(_uniformModelViewProjectionMatrix, 1, 0, _modelViewProjectionMatrix.m);
            glDrawElements(GLenum(GL_TRIANGLES),     // 1
                GLsizei(models[i].indices.count),   // 2
                GLenum(GL_UNSIGNED_BYTE), // 3
                nil)                      // 4

            glBindVertexArrayOES(0)
        }
    }
    
    private func tearDownGL() {
        EAGLContext.setCurrent(context)
        
        for var vao in vaoList {
            glDeleteBuffers(1, &vao)
        }
        glDeleteBuffers(1, &vbo)
        glDeleteBuffers(1, &ebo)
        
        EAGLContext.setCurrent(nil)
        
        context = nil
    }
    
    deinit {
        tearDownGL()
    }
}

extension ViewController: GLKViewControllerDelegate {
    func glkViewControllerUpdate(_ controller: GLKViewController) {
        // 1
        let aspect = fabsf(Float(view.bounds.size.width) / Float(view.bounds.size.height))
        // 2
        let projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0), aspect, 4.0, 10.0)
        // 3
        effect.transform.projectionMatrix = projectionMatrix
        // 1
        //modelViewMatrix = GLKMatrix4MakeTranslation(0.0, 0.0, -6.0)
        // 2
        rotation += 90 * Float(timeSinceLastUpdate)
        modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix!, GLKMathDegreesToRadians(rotation), 0, 0, 1)
        // 3
        
        //effect.transform.modelviewMatrix = modelViewMatrix!
        
        // update entity component system
        // GameObject.root.update(deltaTime: 1/30)
        // TODO: if this is going to always be the same amount, maybe just make it a constant somewhere
    }
}
