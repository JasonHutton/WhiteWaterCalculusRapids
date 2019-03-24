//
//  PhysicsWrapper.m
//  Comp8051
//
//  Created by Nathaniel on 2019-03-23.
//  Copyright © 2019 Paul. All rights reserved.
//

#import "Physics.h"
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
            instance = [[PhysicsWrapper alloc] init];
            
            // other initialization here
            instance->physics = [[Physics alloc] init];
        });
    }
    return self;
}

+ (void)update:(float)deltaTime {
    
    [instance->physics update:deltaTime];
}

@end
