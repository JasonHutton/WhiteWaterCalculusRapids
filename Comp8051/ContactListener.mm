//
//  ContactListener.cpp
//  Comp8051
//
//  Created by Nathaniel on 2019-04-01.
//  Copyright © 2019 Paul. All rights reserved.
//

#include <objc/runtime.h>
#include "Physics.h"
#include "ContactListener.hpp"

ContactListener::ContactListener(Physics* physics) {
    
    this->physics = physics;
}

void ContactListener::BeginContact(b2Contact contact) {
    
    printf("AAAAAAA");
    [physics handleCollisionEnter:@"enter"];
}

void ContactListener::EndContact(b2Contact contact) {
    
    [physics handleCollisionExit:@"exit"];
}

void ContactListener::PreSolve(b2Contact contact, b2Manifold oldManifold) {
    // do nothing
}

void ContactListener::PostSolve(b2Contact contact, b2ContactImpulse impulse) {
    // do nothing
}
