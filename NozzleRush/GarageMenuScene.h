//
//  GarageMenuScene.h
//  NozzleRush
//
//  Created by вадим on 10/9/12.
//
//

#import "cocos2d.h"

@interface GarageMenuScene : CCLayer <UITextFieldDelegate> {
    
    CCScene *scene;
    
    CCSprite* sprite;
    NSArray* body;
    int bodyindex;
    int rwindex;
    int lwindex;
    int bwindex;
    CCLabelTTF* label_body;
    CCLabelTTF* label_rw;
    CCLabelTTF* label_lw;
    CCLabelTTF* label_bw;
    NSMutableDictionary* di;
    NSArray* rw;
    NSArray* lw;
    NSArray* bw;
    
}

+ (id) scene;

@end
