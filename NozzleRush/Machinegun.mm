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

- (id) initWithX: (int) x  Y:(int) y  Angle:(float) a Type:(int) type Sprite:(NSString*)spr {
    
    if((self = [super init])) {
        
        typ = type;
        //        angle = a;
        self.tag = MACHINEGUN_TAG;
        
        
    }
    return self;
}

-(void) dealloc {
    
    NSLog(@"Machinegun dealloc");
    
    [super dealloc];
}

- (void) update {
    
}

@end
