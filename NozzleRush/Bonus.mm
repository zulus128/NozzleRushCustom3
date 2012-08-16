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
        b2Body *bodyw = [Common instance].world->CreateBody(&bodyDef);
        
        b2FixtureDef fixtureDef;
        fixtureDef.shape = &sh;
        fixtureDef.isSensor = true;
        bodyw->CreateFixture(&fixtureDef);
        
        self.tag = HEAL_TAG;
        bodyw->SetUserData(self);
     
        NSLog(@"Bonus created");
    }
    return self;
}

- (void) hide: (Car*) car {
    
}

- (void) show {
    
}

-(void) dealloc {
    
    NSLog(@"Bonus dealloc");
    
    [[Common instance].tileMap removeChild:sprite cleanup:YES];
    
    [super dealloc];
}

@end
