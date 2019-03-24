//
//  PhysicsWrapper.h
//  Comp8051
//
//  Created by Nathaniel on 2019-03-23.
//  Copyright © 2019 Paul. All rights reserved.
//

#ifndef PhysicsWrapper_h
#define PhysicsWrapper_h
#import <Foundation/Foundation.h>

@interface PhysicsWrapper : NSObject

@property PhysicsWrapper* instance;

+ (void)update:(float)deltaTime;

@end

#endif /* PhysicsWrapper_h */
