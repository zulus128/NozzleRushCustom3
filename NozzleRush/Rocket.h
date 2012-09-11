//
//  Rocket.h
//  NozzleRush
//
//  Created by вадим on 6/24/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Weapon.h"

//enum Rocket_Type { RT_STANDARD, RT_MYROCKET };

@interface Rocket : Weapon {
    
}

- (id) initWithX: (int) x  Y:(int) y  Angle:(float) a Type:(int) type Direction:(NSString*)dir;

@end
