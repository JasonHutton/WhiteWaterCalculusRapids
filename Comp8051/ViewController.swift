//
//  ViewController.swift
//  Comp8051
//
//  Created by Paul on 2019-02-13.
//  Copyright © 2019 Paul. All rights reserved.
//

import GLKit
import CoreMotion
import AVFoundation

extension Array {
    func size() -> Int {
        return MemoryLayout<Element>.stride * self.count
    }
}

class ViewController: GLKViewController {
    
    @IBOutlet weak var menuView: GLKView!
    
    var player: AVAudioPlayer!
    
    var isMusicPlaying: Bool!
    
    static var deltaTime: Float = 1.0/30.0
    
    static var instance: ViewController?
    
    private var setupComplete = false
    
    private var context: EAGLContext?

    private var effect = GLKBaseEffect()
    
    var models : [Model] = []
    
    var shader : BaseEffect!

    @IBAction func startGame(_ sender: Any) {
        menuView.isHidden = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        view.addGestureRecognizer(tap)
        
        playMusic(soundFile: "gameplay3")
        
        setupGL()
    }
    
    @IBAction func toggleAudio(_ sender: Any) {
        if(isMusicPlaying){
            isMusicPlaying = false
            player.pause()
        } else if (!isMusicPlaying){
            isMusicPlaying = true;
            player.play()
        }
    }
    
    @IBAction func quitGame(_ sender: Any) {
        menuView.isHidden = false
        playMusic(soundFile: "menu")
        tearDownGL()
    }
    
