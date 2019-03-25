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

@implementation PhysicsWrapper {
    
    Physics* physics;
}

static PhysicsWrapper* instance = nil;

- (instancetype)init {
    
    if (self = [super init]) {
        
        // singleton initialization
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            instance = self;
            
            // other initialization here
            instance->physics = [[Physics alloc] init];
            
            printf("Physics initialized.\n");
        });
    }
    return self;
}

+ (void)update:(float)deltaTime {
    
    [instance->physics update:deltaTime];
}

+ (void)setGravityX:(float) x y:(float)y {
    
    [instance->physics setGravityX:x y:y];
}

+ (void)addGroundBody:(NSString*) tag posX:(float) posX posY:(float) posY scaleX:(float) scaleX
               scaleY:(float) scaleY rotation:(float) rotation {
    
    [instance->physics addGroundBody:tag posX:posX posY:posY scaleX:scaleX scaleY:scaleY rotation:rotation];
}

+ (void)addBallBody:(NSString*) tag posX:(float) posX posY:(float) posY radius:(float) radius {
    
    [instance->physics addBallBody:tag posX:posX posY:posY radius:radius];
}

+ (CTransform)getBodyTransform:(NSString*) tag {
    
    return [instance->physics getBodyTransform:tag];
}

@end
