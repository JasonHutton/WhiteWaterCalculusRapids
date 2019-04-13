//
//  ContactListener.hpp
//  Comp8051
//
//  Created by Nathaniel on 2019-04-01.
//  Copyright © 2019 Paul. All rights reserved.
//

#ifndef ContactListener_hpp
#define ContactListener_hpp

#import "Physics.h"
#import "Box2D.h"

class ContactListener : public b2ContactListener {
    
public:
    ContactListener(Physics* physics);
    void BeginContact(b2Contact* contact);
    void EndContact(b2Contact* contact);
private:
    Physics* physics;
};

#endif /* ContactListener_hpp */
