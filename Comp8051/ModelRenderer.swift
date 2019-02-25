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
    
    init(modelName: String) {
        model = Model(modelName: modelName)
        ViewController.instance?.addModel(model: &model)
    }
    
    override func update(deltaTime: Float) {
        
        if let gameObject = self.gameObject {
            
            let transform = gameObject.worldTransform
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
