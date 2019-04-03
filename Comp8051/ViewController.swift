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
    
    @IBOutlet weak var scoreLabel: UILabel!
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

    var score: Int = 0
    
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
        quit()
    }
    
    public func quit(){
        menuView.isHidden = false
        playMusic(soundFile: "menu")
        tearDownGL()
        tearDownLevel()
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
        
        let level = Level()
        level.createLevel(width: width, aspect: aspect, shader: shader)
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
        
        Input.instance.tapped = !Input.instance.tapped
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
    
    private func tearDownLevel(){
    
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
        
        // temp
        GameObject.root.getChild(tag: "Camera")?.transform.position.x = (GameObject.root.getChild(tag: "Sphere")?.transform.position.x)!
        GameObject.root.getChild(tag: "Camera")?.transform.position.y = (GameObject.root.getChild(tag: "Sphere")?.transform.position.y)!
        
        GameObject.root.getChild(tag: "Death")?.transform.position.y -= 0.05
        
        scoreLabel.text = "Score: \(score)"
    }
}
