//
//  MenuLayer.m
//  KoboldTest
//
//  Created by Rebecca Langer on 13-02-17.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "MenuLayer.h"
#import "SceneManager.h"

@implementation MenuLayer

#pragma mark - MenuLayer


// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MenuLayer *layer = [MenuLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
		
		// create and initialize a Label
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Menu" fontName:@"Marker Felt" fontSize:64];
        
		// ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
        
		// position the label on the center of the screen
		label.position =  ccp( size.width /2 , size.height/2+200 );
		
		// add the label as a child to this Layer
		[self addChild: label];
		
		
			
		// Default font size will be 28 points.
		[CCMenuItemFont setFontSize:28];
		
        CCMenuItemFont *profile_m = [CCMenuItemFont itemWithString: @"Profile" block:^(id sender){
            // DO A THING
        }];
        
        CCMenuItemFont *challenges_m = [CCMenuItemFont itemWithString: @"Challenges" block:^(id sender){
            // DO A THING
        }];
        
        CCMenuItemFont *allies_m = [CCMenuItemFont itemWithString: @"Allies" block:^(id sender){
            // DO A THING
        }];
        
        CCMenuItemFont *alerts_m = [CCMenuItemFont itemWithString: @"Alerts" block:^(id sender){
            // DO A THING
        }];
        
        CCMenuItemFont *settings_m = [CCMenuItemFont itemWithString: @"Settings" block:^(id sender){
            // DO A THING
        }];
        
        CCMenuItemFont *logout_m = [CCMenuItemFont itemWithString: @"Log Out" block:^(id sender){
            // DO A THING
        }];
        
        CCMenu *menu = [CCMenu menuWithItems:profile_m, challenges_m, allies_m, alerts_m, settings_m, logout_m, nil];
        
        // Add the menu to the layer
        [self addChild:menu];
        
                
		[menu alignItemsVerticallyWithPadding:20];
		[menu setPosition:ccp( size.width/2, size.height/2 - 50)];
        
        CCMenu *modeMenu = [CCMenu menuWithItems:nil];
        
        
        CCMenuItemFont *cancel = [CCMenuItemFont itemWithString: @"Cancel" block:^(id sender){
            //Return to Nav mode
            NSLog(@"CANCEL");
            
            [SceneManager goNavLayer];
            
            /*CCScene *scene = [CCScene node];
             [scene addChild:[NavLayer nodeWithGameLevel:1]];
             [[CCDirector sharedDirector] replaceScene:scene];*/
            
        }];
        [modeMenu addChild:cancel];
        
		[modeMenu alignItemsHorizontallyWithPadding:20];
		[modeMenu setPosition:ccp( size.width/2, 100)];
        
        [self addChild:modeMenu];

        
	}
	return self;
}

@end