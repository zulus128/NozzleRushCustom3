//
//  Weapon.h
//  NozzleRush
//
//  Created by vadim on 9/11/12.
//
//

#import "cocos2d.h"
#import "Box2D.h"

enum Weapon_Type { WT_STANDARD, WT_MYWEAPON };

@interface Weapon : CCNode {
    
    int typ;
    b2BodyDef bodyDef;
    CCSprite* sprite;
}

- (id) initWithX: (int) x  Y:(int) y Angle:(float) a Type:(int) type Sprite:(NSString*)spr;
- (void) update;

@property (nonatomic) b2Body *body;
@property (nonatomic, retain) CCSprite* sprite;
@property (assign, readwrite) BOOL died;

@end
