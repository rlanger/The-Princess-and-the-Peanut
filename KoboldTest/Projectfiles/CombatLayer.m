//
//  NavLayer.m
//
//  Created by Rebecca Langer on 12-08-15.
//  Copyright University of Waterloo 2012. All rights reserved.
//

// Import the interfaces
#import "CombatLayer.h"

// Import supporting classes
#import "PlayerCharacter.h"

// Import Touch Dispatcher
#import "CCTouchDispatcher.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

// Import other scenes
#import "MainMenu.h"

//CCSprite *princess;
CCSprite *bg;

// Combat sub-modes


// NavLayer implementation
@implementation CombatLayer


// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	CombatLayer *layer = [CombatLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}


+(id)nodeWithGameLevel:(int)level{
    return  [[self alloc] initWithGameLevel:level];
}


-(id) initWithGameLevel:(int)level
{
    
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        
        
        
        
	}
	return self;
    
}


// on "init" you need to initialize your instance
-(id) init
{
	return [self initWithGameLevel:TAP_DESTINATION];
}

- (void)onEnter
{
    [super onEnter];
    
    // create and initialize a Label
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"onEnter" fontName:@"Marker Felt" fontSize:64];
    
    // ask director for the window size
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    // position the label on the center of the screen
    label.position =  ccp( size.width /2 , size.height-100 );
    
    // add the label as a child to this Layer
    [self addChild: label];
    
    // create main view
    
    CombatView *view = [CombatView newView: self];
    [self addChild:view];
    
    model = [CombatModel modelWithView:view];
    [self addChild:model];
    
    // set up menus
    //[self setUpMenus];
    
    self.isTouchEnabled = YES;

    
    /*
     * This method is called every time the CCNode enters the 'stage'.
     */
}


// set up the Menus
-(void) setUpMenus
{
        
}

/* Process touches */
-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"TOUCH");
    [self notifyModel: touches];
}

-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView: [touch view]];
	point = [[CCDirector sharedDirector] convertToGL: point];
    
}

-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView: [touch view]];
	point = [[CCDirector sharedDirector] convertToGL: point];
    
}

- (void) notifyModel: (NSSet *)touches {
    [model processTouches: touches];
}

@end
