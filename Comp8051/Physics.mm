//
//  Physics.m
//  Comp8051
//
//  Created by Nathaniel on 2019-03-23.
//  Copyright © 2019 Paul. All rights reserved.
//

#import "CTransform.h"
#import "Box2D/Box2D.h"
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
    }
    return self;
}

- (void)update:(float)deltaTime {
    
    world->Step(deltaTime, 6, 2);
}

- (void)setGravityX:(float) x y:(float)y {
    
    b2Vec2 gravity(x * GRAV_CONSTANT, y * GRAV_CONSTANT);
    world->SetGravity(b2Vec2(x, y));
}

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
    
    // add ground body to the dictionary
    [dict setObject:[NSValue valueWithPointer:groundBody] forKey:tag];
}

- (void)addBallBody:(NSString*) tag posX:(float) posX posY:(float) posY radius:(float) radius {
    
    b2BodyDef ballBodyDef;
    ballBodyDef.type = b2_dynamicBody;
    ballBodyDef.position.Set(posX, posY);
    
    b2CircleShape circle;
    circle.m_radius = radius;
    
    b2FixtureDef ballShapeDef;
    ballShapeDef.shape = &circle;
    ballShapeDef.density = 1.0f;
    ballShapeDef.friction = 0.2f;
    ballShapeDef.restitution = 0.5f;
    
    b2Body* ballBody = world->CreateBody(&ballBodyDef);
    ballBody->CreateFixture(&ballShapeDef);
    
    [dict setObject:[NSValue valueWithPointer:ballBody] forKey:tag];
}

- (CTransform)getBodyTransform:(NSString*) tag {
    
    b2Body* body = (b2Body*)[[dict valueForKey:tag] pointerValue];
    
    b2Vec2 vec = body->GetPosition();
    
    CTransform transform;
    transform.position.x = vec.x;
    transform.position.y = vec.y;
    transform.rotation = body->GetAngle();
    
    return transform;
}

@end
