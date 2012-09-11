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


- (id) initWithX: (int) x  Y:(int) y  Angle:(float) a Type:(int) type Sprite:(NSString*)spr {
   
    if((self = [super init])) {				
        
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
