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

@implementation PhysicsWrapper

static Physics* physics = nil;

+ (void)start {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        physics = [[Physics alloc] init];
        
        printf("Physics initialized.\n");
    });
}

+ (void)update:(float)deltaTime {
    
    [physics update:deltaTime];
}

+ (void)setGravityX:(float) x y:(float)y {
    
    [physics setGravityX:x y:y];
}

+ (void)addGroundBody:(NSString*) tag posX:(float) posX posY:(float) posY scaleX:(float) scaleX
               scaleY:(float) scaleY rotation:(float) rotation {
    
    [physics addGroundBody:tag posX:posX posY:posY scaleX:scaleX scaleY:scaleY rotation:rotation];
}

+ (void)addBallBody:(NSString*) tag posX:(float) posX posY:(float) posY radius:(float) radius {
    
    [physics addBallBody:tag posX:posX posY:posY radius:radius];
}

+ (CTransform)getBodyTransform:(NSString*) tag {
    
    return [physics getBodyTransform:tag];
}

@end
