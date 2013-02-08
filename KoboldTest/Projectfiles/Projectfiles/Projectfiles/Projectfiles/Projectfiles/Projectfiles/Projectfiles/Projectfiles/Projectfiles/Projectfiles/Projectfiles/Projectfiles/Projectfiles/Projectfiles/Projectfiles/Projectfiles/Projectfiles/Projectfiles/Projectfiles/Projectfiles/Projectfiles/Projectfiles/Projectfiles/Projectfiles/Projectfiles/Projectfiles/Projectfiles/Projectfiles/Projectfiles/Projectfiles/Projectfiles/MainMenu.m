//
//  HelloWorldLayer.m
//  Lesson1
//
//  Created by Rebecca Langer on 12-08-15.
//  Copyright University of Waterloo 2012. All rights reserved.
//


// Import the interfaces
#import "MainMenu.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

// Importing other scenes
#import "NavLayer.h"
#import "MovementLayer.h"
#import "HelloWorldLayer.h"


CCSprite *bg;


// HelloWorldLayer implementation
@implementation MainMenu


// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MainMenu *layer = [MainMenu node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}


// set up the Menus
-(void) setUpMenus
{

    // Font Items
    [CCMenuItemFont setFontSize:30];
    [CCMenuItemFont setFontName: @"Marker Felt"];
    
    /*
    CCMenuItemFont *movement = [CCMenuItemFont itemWithString: @"Movement" block:^(id sender){
        CCScene *scene = [CCScene node];
        [scene addChild:[MovementLayer node]];
        [[CCDirector sharedDirector] replaceScene:scene];
    }];
        
    CCMenuItemFont *parallax = [CCMenuItemFont itemWithString: @"Parallax" block:^(id sender){
        CCScene *scene = [CCScene node];
        [scene addChild:[HelloWorldLayer node]];
        [[CCDirector sharedDirector] replaceScene:scene];
    }];

    CCMenuItemFont *dialogue = [CCMenuItemFont itemWithString: @"Dialogue" block:^(id sender){
        CCScene *scene = [CCScene node];
        [scene addChild:[HelloWorldLayer node]];
        [[CCDirector sharedDirector] replaceScene:scene];
    }];
    
    
    CCMenuItemFont *obstruction = [CCMenuItemFont itemWithString: @"Obstruction and Occlusion" block:^(id sender){
        CCScene *scene = [CCScene node];
        [scene addChild:[HelloWorldLayer node]];
        [[CCDirector sharedDirector] replaceScene:scene];
    }];
    
    CCMenuItemFont *animation = [CCMenuItemFont itemWithString: @"Animation" block:^(id sender){
        CCScene *scene = [CCScene node];
        [scene addChild:[HelloWorldLayer node]];
        [[CCDirector sharedDirector] replaceScene:scene];
    }];
    
    CCMenuItemFont *combat = [CCMenuItemFont itemWithString: @"Combat" block:^(id sender){
        CCScene *scene = [CCScene node];
        [scene addChild:[HelloWorldLayer node]];
        [[CCDirector sharedDirector] replaceScene:scene];
    }];
    
    CCMenuItemFont *scanning = [CCMenuItemFont itemWithString: @"Scanning" block:^(id sender){
        CCScene *scene = [CCScene node];
        [scene addChild:[HelloWorldLayer node]];
        [[CCDirector sharedDirector] replaceScene:scene];
    }];
    
    CCMenuItemFont *status = [CCMenuItemFont itemWithString: @"Status Menu" block:^(id sender){
        CCScene *scene = [CCScene node];
        [scene addChild:[HelloWorldLayer node]];
        [[CCDirector sharedDirector] replaceScene:scene];
    }];
    
    CCMenuItemFont *sharing = [CCMenuItemFont itemWithString: @"Shared Data" block:^(id sender){
        CCScene *scene = [CCScene node];
        [scene addChild:[HelloWorldLayer node]];
        [[CCDirector sharedDirector] replaceScene:scene];
    }];
    
    CCMenuItemFont *sample = [CCMenuItemFont itemWithString: @"Sample Scene" block:^(id sender){
        CCScene *scene = [CCScene node];
        [scene addChild:[HelloWorldLayer node]];
        [[CCDirector sharedDirector] replaceScene:scene];
    }];
    
    parallax.isEnabled = NO;
    dialogue.isEnabled = NO;
    obstruction.isEnabled = NO;
    animation.isEnabled = NO;
    combat.isEnabled = NO;
    scanning.isEnabled = NO;
    status.isEnabled = NO;
    sharing.isEnabled = NO;
    sample.isEnabled = NO;
    
    // Create a menu and add your menu items to it
    CCMenu * myMenu = [CCMenu menuWithItems: movement, parallax, dialogue, obstruction, animation, combat, scanning, status, sharing, sample, nil];
     */
    
    CCMenuItemFont *dragDestination = [CCMenuItemFont itemWithString: @"Drag Destination" block:^(id sender){
        
        int levelNumber = DRAG_DESTINATION_WAIT;
        
        CCScene *scene = [CCScene node];
        [scene addChild:[MovementLayer nodeWithGameLevel:levelNumber]];
        [[CCDirector sharedDirector] replaceScene:scene];
    }];
    
    CCMenuItemFont *dragDirection = [CCMenuItemFont itemWithString: @"Drag Direction" block:^(id sender){
        
        int levelNumber = DRAG_DIRECTION;
        
        CCScene *scene = [CCScene node];
        [scene addChild:[MovementLayer nodeWithGameLevel:levelNumber]];
        [[CCDirector sharedDirector] replaceScene:scene];
    }];
    
    CCMenuItemFont *tapDestination = [CCMenuItemFont itemWithString: @"Tap Destination" block:^(id sender){
        
        int levelNumber = TAP_DESTINATION;
        
        CCScene *scene = [CCScene node];
        [scene addChild:[MovementLayer nodeWithGameLevel:levelNumber]];
        [[CCDirector sharedDirector] replaceScene:scene];
    }];
    
    CCMenuItemFont *tapDirection = [CCMenuItemFont itemWithString: @"Tap Direction" block:^(id sender){
        
        int levelNumber = TAP_DIRECTION;
        
        CCScene *scene = [CCScene node];
        [scene addChild:[MovementLayer nodeWithGameLevel:levelNumber]];
        [[CCDirector sharedDirector] replaceScene:scene];
    }];
    
    CCMenuItemFont *movePad = [CCMenuItemFont itemWithString: @"D-Pad" block:^(id sender){
        
        int levelNumber = MOVE_PAD;
        
        CCScene *scene = [CCScene node];
        [scene addChild:[MovementLayer nodeWithGameLevel:levelNumber]];
        [[CCDirector sharedDirector] replaceScene:scene];
    }];
    
    
    
    
    // Create a menu and add your menu items to it
    CCMenu * myMenu = [CCMenu menuWithItems: dragDestination, dragDirection, tapDestination, tapDirection, movePad, nil];
    
    
    // Arrange the menu items vertically
    [myMenu alignItemsVertically];
    
    // add the menu to your scene
    [self addChild:myMenu];
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
		
		// create and initialize a Label
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Main Menu" fontName:@"Marker Felt" fontSize:64];
        
		// ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
        
		// position the label on the center of the screen
		label.position =  ccp( size.width /2 , size.height-100 );
		
		// add the label as a child to this Layer
		[self addChild: label];
		
		        
        // set up menus
        [self setUpMenus];
                
	}
	return self;
}


- (void) doSomethingOne: (CCMenuItem  *) menuItem 
{
	NSLog(@"The first menu was called");
}
- (void) doSomethingTwo: (CCMenuItem  *) menuItem 
{
	NSLog(@"The second menu was called");
}


@end
