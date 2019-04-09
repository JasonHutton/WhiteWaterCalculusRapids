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
    @IBOutlet weak var audioButton: UIButton!
    
    static var deltaTime: Float = 1.0/30.0
    
    static var instance: ViewController?
    
    private var setupComplete = false
    
    private var context: EAGLContext?

    private var effect = GLKBaseEffect()
    
    var models : [Model?] = []
    
    var shader : BaseEffect!

    var score: Int = 0
    
    @IBAction func toggleAudio(_ sender: Any) {
        if(Settings.instance.getSetting(name: Settings.Names.playMusic.rawValue)) {
            Settings.instance.setSetting(name: Settings.Names.playMusic.rawValue, value: false)
            Settings.instance.player.pause()
            audioButton.setTitle("Un-mute Audio", for: .normal)
        } else {
            Settings.instance.setSetting(name: Settings.Names.playMusic.rawValue, value: true)
            Settings.instance.player.play()
            audioButton.setTitle("Mute Audio", for: .normal)
        }
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
        
        // apply perspective transformation
        let aspect = fabsf(Float(view.bounds.size.width) / Float(view.bounds.size.height))
        let projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65), aspect, 1.0, 40.0)
        let width = 30 * tan(GLKMathDegreesToRadians(32.5))
        self.shader = BaseEffect(vertexShader: "SimpleVertexShader.glsl", fragmentShader: "SimpleFragmentShader.glsl")
        
        shader.projectionMatrix = projectionMatrix
        
        Level.loadLevel(fileName: "Level01", width: width, aspect: aspect, shader: shader)
    }
    
    
    func addModel ( model: inout Model)
    {
        models.append(model)
    }
    
    func removeModels() {
        models.removeAll()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        view.addGestureRecognizer(tap)
        
        Settings.instance.playMusic(soundFile: "gameplay3")
        
        setupGL()
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
            models[i]?.render()
        }
    }
    
    private func tearDownGL() {
        EAGLContext.setCurrent(context)
        
        EAGLContext.setCurrent(nil)
        
        context = nil
    }
    
    private func tearDownLevel(){
        Level.deleteLevel()
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
