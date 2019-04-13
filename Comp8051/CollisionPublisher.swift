//
//  ContactNotifier.swift
//  Comp8051
//
//  Created by Nathaniel on 2019-04-02.
//  Copyright © 2019 Paul. All rights reserved.
//

@objc class CollisionPublisher: NSObject {
    
    private var bodies: [Body] = []
    public static let instance = CollisionPublisher()
    
    static func subscribe (body: Body) {
        
        instance.bodies.append(body)
    }
    
    static func unsubscribeAll() {
        
        instance.bodies.removeAll()
    }
    
    // filters collision enter events so that only the bodies concerned with the collision are notified
    @objc static func handleCollisionEnter (tag1: String, tag2: String) {
        
        var tag1Found = false
        var tag2Found = false

        for body in instance.bodies {
            
            if tag1Found && tag2Found {
                
                break
            }
            else if body.tag == tag1 {
                
                body.onCollisionEnter(tag: tag2)
                tag1Found = true
            }
            else if body.tag == tag2 {
                
                body.onCollisionEnter(tag: tag1)
                tag2Found = true
            }
        }
    }
    
    // filters collision exit events so that only the bodies concerned with the collision are notified
    @objc static func handleCollisionExit (tag1: String, tag2: String) {
        
        var tag1Found = false
        var tag2Found = false
        
        for body in instance.bodies {
            
            if tag1Found && tag2Found {
                
                break
            }
            else if body.tag == tag1 {
                
                body.onCollisionExit(tag: tag2)
                tag1Found = true
            }
            else if body.tag == tag2 {
                
                body.onCollisionExit(tag: tag1)
                tag2Found = true
            }
        }
    }
}
