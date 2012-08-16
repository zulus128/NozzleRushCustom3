//
//  Heal.m
//  NozzleRush
//
//  Created by Mac on 6/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RemBonus.h"
#import "Common.h"

@implementation RemBonus

@synthesize timer;

- (id) initWithShape:(b2PolygonShape)sh X:(float)xx Y:(float)yy spawn:(int)sp {
    
    if(self = [super initWithShape:sh X:xx Y:yy spawn:sp]) {
        
        CGPoint ppp = [[Common instance] ort2iso:ccp(x,y)];
        //        tile = [[Common instance] tileCoordForPosition:ppp];
        
        sprite = [CCSprite spriteWithFile:@"Repair_bonus.png"];
        sprite.position = ppp;
        [[Common instance].tileMap addChild:sprite z:0];
        
        NSLog(@"RemBonus created x=%f, y=%f", ppp.x, ppp.y);
        
    }
    return self;
}

- (void) hide: (Car*) car {
    
    NSLog(@"RemBonus hide");
    
    [super hide:car];
    
    [self.timer invalidate];
    self.timer = nil;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerSel) userInfo:nil repeats:YES];
    sprite.visible = NO;
    ccar = car;
    cnt = 0;
}

- (void) timerSel {
    
    [ccar lifePlusFromRemBonus];
//    NSLog(@"Remont step %d", cnt);

    if(cnt++ > [[Common instance] getBonusParam:@"RemontTime"]) {

        [self.timer invalidate];
        self.timer = nil;
//        [self show];
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:SECONDS_TILL_BONUS target:self selector:@selector(die) userInfo:nil repeats:NO];
        
    }

}

- (void) die {
    
    NSLog(@"Remont die");
    [self.timer invalidate];
    self.timer = nil;
    self.forDelete = YES;
    
}

- (void) show {
    
    NSLog(@"Remont show");
    sprite.visible = YES;
    
}

-(void) dealloc {
    
    NSLog(@"Remont dealloc");
    
    [super dealloc];
}

@end
