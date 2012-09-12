//
//  Rocket.mm
//  NozzleRush
//
//  Created by вадим on 6/24/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Rocket.h"
#import "Common.h"

@implementation Rocket

- (id) initWithX: (int) x  Y:(int) y  Angle:(float) a Type:(int) type Direction:(NSString*)dir {
   
    NSString* spr = [NSString stringWithFormat:@"spearthrower_bullet_%@.png", dir];
    
    if((self = [super initWithX:x Y:y Angle:a Type:type Sprite:spr File:[Common instance].w_spearthrower])) {
        
    }
    return self;
}

-(void) dealloc {

    NSLog(@"Rocket dealloc");
    
    [super dealloc];
}

- (void) update {

    [super update];
}

@end
