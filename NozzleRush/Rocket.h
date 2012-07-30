//
//  Rocket.h
//  NozzleRush
//
//  Created by вадим on 6/24/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"

enum Rocket_Type { RT_STANDARD, RT_MYROCKET };

@interface Rocket : CCNode {
    
    int typ;
//    float32 angle;
    b2BodyDef bodyDef;
    CCSprite* sprite;
//    CCParticleSystem* expl;
}

- (id) initWithX: (int) x  Y:(int) y Angle:(float) a Type:(int) type;
- (void) update;

@property (nonatomic) b2Body *body;
@property (nonatomic, retain) CCSprite* sprite;

@end
