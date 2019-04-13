//
//  PointLight.swift
//  Comp8051
//
//  Created by Jason Hutton on 2019-04-12.
//  Copyright © 2019 Paul. All rights reserved.
//

import Foundation
import GLKit

class PointLight : Component {

    private(set) var transform : Transform = Transform()
    public var color : Vector3 = Vector3(x: 1, y: 1, z: 1)
    public var ambientIntensity : Float = 0.5
    public var diffuseIntensity : Float = 0.5
    public var specularIntensity : Float = 0.5
    public var shininess : Float = 0.5
    public var constant : Float = 0.5
    public var linear: Float = 0.5
    public var quadratic : Float = 0.5
    
    init(color: Vector3, ambientIntensity: Float, diffuseIntensity: Float, specularIntensity: Float, shininess: Float, constant: Float, linear: Float, quadratic: Float) {

        super.init()
        
        self.updatePosition()
        self.color = color
        self.ambientIntensity = ambientIntensity
        self.diffuseIntensity = diffuseIntensity
        self.specularIntensity = specularIntensity
        self.shininess = shininess
        self.constant = constant
        self.linear = linear
        self.quadratic = quadratic
    }
    
    override func onEnable() {
        
        self.updatePosition()
    }
    
    override func update(deltaTime: Float) {
        // Update position as the gameobject moves
        updatePosition()
    }

    private func updatePosition() {
        self.transform = (gameObject?.worldTransform)!
    }
}
