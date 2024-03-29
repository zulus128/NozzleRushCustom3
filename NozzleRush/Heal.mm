//
//  Heal.m
//  NozzleRush
//
//  Created by Mac on 6/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Heal.h"
#import "Common.h"

@implementation Heal

@synthesize timer;

- (id) initWithShape:(b2PolygonShape)sh X:(float)xx Y:(float)yy {
    
    if((self = [super init])) {				
        

        x = xx;
        y = yy;
        
        b2BodyDef bodyDef;
        bodyDef.position.Set(x/PTM_RATIO, y/PTM_RATIO);
        b2Body *bodyw = [Common instance].world->CreateBody(&bodyDef);
        
        b2FixtureDef fixtureDef;
        fixtureDef.shape = &sh;	
        fixtureDef.isSensor = true;
        bodyw->CreateFixture(&fixtureDef);
        
//        CCNode* o = [[CCNode alloc] init];
//        o.tag = HEAL_TAG;
//        bodyw->SetUserData(o);

        self.tag = HEAL_TAG;
        bodyw->SetUserData(self);
        
        CGPoint ppp = [[Common instance] ort2iso:ccp(x,y)];
//        tile = [[Common instance] tileCoordForPosition:ppp];

        sprite = [CCSprite spriteWithFile:@"heal.png"];
        sprite.position = ppp;
        [[Common instance].tileMap addChild:sprite z:0];

        NSLog(@"Heal created x=%f, y=%f", ppp.x, ppp.y);
        
    }
    return self;
}

- (void) hide: (Car*) car {
 

    NSLog(@"Heal hide");

    [self.timer invalidate];
    self.timer = nil;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(timerSel) userInfo:nil repeats:NO];

//    [[[Common instance].tileMap layerNamed:@"TrackObjectsLayer"] setTileGID:0 at:tile];
    sprite.visible = NO;

    [car lifePlusFromHeal];
}

- (void) timerSel {
    
    [self.timer invalidate];
    self.timer = nil;
    
    //    [[[Common instance].tileMap layerNamed:@"TrackObjectsLayer"] setTileGID:43/*36*/ at:ccp(51,74)]; 
    [self show];
    
}

- (void) show {
 
//    NSLog(@"Heal show");
//    [[[Common instance].tileMap layerNamed:@"TrackObjectsLayer"] setTileGID:43/*36*/ at:tile];
    sprite.visible = YES;

}

-(void) dealloc {
    
    
    [super dealloc];
}
@end
