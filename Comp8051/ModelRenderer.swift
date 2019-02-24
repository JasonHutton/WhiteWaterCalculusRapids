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
            var transformation = GLKMatrix4Identity
            // translation
            transformation = GLKMatrix4Translate(transformation,
                                                 gameObject.transform.position.x,
                                                 gameObject.transform.position.y,
                                                 gameObject.transform.position.z)
            // rotation
            transformation = GLKMatrix4RotateX(transformation, gameObject.transform.rotation.x)
            transformation = GLKMatrix4RotateY(transformation, gameObject.transform.rotation.y)
            transformation = GLKMatrix4RotateZ(transformation, gameObject.transform.rotation.z)
            // scale
            transformation = GLKMatrix4Scale(transformation,
                                             gameObject.transform.scale.x,
                                             gameObject.transform.scale.y,
                                             gameObject.transform.scale.z)
            
            
            model.modelViewMatrix = transformation
        }
        
    }
    
    override func onDestroy() {
        // TODO: deallocate buffers or whatever, not sure how literally any part of opengl works lol
    }
}
