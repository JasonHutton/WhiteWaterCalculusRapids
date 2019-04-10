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

    @IBOutlet weak var musicButton: UIButton!
    @IBOutlet weak var soundButton: UIButton!
    static let frameRate: Int = 60
    
    static let deltaTime: Float = 1.0/Float(frameRate)
    
    static let fov: Float = 40
    
    static var instance: ViewController?
    
    private var setupComplete = false
    
    private var context: EAGLContext?

    private var effect = GLKBaseEffect()
    
    var models : [Model?] = []
    
    var shader : BaseEffect!

    var score: Int = 0
    
    var level: Level? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        preferredFramesPerSecond = ViewController.frameRate
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        view.addGestureRecognizer(tap)
        
        Settings.instance.playMusic(soundFile: "gameplay3")
        
        // Set audio button to be the same image as on menu screen
        soundButton.setImage(MenuViewController.instance?.soundButton.currentImage, for: .normal)
        musicButton.setImage(MenuViewController.instance?.musicButton.currentImage, for: .normal)
        
        setupGL()
    }
    
    @IBAction func toggleSound(_ sender: Any) {
        var btnImage : UIImage?
        
        if(Settings.instance.getSetting(name: Settings.Names.playSound.rawValue)) {
            Settings.instance.setSetting(name: Settings.Names.playSound.rawValue, value: false)
            btnImage = UIImage(named: "mute")

        } else {
            Settings.instance.setSetting(name: Settings.Names.playSound.rawValue, value: true)
            btnImage = UIImage(named: "notMute")
        }
        
        soundButton.setImage(btnImage, for: .normal)
        MenuViewController.instance?.soundButton.setImage(btnImage, for: .normal)// set audio button in menu
    }
    
    @IBAction func toggleMusic(_ sender: Any) {
        var btnImage : UIImage?
        
        if(Settings.instance.getSetting(name: Settings.Names.playMusic.rawValue)) {
            Settings.instance.setSetting(name: Settings.Names.playMusic.rawValue, value: false)
            Settings.instance.player.pause()
            btnImage = UIImage(named: "musicMute")
            
        } else {
            Settings.instance.setSetting(name: Settings.Names.playMusic.rawValue, value: true)
            Settings.instance.player.play()
            btnImage = UIImage(named: "musicNotMute")
        }
        
        musicButton.setImage(btnImage, for: .normal)
        MenuViewController.instance?.musicButton.setImage(btnImage, for: .normal)// set audio button in menu
    }
    @IBAction func quitGame(_ sender: Any) {
        quit()
    }
    
    public func win(){
        performSegue(withIdentifier: "winGame", sender: nil)
        Settings.instance.playMusic(soundFile: "complete")
    }
    
    public func lose(){
        performSegue(withIdentifier: "loseGame", sender: nil)
        Settings.instance.playMusic(soundFile: "gameover")
    }
    
    public func quit(){
        scoreLabel.text = "Score: \(score)"
        Settings.instance.playMusic(soundFile: "menu")
        tearDownGL()
        tearDownLevel()
        dismiss(animated: true, completion: nil)
        dismiss(animated: true, completion: nil) // need the second one when returning from win or game over screen
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
        
        // calculate values for fov and game screen width
        let hAspect = fabsf(Float(view.bounds.size.height) / Float(view.bounds.size.width))
        let hFov = GLKMathDegreesToRadians(ViewController.fov);
        let vFov = 2 * atan(tan(hFov / 2) * hAspect)
        let cameraDist: Float = Level.NODE_WIDTH / (2 * tan(hFov/2))
        
        // apply perspective transformation
        let vAspect = fabsf(Float(view.bounds.size.width) / Float(view.bounds.size.height))
        let projectionMatrix = GLKMatrix4MakePerspective(vFov, vAspect, 1.0, 40.0)
        self.shader = BaseEffect(vertexShader: "SimpleVertexShader.glsl", fragmentShader: "SimpleFragmentShader.glsl")
        
        shader.projectionMatrix = projectionMatrix
        
        Level.storeAllNodes() // attempt to store nodes in memory from json files, only runs once
        level = Level(shader: shader)
        level!.loadUniversalGameObjects(cameraDist: cameraDist)
        // Level.loadRandomNode(yOffset: 0, width: width, shader: shader)
    }
    
    
    func addModel ( model: inout Model)
    {
        models.append(model)
    }
    
    func removeModels() {
        models.removeAll()
    }
    
    func removeModel(model: Model) {
        models = models.filter {$0 != model}
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        
        Input.instance.tapped = !Input.instance.tapped
    }
    
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        // clear the scene
        glClearColor(0.5, 0.5, 0.5, 1.0)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT))
        
        glEnable(GLenum(GL_DEPTH_TEST))
        glEnable(GLenum(GL_CULL_FACE))
        glEnable(GLenum(GL_BLEND))
        glBlendFunc(GLenum(GL_SRC_ALPHA), GLenum(GL_ONE_MINUS_SRC_ALPHA))
        
        // draw each model
        for i in 0 ..< models.count {
            models[i]?.render()
        }
    }
    
    private func tearDownGL() {
        EAGLContext.setCurrent(context)
        
        EAGLContext.setCurrent(nil)
        
        context = nil
    }
    
    private func tearDownLevel(){
        level!.close()
        removeModels()
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
        
        score = score + 1
        //Settings.instance.setSetting(name: Settings.Names.highScore.rawValue, value: score, explicitSave: true) // We don't want to be saving highscore constantly, or displaying it as normal score
        
        scoreLabel.text = "Score: \(score)"
    }
}
