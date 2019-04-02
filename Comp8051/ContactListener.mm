//
//  ContactListener.cpp
//  Comp8051
//
//  Created by Nathaniel on 2019-04-01.
//  Copyright © 2019 Paul. All rights reserved.
//

#include "Physics.h"
#include "ContactListener.hpp"

ContactListener::ContactListener(Physics* physics) {
    
    this->physics = physics;
}

void ContactListener::BeginContact(b2Contact* contact) {
    
    NSString* tag1 = (__bridge NSString*)contact->GetFixtureA()->GetUserData();
    NSString* tag2 = (__bridge NSString*)contact->GetFixtureB()->GetUserData();
    [physics handleCollisionEnter:tag1 tag2:tag2];
}

void ContactListener::EndContact(b2Contact* contact) {
    
    NSString* tag1 = (__bridge NSString*)contact->GetFixtureA()->GetUserData();
    NSString* tag2 = (__bridge NSString*)contact->GetFixtureB()->GetUserData();
    [physics handleCollisionExit:tag1 tag2:tag2];
}
