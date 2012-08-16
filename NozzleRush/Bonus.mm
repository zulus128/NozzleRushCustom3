//
//  Bonus.m
//  NozzleRush
//
//  Created by vadim on 8/16/12.
//
//

#import "Bonus.h"

@implementation Bonus

- (id) initWithShape:(b2PolygonShape)sh X:(float)xx Y:(float)yy spawn:(int)sp {
    
    if((self = [super init])) {
        
        
        self.spawnPoint = sp;
        
        x = xx;
        y = yy;
        
        b2BodyDef bodyDef;
        bodyDef.position.Set(x/PTM_RATIO, y/PTM_RATIO);
        self.body = [Common instance].world->CreateBody(&bodyDef);
        
        b2FixtureDef fixtureDef;
        fixtureDef.shape = &sh;
        fixtureDef.isSensor = true;
        fixture = self.body->CreateFixture(&fixtureDef);
        
        self.tag = HEAL_TAG;
        self.body->SetUserData(self);
     
//        NSLog(@"Bonus created x=%f, y=%f", xx, yy);
    }
    return self;
}

- (void) preDie {

    self.body->DestroyFixture(fixture);
    self.predie = NO;
    
}

- (void) hide: (Car*) car {
    
    self.predie = YES;
}

- (void) show {
    
}

-(void) dealloc {
    
    NSLog(@"Bonus dealloc");
    
    [[Common instance].tileMap removeChild:sprite cleanup:YES];
    
    [super dealloc];
}

@end
