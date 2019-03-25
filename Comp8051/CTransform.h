//
//  CTransform.h
//  Comp8051
//
//  Created by Nathaniel on 2019-03-24.
//  Copyright © 2019 Paul. All rights reserved.
//

#ifndef CTransform_h
#define CTransform_h

struct CVector {
    float x, y, z;
};
typedef struct CVector CVector;

struct CTransform {
    CVector position;
    float rotation;
};
typedef struct CTransform CTransform;

#endif /* CTransform_h */
