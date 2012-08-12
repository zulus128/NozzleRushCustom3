//
//  Heal.h
//  NozzleRush
//
//  Created by Mac on 6/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "Box2D.h"
#import "Car.h"

@interface SlowEnemyBonus : CCNode {
    
    int x,y;
    CGPoint tile;
    CCSprite* sprite;
    Car* ccar;
}

- (id) initWithShape:(b2PolygonShape)sh X:(float)xx Y:(float)yy;

- (void) hide: (Car*) car;
- (void) show;

@property (nonatomic, retain) NSTimer* timer;

@end
