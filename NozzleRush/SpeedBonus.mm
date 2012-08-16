//
//  Heal.m
//  NozzleRush
//
//  Created by Mac on 6/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SpeedBonus.h"
#import "Common.h"

@implementation SpeedBonus

@synthesize timer;

- (id) initWithShape:(b2PolygonShape)sh X:(float)xx Y:(float)yy spawn:(int)sp {
    
    if(self = [super initWithShape:sh X:xx Y:yy spawn:sp]) {
        
        CGPoint ppp = [[Common instance] ort2iso:ccp(x,y)];
        //        tile = [[Common instance] tileCoordForPosition:ppp];
        
        sprite = [CCSprite spriteWithFile:@"Speed_Up_bonus.png"];
        sprite.position = ppp;
        [[Common instance].tileMap addChild:sprite z:0];
        
        NSLog(@"SpeedBonus created x=%f, y=%f", ppp.x, ppp.y);
        
    }
    return self;
}

- (void) hide: (Car*) car {
    
    
    NSLog(@"SpeedBonus hide");
    
    [self.timer invalidate];
    self.timer = nil;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:[[Common instance] getBonusParam:@"SpeedTime"] target:self selector:@selector(timerSel) userInfo:nil repeats:NO];
    
    sprite.visible = NO;
    ccar = car;
    ccar.speedKoeff = [[Common instance] getBonusParam:@"SpeedKoeff"];
}

- (void) timerSel {
    
    [self.timer invalidate];
    self.timer = nil;
//    [self show];
    
}

- (void) show {
    
    NSLog(@"Speed show");
    sprite.visible = YES;
    ccar.speedKoeff = 1;
}

-(void) dealloc {
    
    
    [super dealloc];
}
@end
