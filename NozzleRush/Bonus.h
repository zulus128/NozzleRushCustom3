//
//  Bonus.h
//  NozzleRush
//
//  Created by vadim on 8/16/12.
//
//

#import "CCNode.h"
#import "cocos2d.h"
#import "Box2D.h"
#import "Car.h"
#import "Common.h"

@interface Bonus : CCNode {
    
    int x,y;
    CGPoint tile;
    CCSprite* sprite;
    Car* ccar;
    b2Fixture* fixture;
}

- (id) initWithShape:(b2PolygonShape)sh X:(float)xx Y:(float)yy spawn:(int)sp;

- (void) hide: (Car*) car;
- (void) show;
- (void) preDie;

@property (nonatomic, retain) NSTimer* timer;
@property (readwrite) BOOL forDelete;
@property (readwrite) BOOL predie;
@property (readwrite) int spawnPoint;
@property (nonatomic) b2Body *body;

@end
