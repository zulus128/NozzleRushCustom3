//
//  HudLayer.h
//  NozzleRush
//
//  Created by Abdul Jaleel Malik on 28/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CCLayer.h"
#import "cocos2d.h"

@interface HudLayer : CCLayer {
    
    float trigbeginx, trigbeginy;
    BOOL flagbegin;
    CCSprite* joyfire;
    id move_ease_in;
    
    CCLabelTTF* score;
    
    CCLabelTTF* label2;
    CCLabelTTF* cd_label;
    
    float jWeaponX;
    float jWeaponY;
    float jPadCenterX;
    float jPadCenterY;
    float nitroBX;
    float nitroBY;
    float jTriggerRadius;
    float jFieldRadius;
    float pauseBX;
    float pauseBY;
    float musicMuteBX;
    float musicMuteBY;
    float soundsMuteBX;
    float soundsMuteBY;
    float healthBX;
    float healthBY;
    float healthBBX;
    float healthBBY;
    float mapBX;
    float mapBY;
    
    BOOL isPause;
    
    CCSprite* healthBar;
    float hl;
}

- (void) updateScore;
- (void) showGO;
- (void) hideGO;
- (void) showCD;

@end
