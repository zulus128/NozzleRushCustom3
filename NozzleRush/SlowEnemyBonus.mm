//
//  Heal.m
//  NozzleRush
//
//  Created by Mac on 6/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SlowEnemyBonus.h"
#import "Common.h"

@implementation SlowEnemyBonus

@synthesize timer;

- (id) initWithShape:(b2PolygonShape)sh X:(float)xx Y:(float)yy spawn:(int)sp {
    
    if(self = [super initWithShape:sh X:xx Y:yy spawn:sp]) {

        CGPoint ppp = [[Common instance] ort2iso:ccp(x,y)];
        sprite = [CCSprite spriteWithFile:@"Slow_Aura_bonus.png"];
        sprite.position = ppp;
        [[Common instance].tileMap addChild:sprite z:0];
        NSLog(@"SlowEnemyBonus created x=%f, y=%f", ppp.x, ppp.y);
        
    }
    return self;
}

- (void) hide: (Car*) car {
    
    
    NSLog(@"SlowEnemyBonus hide");
    
    [self.timer invalidate];
    self.timer = nil;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:[[Common instance] getBonusParam:@"SlowEnemyTime"] target:self selector:@selector(timerSel) userInfo:nil repeats:NO];
    
    sprite.visible = NO;
    ccar = car;
}

- (void) timerSel {
    
    [self.timer invalidate];
    self.timer = nil;
//    [self show];
    
}

- (void) show {
    
    NSLog(@"SlowEnemy show");
    sprite.visible = YES;
}

-(void) dealloc {
    
    [super dealloc];
}

@end
