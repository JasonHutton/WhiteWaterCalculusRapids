//
//  PhysicsWrapper.m
//  Comp8051
//
//  Created by Nathaniel on 2019-03-23.
//  Copyright © 2019 Paul. All rights reserved.
//

#import "Physics.h"
#import "CTransform.h"
#import "Comp8051-Swift.h"
#import "PhysicsWrapper.h"

/*
    READ ME
 
    This is to serve as a static Objective-C wrapper for the Objective-C++ physics class.
    This was because the Box2D library is written in C++, which can only be used in Objective-C++, and our code is written in Swift, which can interact with Objective-C and not Objective-C++.
    The interfaces of all functions are identical, only they can be called statically and from Swift.
 */

@implementation PhysicsWrapper

static Physics* physics = nil;

+ (void)start {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        physics = [[Physics alloc] init];
        
        printf("Physics initialized.\n");
    });
}

// step the physics one tick forward
+ (void)update:(float)deltaTime {
    
    [physics update:deltaTime];
}

// change the gravity vector - input should be clamped below magnitude 1
+ (void)setGravityX:(float) x y:(float)y {
    
    [physics setGravityX:x y:y];
}

// add a static square to the world
+ (void)addGroundBody:(NSString*) tag posX:(float) posX posY:(float) posY scaleX:(float) scaleX
               scaleY:(float) scaleY rotation:(float) rotation {
    
    [physics addGroundBody:tag posX:posX posY:posY scaleX:scaleX scaleY:scaleY rotation:rotation];
}

+ (void)addKinematicBody:(NSString*) tag posX:(float) posX posY:(float) posY scaleX:(float) scaleX
                  scaleY:(float) scaleY rotation:(float) rotation {
    
    [physics addKinematicBody:tag posX:posX posY:posY scaleX:scaleX scaleY:scaleY rotation:rotation];
}

// add a dynamic circle to the world
+ (void)addBallBody:(NSString*) tag posX:(float) posX posY:(float) posY radius:(float) radius {
    
    [physics addBallBody:tag posX:posX posY:posY radius:radius];
}

// find a transform by its tag
+ (CTransform)getBodyTransform:(NSString*) tag {
    
    return [physics getBodyTransform:tag];
}

// pass the collider tags to the contact notifier
+ (void)handleCollisionEnter:(NSString*) tag1 tag2:(NSString*) tag2 {
    
    printf("oh no\n");
    [CollisionPublisher handleCollisionEnterWithTag1:tag1 tag2:tag2];
}

// pass the collider tags to the contact notifier
+ (void)handleCollisionExit:(NSString*) tag1 tag2:(NSString*) tag2 {
    
    [CollisionPublisher handleCollisionExitWithTag1:tag1 tag2:tag2];
}

// sets a body's transform in the world
+ (void)setBodyPosition:(NSString*)tag transform:(CTransform) transform {
    
    [physics setBodyPosition:tag transform:transform];
}

+ (void)removeBody:(NSString*) tag{
    
    [physics removeBody:tag];
}

+ (void)removeAllBodies{
    
    [physics removeAllBodies];
}
@end
