
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "Car.h"
#import "Heal.h"

@interface DebugStruc : NSObject {
}
    
@property (readwrite) CGPoint debugPoint;
@property (nonatomic, readwrite) b2PolygonShape debugShape;

@end

@interface GameScene : CCLayer {
    
    CCTMXLayer *_background;
    CCTMXLayer *_background1;	
    GLESDebugDraw *m_debugDraw;		// strong ref
    BOOL debug;
    NSMutableArray* debugs;
    Heal* heal;
    int tr_cnt;
    int bon_cnt;
}

@property (nonatomic, retain) CCLayer *hudLayer;

+ (id) scene;
- (void) setViewpointCenter:(CGPoint) position;
- (b2PolygonShape) getShape:(id) object;

@end
