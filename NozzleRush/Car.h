//
//  Car.h
//  NozzleRush
//
//  Created by Abdul Jaleel Malik on 22/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "Box2D.h"
#import "Rocket.h"

#define hstep 7
#define hmax 60
#define MAX_SPRITES_CNT 13

#define DISKTAG 7001
#define WHEELTAG 7002

enum Car_type { CT_ME, CT_ENEMY };
enum disk_type { DT_NONE, DT_45, DT_45FLIP, DT_SIDE };

@interface Car : CCNode {
    
    float angle;

    b2BodyDef bodyDef;
    CCSprite* sprite;
//    CCSprite* sprite1;
//    CCSprite* sprite2;
//    CCSprite* sprite3;

    
    CCSprite* sprites[MAX_SPRITES_CNT];

//    CCSprite* testSprite;
//    CCSprite* spriteDisk1;
//    CCSprite* spriteDisk2;
    CGPoint groundPosition;
    float hh;
    int hdir;
    CCParticleSystem *emitter;
    CCParticleSystem* mach;
    CCParticleSystem* rocketFlame;
    
    CCParticleExplosion* expl;
    
    float mach_angle;
    BOOL prev_mach;
    
    Rocket* rocket;
    float rocket_angle;

//    id wheel45;
//    id wheel;
//    id wheel45Flip;
//    id wheelSide;
//    id diskiSide;
//    id diski45;
//    id diski45Flip;
    
    BOOL firsttime;

    CGPoint f;
    float bb;

    int speedcnt;
    int speed;
    int framecnt;
    int prevDistToChp;
    int stuck;
}

//- (id) initWithX: (int) x  Y:(int) y Type:(int) type;
- (id) initWithType:(int) type;
- (void) update;
- (void) setPosX:(int)x Y:(int)y;
- (CGPoint) getGroundPosition;

@property (nonatomic) b2Body *body;
@property (readwrite) b2Vec2 eye;
@property (readwrite) b2Vec2 target;
@property (readwrite) b2Vec2 target1;
@property (readwrite) b2Vec2 target2;
@property (readwrite) b2Vec2 target3;
@property (readwrite) b2Vec2 target4;

@property (readwrite) b2Vec2 targetChp;

@property (assign, readwrite) BOOL jump;
@property (assign, readwrite) BOOL oil;
@property (assign, readwrite) int typ;

@property (nonatomic, retain) NSString* diskname;
@property (nonatomic, retain) NSString* wheelname;

@property (assign, readwrite) int checkpoint;
@property (assign, readwrite) int distToChp;

//@property (assign, readwrite) BOOL heal;

@end
