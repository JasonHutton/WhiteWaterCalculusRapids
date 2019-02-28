//
//  ViewController.swift
//  Comp8051
//
//  Created by Paul on 2019-02-13.
//  Copyright © 2019 Paul. All rights reserved.
//

import GLKit
import CoreMotion

extension Array {
    func size() -> Int {
        return MemoryLayout<Element>.stride * self.count
    }
}

class ViewController: GLKViewController {
    
    static var instance: ViewController?
    
    private var setupComplete = false
    
    private var context: EAGLContext?
    
    private var ebo = GLuint()
    private var vbo = GLuint()
    
    private var vaoList: [GLuint] = []

    private var effect = GLKBaseEffect()
    
    var models : [Model] = []
    
    private func setupGL() {
        
        Input.start()
        
        ViewController.instance = self
        
        // 1
        context = EAGLContext(api: .openGLES2)
        // 2
        EAGLContext.setCurrent(context)
        
        if let view = self.view as? GLKView, let context = context {
            // 3
            view.context = context
            // 4
            delegate = self
        }
        
        // set up scene
        // add camera before adding any model renderers
        let cameraObj = GameObject(tag: "Camera")
        cameraObj.transform.position = Vector3(x: 0, y: 0, z: 6)
        GameObject.root.addChild(gameObject: cameraObj)
        // TODO: currently, component order DOES MATTER. modelrenderer should always occur last!
        // for now, add a game object's model renderer last.
        let sphereObj = GameObject(tag: "Sphere")
        // set initial position
        sphereObj.transform.position = Vector3(x: 0, y: 2, z: 0)
        // add component to rotate the sphere (probably temporary)
        sphereObj.addComponent(component: SphereBehaviour())
        sphereObj.addComponent(component: ModelRenderer(modelName: "ICOSphere"))
        GameObject.root.addChild(gameObject: sphereObj)
        
        let surfaceObj = GameObject(tag: "Surface")
        // set initial position
        surfaceObj.transform.position = Vector3(x: 0, y: -2, z: 0)
        surfaceObj.transform.scale.x = 10
        surfaceObj.addComponent(component: ModelRenderer(modelName: "UnitSurface"))
        GameObject.root.addChild(gameObject: surfaceObj)
    }
    
    
    func addModel ( model: inout Model)
    {
        models.append(model)
        setupModel(model: model)
    }
    
    private func setupModel (model: Model) {
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGL()
    }
    
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        // clear the scene
        glClearColor(0, 0, 0, 1.0)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))

        // draw each model
        for i in 0 ..< models.count {
            
            // add transformations to the effect
            effect.transform.modelviewMatrix = models[i].modelViewMatrix
            
            // apply perspective transformation
            let aspect = fabsf(Float(view.bounds.size.width) / Float(view.bounds.size.height))
            let projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65), aspect, 4.0, 10.0)
            effect.transform.projectionMatrix = projectionMatrix
            
            // draw the model on the scene
            effect.prepareToDraw()
            glBindVertexArrayOES(vaoList[i]);
            
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

        // update entity component system
        GameObject.root.update(deltaTime: 1/30)
        // TODO: if this is going to always be the same amount, maybe just make it a constant somewhere
    }
}
