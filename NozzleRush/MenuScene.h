
#import "cocos2d.h"

@interface MenuScene : CCLayer {
    
    CCScene *scene;
    CCLabelTTF* label3;
    CCLabelTTF* label4;
    CCLabelTTF* label5;
}

+ (id) scene;

- (void) race:(id) sender;
- (void) ride:(id) sender;
- (void) mapChanger:(id) sender;

@end
