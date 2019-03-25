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
    
    static var deltaTime: Float = 1.0/30.0
    
    static var instance: ViewController?
    
    private var setupComplete = false
    
    private var context: EAGLContext?

    private var effect = GLKBaseEffect()
    
    var models : [Model] = []
    
    var shader : BaseEffect!
    
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
        
        // apply perspective transformation
        let aspect = fabsf(Float(view.bounds.size.width) / Float(view.bounds.size.height))
        let projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65), aspect, 1.0, 10.0)
        
        self.shader = BaseEffect(vertexShader: "SimpleVertexShader.glsl", fragmentShader: "SimpleFragmentShader.glsl")
        
        shader.projectionMatrix = projectionMatrix
        
        //effect.transform.projectionMatrix = projectionMatrix
        
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
        sphereObj.addComponent(component: ModelRenderer(modelName: "ICOSphere", shader: shader))
        GameObject.root.addChild(gameObject: sphereObj)
        
        let surfaceObj = GameObject(tag: "Surface")
        // set initial position
        surfaceObj.transform.position = Vector3(x: 0, y: -2, z: 0)
        surfaceObj.transform.scale.x = 10
        surfaceObj.addComponent(component: ModelRenderer(modelName: "UnitSurface", shader: shader))
        GameObject.root.addChild(gameObject: surfaceObj)
        
        // initialize physics
        _ = PhysicsWrapper()
    }
    
    
    func addModel ( model: inout Model)
    {
        models.append(model)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGL()
    }
    
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        // clear the scene
        glClearColor(0, 0, 0, 1.0)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT))

        glEnable(GLenum(GL_DEPTH_TEST))
        glEnable(GLenum(GL_CULL_FACE))
        
        // draw each model
        for i in 0 ..< models.count {
            models[i].render()
            // add transformations to the effect
            //effect.transform.modelviewMatrix = models[i].modelViewMatrix
            
            // draw the model on the scene
            //effect.prepareToDraw()

        }
    }
    
    private func tearDownGL() {
        EAGLContext.setCurrent(context)
        
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
        GameObject.root.update(deltaTime: ViewController.deltaTime)
        PhysicsWrapper.update(ViewController.deltaTime)
        GameObject.root.lateUpdate(deltaTime: ViewController.deltaTime)
    }
}
