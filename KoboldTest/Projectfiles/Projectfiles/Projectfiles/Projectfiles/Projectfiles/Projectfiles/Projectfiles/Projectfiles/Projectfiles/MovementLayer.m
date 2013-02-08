//
//  MovementLayer.m
//  Lesson1
//
//  Created by Rebecca Langer on 12-08-15.
//  Copyright University of Waterloo 2012. All rights reserved.
//

// Import the interfaces
#import "MovementLayer.h"

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

const int COMBAT = 0;
const int EXPLORATION = 1;

// Combat sub-modes


// MovementLayer implementation
@implementation MovementLayer


// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MovementLayer *layer = [MovementLayer node];
	
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
        
        NSLog(@"Level = %d", level);
        
        
		// create and initialize a Label
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Movement Test" fontName:@"Marker Felt" fontSize:64];
        
		// ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
        
		// position the label on the center of the screen
		label.position =  ccp( size.width /2 , size.height-100 );
		
		// add the label as a child to this Layer
		[self addChild: label];
		
        // create main view
        
        SceneView *view = [SceneView newView: self];
        [self addChild:view]; 
        
        model = [SceneModel modelWithView:view];
        [model setCombatSubmode:level];
        [self addChild:model];
        
        // set up menus
        //[self setUpMenus];
        
        //self.isTouchEnabled = YES;
        //[self schedule:@selector(doStep:)];
        
        
	}
	return self;

}


// on "init" you need to initialize your instance
-(id) init
{
	return [self initWithGameLevel:TAP_DESTINATION];
}


// set up the Menus
-(void) setUpMenus
{
    
    // Font Items
    [CCMenuItemFont setFontSize:30];
    [CCMenuItemFont setFontName: @"Marker Felt"];
    
    // Combat vs. Exploration
    CCMenuItemFont *combat_mi = [CCMenuItemFont itemWithString: @"Combat" block:^(id sender){
        NSLog(@"A menu item was selected");
        model->mode = COMBAT;
    }];
    
    CCMenuItemFont *exploration_mi = [CCMenuItemFont itemWithString: @"Exploration" block:^(id sender){
        NSLog(@"A menu item was selected");
        model->mode = EXPLORATION;
    }];
    
    CCMenuItemFont *main_menu_mi = [CCMenuItemFont itemWithString: @"Main Menu" block:^(id sender){
        CCScene *scene = [CCScene node];
        [scene addChild:[MainMenu node]];
        [[CCDirector sharedDirector] replaceScene:scene];
    }];
    
    
    // Combat Sub-Modes
    CCMenuItemFont *drag_destination_wait = [CCMenuItemFont itemWithString: @"Drag Destination" block:^(id sender){
        NSLog(@"A menu item was selected");
        [model setCombatSubmode: DRAG_DESTINATION_WAIT];
    }];
    
    CCMenuItemFont *drag_path_wait = [CCMenuItemFont itemWithString: @"Drag Path" block:^(id sender){
        NSLog(@"A menu item was selected");
        [model setCombatSubmode: DRAG_PATH_WAIT];
    }];
    
    CCMenuItemFont *drag_direction = [CCMenuItemFont itemWithString: @"Drag Direction" block:^(id sender){
        NSLog(@"A menu item was selected");
        [model setCombatSubmode: DRAG_DIRECTION];
    }];
    
    CCMenuItemFont *drag_path_nowait = [CCMenuItemFont itemWithString: @"Drag Path (Immediate)" block:^(id sender){
        NSLog(@"A menu item was selected");
        [model setCombatSubmode: DRAG_PATH_NOWAIT];
    }];
    
    CCMenuItemFont *tap_destination = [CCMenuItemFont itemWithString: @"Tap Destination" block:^(id sender){
        NSLog(@"A menu item was selected");
        [model setCombatSubmode: TAP_DESTINATION];
    }];
    
    CCMenuItemFont *tap_direction = [CCMenuItemFont itemWithString: @"Tap Direction" block:^(id sender){
        NSLog(@"A menu item was selected");
        [model setCombatSubmode: TAP_DIRECTION];
    }];
    
    CCMenuItemFont *move_pad = [CCMenuItemFont itemWithString: @"Move Pad" block:^(id sender){
        NSLog(@"A menu item was selected");
        [model setCombatSubmode: MOVE_PAD];
    }];
    
    
    //FLOCKING BEHAVIOUR
    CCMenuItemFont *stay_left = [CCMenuItemFont itemWithString: @"Stay Left" block:^(id sender){
        NSLog(@"A menu item was selected");
        [model setFlockingBehaviour: STAY_LEFT];
    }];
    
    CCMenuItemFont *follow_exactly = [CCMenuItemFont itemWithString: @"Follow Exactly" block:^(id sender){
        NSLog(@"A menu item was selected");
        [model setFlockingBehaviour: FOLLOW_EXACTLY];
    }];
    
    CCMenuItemFont *boids = [CCMenuItemFont itemWithString: @"Boids" block:^(id sender){
        NSLog(@"A menu item was selected");
        [model setFlockingBehaviour: BOIDS];
    }];
    
    
    
    // MAIN MENU
    // Create a menu and add your menu items to it
    CCMenu * myMenu = [CCMenu menuWithItems: combat_mi, exploration_mi, main_menu_mi, nil];
    
    // Arrange the menu items vertically
    [myMenu alignItemsVertically];
    
    // ask director for the window size
    CGSize screenSz = [[CCDirector sharedDirector] winSize];
    CGSize itemSz = [main_menu_mi contentSize];
    
    //myMenu.isRelativeAnchorPoint = YES;
    //myMenu.anchorPoint = cpp (0,0);
    
    //HIDEOUS HACK
    myMenu.position = ccp (screenSz.width-20-(itemSz.width/2),screenSz.height-10-((itemSz.height+2)*4)/2);
    
    // add the menu to your scene
    [self addChild:myMenu];
    
    
    //COMBAT SUBMODES
    // Create a menu and add your menu items to it
    CCMenu * combatMenu = [CCMenu menuWithItems: drag_destination_wait, drag_direction, tap_destination, tap_direction, move_pad, nil];
    //NTS STILL NEED TO ADD: Drag Path no wait, Tap Direction, Joystick, Joystick Anywhere, Joystick on Target Character
    
    
    // Arrange the menu items vertically
    [combatMenu alignItemsVertically];
    
    combatMenu.position = ccp (210, screenSz.height-10-((itemSz.height+2)*6)/2);
    
    // add the menu to your scene
    [self addChild:combatMenu];
    
    
    
    
    //FLOCKING BEHAVIOUR
    // Create a menu and add your menu items to it
    CCMenu * flockingMenu = [CCMenu menuWithItems: stay_left, follow_exactly, boids, nil];
    
    // Arrange the menu items vertically
    [flockingMenu alignItemsVertically];
    
    flockingMenu.position = ccp (screenSz.width/2, screenSz.height-10-((itemSz.height+2)*4)/2);
    
    // add the menu to your scene
    [self addChild:flockingMenu];
    
    
    
}

- (void) notifyModel: (NSSet *)touches {
    [model processTouches: touches];
}

@end
