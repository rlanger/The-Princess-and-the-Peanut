//
//  SceneView.m
//  Lesson1
//
//  Created by Rebecca Langer on 12-09-03.
//  Copyright (c) 2012 University of Waterloo. All rights reserved.
//

#import "SceneView.h"
#import "PlayerCharacter.h"
#import "cocos2d.h"

@implementation SceneView
// scene has PlayerParty, NPCs, etc
// update ViewNode

+ (SceneView *) newView: (MovementLayer *) aLayer
{
	return [[self alloc] initView: aLayer];
}

// on "init" you need to initialize your instance
-(SceneView *) initView: (MovementLayer *) aLayer
{
if( (self=[super init] )) {
    
    layer = aLayer;
    
    /*
    // Top Layer, a simple image
    CCSprite *cocosImage = [CCSprite spriteWithFile:@"Icon.png"];
    // scale the image (optional)
    cocosImage.scale = 2.5f;
    // change the transform anchor point to 0,0 (optional)
    cocosImage.anchorPoint = ccp(0,0);
    */
    
    // Middle Layer
    midLayer = [CCLayer new];
    // change the transform anchor point (optional)
    midLayer.anchorPoint = ccp(0,0);
    // Top Layer, a simple image
    
   /* ground = [CCSprite spriteWithFile:@"field.jpg"];
    // scale the image (optional)
    ground.scale = 0.7f;
    // change the transform anchor point to 0,0 (optional)
    ground.anchorPoint = ccp(0,0);
    ground.position = ccp(0,0);
    [midLayer addChild:ground]; */
    
    
    // Background layer: another image
    CCSprite *background = [CCSprite spriteWithFile:@"bkg_field.jpg"];
    // scale the image (optional)
    background.scale = 1.0f;
    // change the transform anchor point (optional)
    background.anchorPoint = ccp(0,0);
    
    // create a void node, a parent ParallaxNode
    CCParallaxNode *voidNode = [CCParallaxNode node];
    
    // NOW add the 3 layers to the 'void' node
    
    // background image is moved at a ratio of 0.4x, 0.5y
    [voidNode addChild:background z:-1 parallaxRatio:ccp(0.1f,0.1f) positionOffset:ccp(0, 0)];
    //positionOffset:CGPointZero
    
    // midLayer is moved at a ratio of 1.0, 1.0y
    [voidNode addChild:midLayer z:1 parallaxRatio:ccp(1.0f,1.0f) positionOffset:ccp(0,0)];
    
    // top image is moved at a ratio of 3.0x, 2.5y
    //[voidNode addChild:cocosImage z:2 parallaxRatio:ccp(2.0f,2.0f) positionOffset:ccp(200,500)];
    
    
    // ParallaxNode is added to view with tag kTagNode
    [self addChild:voidNode z:0 tag:kTagNode2];
    
    
    
    // DPAD STUFF
    //Initialize DPad
	dPad = [[DPad alloc] init];
	dPad.position = ccp(100,100);
    
    self.isTouchEnabled = YES;

}

return self;
}

- (void)onEnter
{
	/*CCDirector *director =  [CCDirector sharedDirector];
    
	[[director touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];*/
	[super onEnter];
        
}

- (void)onExit
{
	CCDirector *director = [CCDirector sharedDirector];
    
	[[director touchDispatcher] removeDelegate:self];
    
    [self removeAllChildrenWithCleanup:YES];

	[super onExit];
    
    //Remove self as touch delegate to sharedDispatcher?
}


- (CGRect)groundRect
{
	CGSize s = [ground contentSize];
	return CGRectMake(-s.width / 2, 0, s.width, s.height);
}

-(void) addChildToMid:(CCNode *)aNode
{
    [midLayer addChild:aNode];
}

-(int) getGroundWidth;
{
    return [self groundRect].size.width;
}


// Process touches (old)
/*
-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    PlayerCharacter pc = [model getTouchedPC: touch];
    if (pc != NULL){
        [pc isSelected];
 
        //if dragging-> get PC to store touch
 
    } else {
        //move selected PC towards touch
        [[model selectedPC] moveToTouch:touch];
 
        //or
        //[[model selectedPC] moveTowardsTouch:touch];
    
 
	return YES;
}
*/
/*
-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint groundAnchor = [ground convertToWorldSpace:CGPointZero];
    //NSLog(@"%f, %f", groundAnchor.x, groundAnchor.y);
    
    // Scrolls screen when background dragged
    CGPoint touchLocation = [touch locationInView: [touch view]];
    CGPoint prevLocation = [touch previousLocationInView: [touch view]];
    
    touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
    prevLocation = [[CCDirector sharedDirector] convertToGL: prevLocation];
    
    CGPoint diff = ccpSub(touchLocation,prevLocation);
    
    //NOTE: moving quickly foils this scheme :(
    if ((groundAnchor.x<=0 || diff.x<0) && (groundAnchor.y<=0 || diff.y<0)) {
        
        CCNode *node = [self getChildByTag:kTagNode];
        CGPoint currentPos = [node position];
        [node setPosition: ccpAdd(currentPos, diff)];
    }
    
}*/




/* Process touches */
-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //[layer notifyModel: touches];
}

-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {	
	UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView: [touch view]];
	point = [[CCDirector sharedDirector] convertToGL: point];
    
	[dPad ccTouchesMoved:touches withEvent:event];
}

-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {	
	UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView: [touch view]];
	point = [[CCDirector sharedDirector] convertToGL: point];
    
	[dPad ccTouchesEnded:touches withEvent:event];
}


@end
