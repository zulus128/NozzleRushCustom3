//
//  Heal.m
//  NozzleRush
//
//  Created by Mac on 6/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GunPowerBonus.h"
#import "Common.h"

@implementation GunPowerBonus

@synthesize timer;

- (id) initWithShape:(b2PolygonShape)sh X:(float)xx Y:(float)yy spawn:(int)sp {
    
    if(self = [super initWithShape:sh X:xx Y:yy spawn:sp]) {
        
        CGPoint ppp = [[Common instance] ort2iso:ccp(x,y)];
        //        tile = [[Common instance] tileCoordForPosition:ppp];
        
        sprite = [CCSprite spriteWithFile:@"Weapon_Up_bonus.png"];
        sprite.position = ppp;
        [[Common instance].tileMap addChild:sprite z:0];
        
        NSLog(@"GunPowerBonus created x=%f, y=%f", ppp.x, ppp.y);
        
    }
    return self;
}

- (void) hide: (Car*) car {
    
    NSLog(@"GunPowerBonus hide");
    
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
//    [self show];
    
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
