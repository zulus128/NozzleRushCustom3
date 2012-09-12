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
#import "Machinegun.h"

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
    CCSprite* sprites[MAX_SPRITES_CNT];
    CGPoint groundPosition;
    float hh;
    int hdir;
    CCParticleSystem *emitter;
//    CCParticleSystem* mach;
//    CCParticleSystem* rocketFlame;
    CCParticleExplosion* expl;
    float mach_angle;
    BOOL prev_mach;
    
    Rocket* rocket;
    Machinegun* machinegun;
    
    
    float rocket_angle;
    NSString* rocket_sprite;
    BOOL firsttime;
    CGPoint f;
    float bb;
    int speedcnt;
    int speed;
    int framecnt;
    int prevDistToChp;
    int stuck;
    
    NSString* direction1;
}

- (id) initWithType:(int) type;
- (void) update;
- (void) setPosX:(int)x Y:(int)y;
- (CGPoint) getGroundPosition;
- (void) lifeMinus;
- (void) lifePlusFromHeal;
- (void) lifePlusFromRemBonus;

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
@property (assign, readwrite) float life;
@property (assign, readwrite) float speedKoeff;
//@property (nonatomic, retain) CCSprite* sprite;

@end
