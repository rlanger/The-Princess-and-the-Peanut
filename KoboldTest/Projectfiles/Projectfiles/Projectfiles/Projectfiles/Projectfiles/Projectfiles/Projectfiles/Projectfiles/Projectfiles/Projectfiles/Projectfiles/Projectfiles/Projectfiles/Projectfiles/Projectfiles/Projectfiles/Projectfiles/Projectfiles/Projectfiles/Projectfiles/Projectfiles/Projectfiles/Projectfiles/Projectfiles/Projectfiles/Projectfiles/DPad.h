#import "cocos2d.h"
#import "TouchableSprite.h"
#import "Helpers.h"

enum {
	DPAD_NO_DIRECTION,
	DPAD_UP,
	DPAD_UP_RIGHT,
	DPAD_RIGHT,
	DPAD_DOWN_RIGHT,
	DPAD_DOWN,
	DPAD_DOWN_LEFT,
	DPAD_LEFT,
	DPAD_UP_LEFT
};

@interface DPad : TouchableSprite {
@public
    CGPoint pressedVector;
    int direction;
}

@property (readwrite, assign) CGPoint pressedVector;
@property (readwrite, assign) int direction;

-(id)init;
-(void)dealloc;
-(void)processTouch:(CGPoint)point;
-(void)processRelease;

@end
