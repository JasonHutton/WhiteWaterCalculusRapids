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
const float SCALE_FACTOR = 8.0f;

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
    
    world->Step(deltaTime, 6, 6);
}

// change the gravity vector - input should be clamped below magnitude 1
- (void)setGravityX:(float) x y:(float)y {
    
    b2Vec2 gravity(x * GRAV_CONSTANT, y * GRAV_CONSTANT);
    world->SetGravity(gravity);
}

// add a static square to the world
- (void)addGroundBody:(NSString*) tag posX:(float) posX posY:(float) posY scaleX:(float) scaleX
               scaleY:(float) scaleY rotation:(float) rotation {
    
    posX /= SCALE_FACTOR;
    posY /= SCALE_FACTOR;
    scaleX /= SCALE_FACTOR;
    scaleY /= SCALE_FACTOR;
    
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

// add a kinematic square
- (void)addKinematicBody:(NSString*) tag posX:(float) posX posY:(float) posY scaleX:(float) scaleX
               scaleY:(float) scaleY rotation:(float) rotation {
    
    posX /= SCALE_FACTOR;
    posY /= SCALE_FACTOR;
    scaleX /= SCALE_FACTOR;
    scaleY /= SCALE_FACTOR;
    
    b2BodyDef groundBodyDef;
    groundBodyDef.type = b2_kinematicBody;
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
    
    posX /= SCALE_FACTOR;
    posY /= SCALE_FACTOR;
    radius /= SCALE_FACTOR;
    
    b2BodyDef ballBodyDef;
    ballBodyDef.type = b2_dynamicBody;
    ballBodyDef.position.Set(posX, posY);
    ballBodyDef.allowSleep = false;
    
    b2CircleShape circle;
    circle.m_radius = radius;
    
    b2FixtureDef ballShapeDef;
    ballShapeDef.shape = &circle;
    ballShapeDef.density = 1.0f;
    ballShapeDef.friction = 0.5f;
    ballShapeDef.restitution = 0.25f;
    
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
    transform.position.x = vec.x * SCALE_FACTOR;
    transform.position.y = vec.y * SCALE_FACTOR;
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

// sets a body's transform in the world
- (void)setBodyPosition:(NSString*)tag transform:(CTransform) transform {
    
    b2Body* body = (b2Body*)[[dict valueForKey:tag] pointerValue];
    
    b2Vec2 vec2 = b2Vec2(transform.position.x / SCALE_FACTOR, transform.position.y / SCALE_FACTOR);
    
    body->SetTransform(vec2, transform.rotation);
}

- (void)removeBody:(NSString*) tag {
    b2Body* body = (b2Body*)[[dict valueForKey:tag] pointerValue];
    world->DestroyBody(body);
    // remove object from the dictionary
    [dict removeObjectForKey:tag];
}

- (void)removeAllBodies{
    // remove all bodies from the dictionary
    [dict removeAllObjects];
}
@end
