//
//  ModelRenderer.swift
//  Comp8051
//
//  Created by Nathaniel on 2019-02-23.
//  Copyright © 2019 Paul. All rights reserved.
//

import GLKit

class ModelRenderer : Component {
    
    private var model: Model?
    private static var camera: GameObject?
    
    init(modelName: String, shader: BaseEffect, texture: String? = nil ) {
        
        // if texture is specified, use it
        if(texture == nil){
            model = Model(modelName: modelName, shader: shader)
        } else {
            model = Model(modelName: modelName, shader: shader, texture: texture)
        }
        
        ViewController.instance?.addModel(model: &model!)
        
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
    
    override func lateUpdate(deltaTime: Float) {
        
        if var transform = gameObject?.worldTransform, let cam = ModelRenderer.camera?.transform {
            
            // get position relative to camera
            transform.position -= cam.position
            
            var transformationMatrix = GLKMatrix4Identity
            // camera rotation
            transformationMatrix = GLKMatrix4RotateX(transformationMatrix, -cam.rotation.x)
            transformationMatrix = GLKMatrix4RotateY(transformationMatrix, cam.rotation.y)
            
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
            
            model?.modelViewMatrix = transformationMatrix
        }
        
    }
    
    override func onDestroy() {
        model = nil
    }
    
}
