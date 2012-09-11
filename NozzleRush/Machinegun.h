//
//  Rocket.h
//  NozzleRush
//
//  Created by вадим on 6/24/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"

enum Machinegun_Type { MT_STANDARD, MT_MYMACHINEGUN };

@interface Machinegun : CCNode {
    
    int typ;
}

- (id) initWithX: (int) x  Y:(int) y Angle:(float) a Type:(int) type Sprite:(NSString*)spr;
- (void) update;

@end
