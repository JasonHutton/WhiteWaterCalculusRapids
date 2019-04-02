//
//  ContactListener.hpp
//  Comp8051
//
//  Created by Nathaniel on 2019-04-01.
//  Copyright © 2019 Paul. All rights reserved.
//

#ifndef ContactListener_hpp
#define ContactListener_hpp

#include "Physics.h"
#include "Box2D.h"

class ContactListener : public b2ContactListener {
    
public:
    ContactListener(Physics* physics);
    void BeginContact(b2Contact contact);
    void EndContact(b2Contact contact);
    void PreSolve(b2Contact contact, b2Manifold oldManifold);
    void PostSolve(b2Contact contact, b2ContactImpulse impulse);
private:
    Physics* physics;
};

#endif /* ContactListener_hpp */
