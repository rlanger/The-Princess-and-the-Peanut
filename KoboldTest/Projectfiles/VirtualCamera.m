//
//  VirtualCamera.m
//  Lesson1
//
//  Created by Rebecca Langer on 12-09-13.
//  Copyright (c) 2012 University of Waterloo. All rights reserved.
//

#import "VirtualCamera.h"
#import "cocos2d.h"

enum {
	kTagNode,
};

@implementation VirtualCamera

// This class converts the model's location information into information the view can actually use. This includes working out parallax offset and zoom effects and figuring out when the camera is up against the edge of the scene.

-(id) init
{
if( (self=[super init] )) {
        
    // Top Layer, a simple image
    CCSprite *cocosImage = [CCSprite spriteWithFile:@"powered.png"];
    // scale the image (optional)
    cocosImage.scale = 2.5f;
    // change the transform anchor point to 0,0 (optional)
    cocosImage.anchorPoint = ccp(0,0);
    
    
    // Middle Layer
    CCLayer *midLayer = [CCLayer init];
    
    // background layer: another image
    CCSprite *background = [CCSprite spriteWithFile:@"background.png"];
    // scale the image (optional)
    background.scale = 1.5f;
    // change the transform anchor point (optional)
    background.anchorPoint = ccp(0,0);
    
    
    // create a void node, a parent node
    CCParallaxNode *voidNode = [CCParallaxNode node];
    
    // NOW add the 3 layers to the 'void' node
    
    // background image is moved at a ratio of 0.4x, 0.5y
    [voidNode addChild:background z:-1 parallaxRatio:ccp(0.4f,0.5f) positionOffset:CGPointZero];
    
    // tiles are moved at a ratio of 1.0, 1.0y
    [voidNode addChild:midLayer z:1 parallaxRatio:ccp(1.0f,1.0f) positionOffset:ccp(0,-200)];
    
    // top image is moved at a ratio of 3.0x, 2.5y
    [voidNode addChild:cocosImage z:2 parallaxRatio:ccp(3.0f,2.5f) positionOffset:ccp(200,1000)];
    [self addChild:voidNode z:0 tag:kTagNode];
}

return self;
}

-(void) registerWithTouchDispatcher
{
	CCDirector *director = [CCDirector sharedDirector];
	[[director touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	return YES;
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
}

-(void) ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint touchLocation = [touch locationInView: [touch view]];
	CGPoint prevLocation = [touch previousLocationInView: [touch view]];
    
	touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
	prevLocation = [[CCDirector sharedDirector] convertToGL: prevLocation];
    
	CGPoint diff = ccpSub(touchLocation,prevLocation);
    
	CCNode *node = [self getChildByTag:kTagNode];
	CGPoint currentPos = [self position];
	[node setPosition: ccpAdd(currentPos, diff)];
}

-(NSString *) title
{
	return @"Parallax: drag screen";
}

@end
