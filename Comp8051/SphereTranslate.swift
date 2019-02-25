//
//  SphereTranslate.swift
//  Comp8051
//
//  Created by Paul on 2019-02-23.
//  Copyright © 2019 Paul. All rights reserved.
//

class SphereTranslate : Component {
    
    var translation: Vector3
    
    init(transx: Float, transy: Float, transz: Float) {
        translation = Vector3(x: transx, y: transy, z: transz)
    }
    
    override func update(deltaTime: Float) {
        gameObject?.transform.position += translation * deltaTime
        
        // OUT OF BOUNDS WRAPAROUND
        if(gameObject!.transform.position.x*10 >= 118){
            gameObject!.transform.position.x = -117/10;
            print("OUT OF BOUNDS WRAPAROUND +X");
        }
        if(gameObject!.transform.position.x*10 <= -118){
            gameObject!.transform.position.x = 117/10;
            print("OUT OF BOUNDS WRAPAROUND -X");
        }
        if(gameObject!.transform.position.y*10 >= 201){
            gameObject!.transform.position.y = -200/10;
            print("OUT OF BOUNDS WRAPAROUND +Y");
        }
        if(gameObject!.transform.position.y*10 <= -201){
            gameObject!.transform.position.y = 200/10;
            print("OUT OF BOUNDS WRAPAROUND -Y");
        }
    }
}

