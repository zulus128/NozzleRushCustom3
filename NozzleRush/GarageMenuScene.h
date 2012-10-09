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
    CCLabelTTF* label_body;
    
}

+ (id) scene;

@end
