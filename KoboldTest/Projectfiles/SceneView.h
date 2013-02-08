//
//  SceneView.h
//  Lesson1
//
//  Created by Rebecca Langer on 12-09-03.
//  Copyright (c) 2012 University of Waterloo. All rights reserved.
//

#import "cocos2d.h"
#import "DPad.h"

@class MovementLayer;

enum {
	kTagNode2,
};

@interface SceneView : CCLayer <CCTargetedTouchDelegate>{
    @private
    CCLayer *midLayer;
    CCSprite *ground;
    MovementLayer *layer;
    @public
    DPad *dPad;

}
+ (SceneView *)newView: (MovementLayer *)aLayer;
-(void) addChildToMid:(CCNode *)aNode;
-(void) addChildToDialogue:(CCNode *)aNode;
-(int) getGroundWidth;
-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

@end
