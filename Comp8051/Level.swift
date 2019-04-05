//
//  Level.swift
//  Comp8051
//
//  Created by Paul on 2019-04-02.
//  Copyright © 2019 Paul. All rights reserved.
//

import Foundation
import GLKit

class Level {
    
    static func createLevel(width: Float, aspect: Float, shader: BaseEffect) {
        
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
        sphereObj.addComponent(component: CollisionSound(sound: SoundEffect(soundFile: "ballimpact")))
        sphereObj.addComponent(component: ModelRenderer(modelName: "ICOSphere", shader: shader))
        GameObject.root.addChild(gameObject: sphereObj)
        // add camera track component to track sphere
        cameraObj.addComponent(component: CameraTrack(trackedObj: sphereObj))
        
        
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
        leftWall.transform.scale.y = width*2
        leftWall.addComponent(component: BlockBody(tag: "Floor"))
        leftWall.addComponent(component: ModelRenderer(modelName: "UnitCube", shader: shader))
        GameObject.root.addChild(gameObject: leftWall)
        
        let rightWall = GameObject(tag: "Surface")
        // set initial position
        rightWall.transform.position = Vector3(x: width/2, y: 0, z: 0)
        rightWall.transform.scale.x = 0.5
        rightWall.transform.scale.y = width*2
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
        bottomWall.addComponent(component: BlockBody(tag: "Win"))
        bottomWall.addComponent(component: ModelRenderer(modelName: "UnitCube", shader: shader, texture: "winTexture.jpg"))
        GameObject.root.addChild(gameObject: bottomWall)
        
        let deathWall = GameObject(tag: "Death")
        deathWall.transform.position = Vector3(x: 0, y: width+50, z: 0)
        deathWall.transform.scale.x = width
        deathWall.transform.scale.y = 100
        deathWall.transform.scale.z = 2
        deathWall.addComponent(component: DeathWallBehaviour())
        deathWall.addComponent(component: KinematicBlockBody(tag: "Lose"))
        deathWall.addComponent(component: ModelRenderer(modelName: "UnitCube", shader: shader, texture: "deathTexture.jpg"))
        GameObject.root.addChild(gameObject: deathWall)
    }
}
