//
//  ModelRenderer.swift
//  Comp8051
//
//  Created by Nathaniel on 2019-02-23.
//  Copyright © 2019 Paul. All rights reserved.
//

import GLKit

class ModelRenderer : Component {
    
    private var model: Model
    private static var camera: GameObject?
    
    init(modelName: String, shader: BaseEffect) {
        
        model = Model(modelName: modelName, shader: shader)
        ViewController.instance?.addModel(model: &model)
        
        // grab the camera, if not already grabbed
        if ModelRenderer.camera == nil {
            
            if let obj = GameObject.root.getChild(tag: "Camera") {
                
                ModelRenderer.camera = obj
            } else {
                
                print("Error: Camera object not found.")
                ModelRenderer.camera = GameObject(tag: "Camera")
            }
        }
    }
    
    override func update(deltaTime: Float) {
        
        if let gameObject = self.gameObject, let camPos = ModelRenderer.camera?.transform.position {
            
            // get position relative to camera
            // TODO, MAYBE?: relative to camera only cares about position, ignores rotation - probably not important
            var transform = gameObject.transform
            transform.position -= camPos
            
            var transformationMatrix = GLKMatrix4Identity
            // translation
            transformationMatrix = GLKMatrix4Translate(transformationMatrix,
                                                 transform.position.x,
                                                 transform.position.y,
                                                 transform.position.z)
            // rotation, badly
            transformationMatrix = GLKMatrix4RotateX(transformationMatrix, transform.rotation.x)
            transformationMatrix = GLKMatrix4RotateY(transformationMatrix, transform.rotation.y)
            transformationMatrix = GLKMatrix4RotateZ(transformationMatrix, transform.rotation.z)
            // scale
            transformationMatrix = GLKMatrix4Scale(transformationMatrix,
                                             transform.scale.x,
                                             transform.scale.y,
                                             transform.scale.z)
            
            
            model.modelViewMatrix = transformationMatrix
        }
        
    }
    
    override func onDestroy() {
        // TODO: deallocate buffers or whatever, not sure how literally any part of opengl works lol
    }
    
}
