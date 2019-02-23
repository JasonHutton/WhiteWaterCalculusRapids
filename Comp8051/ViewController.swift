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
    
    private var rotation: Float = 0.0;
    private var curLocationX: Float = 0.0;
    private var curLocationY: Float = 0.0;
    private var dirX: Float = 0.0;
    private var dirY: Float = 0.0;
    
    private var context: EAGLContext?
    
   /* var Vertices = [
        Vertex(x:  1, y: -1, z: 0, r: 1, g: 0, b: 0, a: 1),
        Vertex(x:  1, y:  1, z: 0, r: 0, g: 1, b: 0, a: 1),
        Vertex(x: -1, y:  1, z: 0, r: 0, g: 0, b: 1, a: 1),
        Vertex(x: -1, y: -1, z: 0, r: 0, g: 0, b: 0, a: 1),
        ]*/
    
    private var ebo = GLuint()
    private var vbo = GLuint()
    private var vao = GLuint()
    
    /*var Indices: [GLubyte] = [
        0, 1, 2,
        2, 3, 0
    ]*/

    private var effect = GLKBaseEffect()
    
    let sphere = Model(modelPath: "ICOSphere")
    
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
        
        // 1
        glGenVertexArraysOES(1, &vao)
        // 2
        glBindVertexArrayOES(vao)
        
        glGenBuffers(1, &vbo)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vbo)
        glBufferData(GLenum(GL_ARRAY_BUFFER), // 1
            sphere.vertices.size(),         // 2
            sphere.vertices,                // 3
            GLenum(GL_STATIC_DRAW))  // 4
        
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
        glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER),
                     sphere.indices.size(),
                     sphere.indices,
                     GLenum(GL_STATIC_DRAW))
        
        glBindVertexArrayOES(0)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), 0)
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), 0)
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
        
        effect.prepareToDraw()
        
        glBindVertexArrayOES(vao);
        glDrawElements(GLenum(GL_TRIANGLES),     // 1
            GLsizei(sphere.indices.count),   // 2
            GLenum(GL_UNSIGNED_BYTE), // 3
            nil)                      // 4
        glBindVertexArrayOES(0)
    }
    
    private func tearDownGL() {
        EAGLContext.setCurrent(context)
        
        glDeleteBuffers(1, &vao)
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
        let projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65), aspect, 2.0, 30.0)
        // 3
        effect.transform.projectionMatrix = projectionMatrix
        // 1
        if(true){// GOING IN A DIRECTION
            // set direction
            print(Float(view.bounds.size.height/2));
            print(curLocationY*10);

            curLocationX = curLocationX+0.05;
            curLocationY = curLocationY+0.07;
        }
        // OUT OF BOUNDS WRAPAROUND
        if(curLocationX*10 >= 118){
            curLocationX = -117/10;
            print("OUT OF BOUNDS WRAPAROUND +X");
        }
        if(curLocationX*10 <= -118){
            curLocationX = 117/10;
            print("OUT OF BOUNDS WRAPAROUND -X");
        }
        if(curLocationY*10 >= 201){
            curLocationY = -200/10;
            print("OUT OF BOUNDS WRAPAROUND +Y");
        }
        if(curLocationY*10 <= -201){
            curLocationY = 200/10;
            print("OUT OF BOUNDS WRAPAROUND -Y");
        }
        
        var modelViewMatrix = GLKMatrix4MakeTranslation(curLocationX, curLocationY, -30)
        // 2
        rotation += 90 * Float(timeSinceLastUpdate)
        modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, GLKMathDegreesToRadians(rotation), 1, 1, 0)
        // 3
        effect.transform.modelviewMatrix = modelViewMatrix
    }
}

