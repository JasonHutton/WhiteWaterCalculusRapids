//
//  Physics.m
//  Comp8051
//
//  Created by Nathaniel on 2019-03-23.
//  Copyright © 2019 Paul. All rights reserved.
//

#import "Box2D/Box2D.h"
#import "Physics.h"

@implementation Physics {
    
    // private variables
    b2World* world;
}

- (instancetype)init {
    
    if (self = [super init]) {
        
        b2Vec2 gravity(0.0f, -9.81f);
        world = new b2World(gravity);
    }
    return self;
}

- (void)update:(float)deltaTime {
    
    world->Step(deltaTime, 6, 2);
}

@end