    fileprivate func playMusic(soundFile: String) {
        let path = Bundle.main.path(forResource: soundFile, ofType: "mp3")!
        let url = URL(fileURLWithPath: path)
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            if(isMusicPlaying){
                player.play()
            }
        } catch let error as NSError{
            print(error.description)
        }
    }
    
    private func setupGL() {
        
        // initialize utilities
        Input.start()
        PhysicsWrapper.start();
        
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
            
            view.drawableDepthFormat = GLKViewDrawableDepthFormat.format24
        }
        
        // apply perspective transformation
        let aspect = fabsf(Float(view.bounds.size.width) / Float(view.bounds.size.height))
        let projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65), aspect, 1.0, 40.0)
        let width = 30 * tan(GLKMathDegreesToRadians(32.5))

        self.shader = BaseEffect(vertexShader: "SimpleVertexShader.glsl", fragmentShader: "SimpleFragmentShader.glsl")
        
        shader.projectionMatrix = projectionMatrix
        
        // set up scene
        GameObject.root.addComponent(component: GravityManager()) // this is silly but it works
        // add camera before adding any model renderers
        let cameraObj = GameObject(tag: "Camera")
        cameraObj.transform.position = Vector3(x: 0, y: 0, z: 30)
        GameObject.root.addChild(gameObject: cameraObj)
        // TODO: currently, component order DOES MATTER. modelrenderer should always occur last!
        // for now, add a game object's model renderer last.
        let sphereObj = GameObject(tag: "Sphere")
        // set initial position
        sphereObj.transform.position = Vector3(x: 0, y: 2, z: 0)
        // add component to rotate the sphere (probably temporary)
        sphereObj.addComponent(component: SphereBody(tag: "Ball"))
        sphereObj.addComponent(component: ModelRenderer(modelName: "ICOSphere", shader: shader))
        GameObject.root.addChild(gameObject: sphereObj)
        
        let surfaceObj = GameObject(tag: "Surface")
        // set initial position
        surfaceObj.transform.position = Vector3(x: 0, y: -2, z: 0)
        surfaceObj.transform.scale.x = 10
        surfaceObj.transform.scale.y = 0.5
        surfaceObj.addComponent(component: BlockBody(tag: "Floor"))
        surfaceObj.addComponent(component: ModelRenderer(modelName: "UnitCube", shader: shader))
        GameObject.root.addChild(gameObject: surfaceObj)
        
        let surfaceObj2 = GameObject(tag: "Surface")
        // set initial position
        surfaceObj2.transform.position = Vector3(x: 0, y: -10, z: 0)
        surfaceObj2.transform.scale.x = 10
        surfaceObj2.transform.scale.y = 0.5
        surfaceObj2.addComponent(component: BlockBody(tag: "Floor"))
        surfaceObj2.addComponent(component: ModelRenderer(modelName: "UnitCube", shader: shader))
        GameObject.root.addChild(gameObject: surfaceObj2)
        
        let surfaceObj3 = GameObject(tag: "Surface")
        // set initial position
        surfaceObj3.transform.position = Vector3(x: 0, y: 6, z: 0)
        surfaceObj3.transform.scale.x = 10
        surfaceObj3.transform.scale.y = 0.5
        surfaceObj3.addComponent(component: BlockBody(tag: "Floor"))
        surfaceObj3.addComponent(component: ModelRenderer(modelName: "UnitCube", shader: shader))
        GameObject.root.addChild(gameObject: surfaceObj3)
        
        let surfaceObj4 = GameObject(tag: "Surface")
        // set initial position
        surfaceObj4.transform.position = Vector3(x: 2, y: 10, z: 0)
        surfaceObj4.transform.scale.x = 2
        surfaceObj4.transform.scale.y = 0.5
        surfaceObj4.addComponent(component: BlockBody(tag: "Floor"))
        surfaceObj4.addComponent(component: ModelRenderer(modelName: "UnitCube", shader: shader))
        GameObject.root.addChild(gameObject: surfaceObj4)
        
        let leftWall = GameObject(tag: "Surface")
        // set initial position
        leftWall.transform.position = Vector3(x: -width/2, y: 0, z: 0)
        leftWall.transform.scale.x = 0.5
        leftWall.transform.scale.y = width/aspect
        leftWall.addComponent(component: BlockBody(tag: "Floor"))
        leftWall.addComponent(component: ModelRenderer(modelName: "UnitCube", shader: shader))
        GameObject.root.addChild(gameObject: leftWall)
        
        let rightWall = GameObject(tag: "Surface")
        // set initial position
        rightWall.transform.position = Vector3(x: width/2, y: 0, z: 0)
        rightWall.transform.scale.x = 0.5
        rightWall.transform.scale.y = width/aspect
        rightWall.addComponent(component: BlockBody(tag: "Floor"))
        rightWall.addComponent(component: ModelRenderer(modelName: "UnitCube", shader: shader))
        GameObject.root.addChild(gameObject: rightWall)
        
        let topWall = GameObject(tag: "Surface")
        // set initial position
        topWall.transform.position = Vector3(x: 0, y: width, z: 0)
        topWall.transform.scale.x = width
        topWall.transform.scale.y = 0.5
        topWall.addComponent(component: BlockBody(tag: "Floor"))
        topWall.addComponent(component: ModelRenderer(modelName: "UnitCube", shader: shader))
        GameObject.root.addChild(gameObject: topWall)
        
        let bottomWall = GameObject(tag: "Surface")
        // set initial position
        bottomWall.transform.position = Vector3(x: 0, y: -width, z: 0)
        bottomWall.transform.scale.x = width
        bottomWall.transform.scale.y = 0.5
        bottomWall.addComponent(component: BlockBody(tag: "Floor"))
        bottomWall.addComponent(component: ModelRenderer(modelName: "UnitCube", shader: shader))
        GameObject.root.addChild(gameObject: bottomWall)
    }
    
    
    func addModel ( model: inout Model)
    {
        models.append(model)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isMusicPlaying = true
        playMusic(soundFile: "menu")
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        Input.instance.gravity.invertGravity()
    }
    
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        // clear the scene
        glClearColor(0, 0, 0, 1.0)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT))
        
        glEnable(GLenum(GL_DEPTH_TEST))
        glEnable(GLenum(GL_CULL_FACE))
        glEnable(GLenum(GL_BLEND))
        glBlendFunc(GLenum(GL_SRC_ALPHA), GLenum(GL_ONE_MINUS_SRC_ALPHA))
        
        // draw each model
        for i in 0 ..< models.count {
            models[i].render()
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
        GameObject.root.getChild(tag: "Camera")?.transform.position.x = (GameObject.root.getChild(tag: "Sphere")?.transform.position.x)!
        GameObject.root.getChild(tag: "Camera")?.transform.position.y = (GameObject.root.getChild(tag: "Sphere")?.transform.position.y)!
    }
}
