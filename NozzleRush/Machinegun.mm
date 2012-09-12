//
//  Machinegun.m
//  NozzleRush
//
//  Created by vadim on 9/11/12.
//
//

#import "Machinegun.h"
#import "Common.h"

@implementation Machinegun

- (id) initWithX: (int) x  Y:(int) y  Angle:(float) a Type:(int) type Direction:(NSString*)dir Car:(Car*)car {
    
    if((self = [super initWithX:x Y:y Angle:a Type:type Sprite:nil File:[Common instance].w_machinegun Car:car])) {
        
    }
    return self;
}

-(void) dealloc {
    
    NSLog(@"Machinegun dealloc");
    
    [super dealloc];
}

- (void) update {
    
    [super update];
}

@end
