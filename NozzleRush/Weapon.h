//
//  Weapon.h
//  NozzleRush
//
//  Created by vadim on 9/11/12.
//
//

#import "cocos2d.h"
#import "Box2D.h"
#import "Car.h"

enum Weapon_Type { WT_STANDARD, WT_MYWEAPON };

@interface Weapon : CCNode {
    
    int typ;
    b2BodyDef bodyDef;
    CCSprite* sprite;
    CCParticleSystem *shot_effect;
    CCParticleSystem *hit_effect;
    double delay;
    double waytime;
    BOOL finite;
    Car* parent;
    
}

- (id) initWithX: (int) x  Y:(int) y Angle:(float) a Type:(int) type Sprite:(NSString*)spr File:(NSDictionary*)file Car:(Car*)car;
- (void) update;

@property (nonatomic) b2Body *body;
@property (nonatomic, retain) CCSprite* sprite;
@property (assign, readwrite) BOOL died;
@property (nonatomic, retain) NSTimer* timer;

@end
