//
//  Level.swift
//  Comp8051
//
//  Created by Paul on 2019-04-02.
//  Copyright © 2019 Paul. All rights reserved.
//

class Level {
    
    public static let NODE_WIDTH: Float = 20
    public static let NODE_HEIGHT: Float = 10
    private static var nodePrefabs = [[Dictionary<String,Any>]]()
    private static var hasStored = false
    
    public var nodes = Queue<Node>()
    public let shader: BaseEffect
    
    init(shader: BaseEffect) {
        
        self.shader = shader
    }
    
    static func storeAllNodes() {
        
        if !hasStored {
            
            let files = TextLoader.loadFiles(fileType: ".json")
            for file in files {
                
                storeNode(jsonString: file)
            }
            
            hasStored = true
        }
    }
    
    // load a json string and store it as a node
    static func storeNode(fileName: String) {
        
        let string : String = TextLoader.loadFile(fileName: fileName, fileType: "json")!
        storeNode(jsonString: string)
    }
    
    // convert a json string to a dictionary
    static func storeNode(jsonString: String) {
        
        let data = jsonString.data(using: .utf8)!
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>] {
                
                nodePrefabs.append(jsonArray)
                
            } else {
                
                print("bad json")
            }
        } catch let error as NSError {
            print(error)
        }
    }
    
    func loadRandomNode(yOffset: Float) {
        
        if var jsonArray = Level.nodePrefabs.randomElement() {
            
            //jsonArray = Level.nodePrefabs[1] // temp override
            
            let node = Node(y: yOffset)
            
            for json in jsonArray {
                
                let obj = loadGameObject(json: json, parent: GameObject.root, yOffset: yOffset)
                
                node.add(gameObject: obj)
            }
            
            nodes.enqueue(node)
        }
    }
    
    func loadEmptyNode(yOffset: Float) {
        
        let leftWall = GameObject(tag: "Wall");
        leftWall.transform.position.x = -Level.NODE_WIDTH / 2
        leftWall.transform.position.y = yOffset
        leftWall.transform.scale.y = Level.NODE_HEIGHT
        leftWall.addComponent(component: ModelRenderer(modelName: "UnitCube", shader: shader))
        leftWall.addComponent(component: BlockBody(tag: "Floor"))
        GameObject.root.addChild(gameObject: leftWall)
        
        let rightWall = GameObject(tag: "Wall");
        rightWall.transform.position.x = Level.NODE_WIDTH / 2
        rightWall.transform.position.y = yOffset
        rightWall.transform.scale.y = Level.NODE_HEIGHT
        rightWall.addComponent(component: ModelRenderer(modelName: "UnitCube", shader: shader))
        rightWall.addComponent(component: BlockBody(tag: "Floor"))
        GameObject.root.addChild(gameObject: rightWall)
        
        let node = Node(y: yOffset)
        
        node.add(gameObject: leftWall)
        node.add(gameObject: rightWall)
        
        nodes.enqueue(node)
    }
    
    // traverse all the key value pairs in the json object and create a gameobject from their values
    private func loadGameObject(json: Dictionary<String,Any>, parent: GameObject, yOffset: Float) -> GameObject {
        
        var tag = String()
        var pos = Vector3(x: 0, y: 0, z: 0)
        var scale = Vector3(x: 1, y: 1, z: 1)
        var rot = Vector3(x: 0, y: 0, z: 0)
        var components = [Component]()
        
        for (key, value) in json {
            
            switch (key) {
            case "tag":
                tag = value as! String
                break
            case "position":
                if let val = value as? Dictionary<String,Any> {
                    pos.x = Float(val["x"] as! Double)
                    pos.y = Float(val["y"] as! Double) + yOffset // apply y offset
                    pos.z = Float(val["z"] as! Double)
                    // multiply axis by width if scalebywidth is set
                    if let _ = val["xScaleByWidth"] {
                        pos.x *= Level.NODE_WIDTH
                    }
                    if let _ = val["yScaleByWidth"] {
                        pos.y *= Level.NODE_WIDTH
                    }
                    if let _ = val["zScaleByWidth"] {
                        pos.z *= Level.NODE_WIDTH
                    }
                }
                break
            case "scale":
                if let val = value as? Dictionary<String,Any> {
                    scale.x = Float(val["x"] as! Double)
                    scale.y = Float(val["y"] as! Double)
                    scale.z = Float(val["z"] as! Double)
                    // multiply axis by width if scalebywidth is set
                    if let _ = val["xScaleByWidth"] {
                        scale.x *= Level.NODE_WIDTH
                    }
                    if let _ = val["yScaleByWidth"] {
                        scale.y *= Level.NODE_WIDTH
                    }
                    if let _ = val["zScaleByWidth"] {
                        scale.z *= Level.NODE_WIDTH
                    }
                }
                break
            case "rotation":
                if let val = value as? Dictionary<String,Any> {
                    rot.x = Float(val["x"] as! Double)
                    rot.y = Float(val["y"] as! Double)
                    rot.z = Float(val["z"] as! Double)
                }
                break
            case "components":
                if let componentsJson = value as? [Dictionary<String,Any>] {
                    
                    for componentJson in componentsJson {
                        
                        if let component = getComponent(json: componentJson) {
                            
                            components.append(component)
                        }
                    }
                }
                break
            default:
                print("unrecognized key")
            }
        }
        
        // create the gameobject
        let obj = GameObject(tag: tag)
        
        obj.transform.position = pos
        obj.transform.scale = scale
        obj.transform.rotation = rot
        
        for component in components {
            
            obj.addComponent(component: component)
        }
        
        parent.addChild(gameObject: obj)
        
        return obj
    }
    
    // initialize a components of the correct type given a json object
    private func getComponent(json: Dictionary<String,Any>) -> Component? {
        
        var component: Component? = nil
        let type = json["type"] as! String
        switch (type) {
        case "ModelRenderer":
            component = ModelRenderer(modelName: json["modelName"] as! String, shader: shader)
            break
        case "BlockBody":
            component = BlockBody(tag: json["tag"] as! String)
            break
        default:
            print("unrecognized type")
        }
        
        return component
    }
    
    func loadUniversalGameObjects(cameraDist: Float) {
        
        // set up scene
        GameObject.root.addComponent(component: GravityManager()) // this is silly but it works
        
        // add camera before adding any model renderers
        let cameraObj = GameObject(tag: "Camera")
        cameraObj.transform.position.z = cameraDist
        GameObject.root.addChild(gameObject: cameraObj)
        
        let sphereObj = GameObject(tag: "Sphere")
        // set initial position
        sphereObj.transform.position = Vector3(x: 0, y: 2, z: 0)
        // add component to rotate the sphere (probably temporary)
        sphereObj.addComponent(component: SphereBody(tag: "Ball"))
        sphereObj.addComponent(component: ContextCollisionSounds(sound: SoundEffect(soundFile: "ballimpact"), sounds: ["Lose": SoundEffect(soundFile: "ballblast")]))
        sphereObj.addComponent(component: ModelRenderer(modelName: "ICOSphere", shader: shader))
        GameObject.root.addChild(gameObject: sphereObj)
        // add camera track component to track sphere
        cameraObj.addComponent(component: CameraTrack(trackedObj: sphereObj))
        
        let deathWall = GameObject(tag: "Death")
        deathWall.transform.position = Vector3(x: 0, y: 30, z: 0)
        deathWall.transform.scale.x = Level.NODE_WIDTH
        deathWall.transform.scale.y = 40
        deathWall.transform.scale.z = 2
        deathWall.addComponent(component: DeathWallBehaviour(player: sphereObj, acceleration: 0.1, initialVelocity: 1, maxDist: 100))
        deathWall.addComponent(component: KinematicBlockBody(tag: "Lose"))
        deathWall.addComponent(component: ModelRenderer(modelName: "UnitCube", shader: shader, texture: "lavaTexture.jpg"))
        GameObject.root.addChild(gameObject: deathWall)
        // add level generator to sphere
        sphereObj.addComponent(component: LevelGenerator(deleteObj: deathWall, spawnAhead: 3, level: self))
    }
    
    func close() {
        
        nodes.removeAll()
        CollisionPublisher.unsubscribeAll()
        GameObject.root.removeAllChildren()
        GameObject.root.removeAllComponents()
        ModelRenderer.camera = nil
    }
}
