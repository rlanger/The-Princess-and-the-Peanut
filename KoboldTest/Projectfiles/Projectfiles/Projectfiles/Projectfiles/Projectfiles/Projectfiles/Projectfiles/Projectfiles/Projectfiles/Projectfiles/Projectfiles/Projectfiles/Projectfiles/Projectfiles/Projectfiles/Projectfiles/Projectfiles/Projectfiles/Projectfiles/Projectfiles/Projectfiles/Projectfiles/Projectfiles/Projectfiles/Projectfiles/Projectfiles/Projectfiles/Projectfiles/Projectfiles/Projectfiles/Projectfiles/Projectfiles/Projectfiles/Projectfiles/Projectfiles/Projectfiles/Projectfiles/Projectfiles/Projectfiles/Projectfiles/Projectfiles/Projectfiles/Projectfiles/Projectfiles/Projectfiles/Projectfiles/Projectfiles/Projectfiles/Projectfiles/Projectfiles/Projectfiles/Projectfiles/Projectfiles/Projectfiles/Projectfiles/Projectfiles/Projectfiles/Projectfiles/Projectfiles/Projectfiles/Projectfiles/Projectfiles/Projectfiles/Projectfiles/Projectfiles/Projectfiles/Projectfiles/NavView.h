//
//  NavView.h
//  TestProject
//
//  Created by Rebecca Langer on 13-01-02.
//
//

#import "cocos2d.h"
#import "PlayerCharacter.h"


@class NavLayer;
@class InventoryLayer;

enum {
	kTagNode,
};

@interface NavView : CCLayer
<CCTargetedTouchDelegate>
{
@private
    CCLayer *midLayer;
    CCSprite *ground;
    NavLayer *layer;
    
}
+ (NavView *)newView: (NavLayer *)aLayer;
-(void) addChildToMid:(CCNode *)aNode;
-(int) getGroundWidth;
-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

@end
