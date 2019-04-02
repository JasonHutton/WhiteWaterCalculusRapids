//
//  Physics.m
//  Comp8051
//
//  Created by Nathaniel on 2019-03-23.
//  Copyright © 2019 Paul. All rights reserved.
//

#import "CTransform.h"
#import "Box2D.h"
#import "ContactListener.hpp"
#import "PhysicsWrapper.h"
#import <dispatch/dispatch.h>
#import "Physics.h"

@implementation Physics {
    
    b2World* world;
    NSMutableDictionary* dict;
}

const float GRAV_CONSTANT = 9.81f;

- (instancetype)init {
    
    if (self = [super init]) {
        
        b2Vec2 gravity(0.0f, -GRAV_CONSTANT);
        world = new b2World(gravity);
        dict = [[NSMutableDictionary alloc] init];
        
        world->SetContactListener(new ContactListener(self));
    }
    return self;
}

// step the physics one tick forward
- (void)update:(float)deltaTime {
    
    world->Step(deltaTime, 6, 2);
}

// change the gravity vector - input should be clamped below magnitude 1
- (void)setGravityX:(float) x y:(float)y {
    
    b2Vec2 gravity(x * GRAV_CONSTANT, y * GRAV_CONSTANT);
    world->SetGravity(gravity);
}

// add a static square to the world
- (void)addGroundBody:(NSString*) tag posX:(float) posX posY:(float) posY scaleX:(float) scaleX
               scaleY:(float) scaleY rotation:(float) rotation {
    
    b2BodyDef groundBodyDef;
    groundBodyDef.type = b2_staticBody;
    groundBodyDef.position.Set(posX, posY);
    
    b2PolygonShape groundBox;
    groundBox.SetAsBox(scaleX / 2, scaleY / 2);
    
    b2Body* groundBody = world->CreateBody(&groundBodyDef);
    groundBody->CreateFixture(&groundBox, 0.0f);
    groundBody->SetTransform(groundBody->GetPosition(), rotation);
    groundBody->GetFixtureList()->SetUserData((__bridge void*)tag);
    
    // add ground body to the dictionary
    [dict setObject:[NSValue valueWithPointer:groundBody] forKey:tag];
}

// add a dynamic circle to the world
- (void)addBallBody:(NSString*) tag posX:(float) posX posY:(float) posY radius:(float) radius {
    
    b2BodyDef ballBodyDef;
    ballBodyDef.type = b2_dynamicBody;
    ballBodyDef.position.Set(posX, posY);
    
    b2CircleShape circle;
    circle.m_radius = radius;
    
    b2FixtureDef ballShapeDef;
    ballShapeDef.shape = &circle;
    ballShapeDef.density = 1.0f;
    ballShapeDef.friction = 0.5f;
    ballShapeDef.restitution = 0.5f;
    
    b2Body* ballBody = world->CreateBody(&ballBodyDef);
    ballBody->CreateFixture(&ballShapeDef);
    ballBody->GetFixtureList()->SetUserData((__bridge void*)tag);
    
    [dict setObject:[NSValue valueWithPointer:ballBody] forKey:tag];
}

// find a transform by its tag
- (CTransform)getBodyTransform:(NSString*) tag {
    
    b2Body* body = (b2Body*)[[dict valueForKey:tag] pointerValue];
    
    b2Vec2 vec = body->GetPosition();
    
    CTransform transform;
    transform.position.x = vec.x;
    transform.position.y = vec.y;
    transform.rotation = body->GetAngle();
    
    return transform;
}

// pass the collider tags to the physicswrapper enter function
- (void)handleCollisionEnter:(NSString*) tag1 tag2:(NSString*) tag2 {
    
    [PhysicsWrapper handleCollisionEnter:tag1 tag2:tag2];
}

// pass the collider tags to the physicswrapper exit function
- (void)handleCollisionExit:(NSString*) tag1 tag2:(NSString*) tag2 {
    
    [PhysicsWrapper handleCollisionExit:tag1 tag2:tag2];
}

@end
