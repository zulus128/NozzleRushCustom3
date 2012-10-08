//
//  GarageMenuScene.m
//  NozzleRush
//
//  Created by вадим on 10/9/12.
//
//

#import "GarageMenuScene.h"

@implementation GarageMenuScene

+(id) scene {
    
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GarageMenuScene* layer = [GarageMenuScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	return scene;
}

-(id) init {
    
    if((self = [super init])) {
        
        CCSprite* backgroundSprite = [CCSprite spriteWithFile:@"BACK2.png"];
        backgroundSprite.anchorPoint = ccp(0, 0);
        [self addChild:backgroundSprite];
        
        
        
    }
    return self;
}

@end
