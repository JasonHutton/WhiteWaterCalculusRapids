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

+ (void)start;
+ (void)update:(float)deltaTime;
+ (void)setGravityX:(float) x y:(float) y;
+ (void)addGroundBody:(NSString*) tag posX:(float) posX posY:(float) posY scaleX:(float) scaleX
               scaleY:(float) scaleY rotation:(float) rotation;
+ (void)addBallBody:(NSString*) tag posX:(float) posX posY:(float) posY radius:(float) radius;
+ (struct CTransform)getBodyTransform:(NSString*) tag;

@end

#endif /* PhysicsWrapper_h */
