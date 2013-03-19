//
//  SceneManager.m
//  KoboldTest
//
//  Created by Rebecca Langer on 13-01-31.
//
//

#import "SceneManager.h"

@implementation SceneManager

+ (void) popLayer {
    [[CCDirector sharedDirector] popScene];
}

+ (void) goNavLayer {
    
    CCScene *scene = [CCScene node];
    [scene addChild:[NavLayer nodeWithGameLevel:1]];
    [[CCDirector sharedDirector] replaceScene:scene];
    
}

+ (void) goCombatLayer {
    
    CCScene *scene = [CCScene node];
    [scene addChild:[CombatLayer nodeWithGameLevel:1]];
    [[CCDirector sharedDirector] replaceScene:scene];

}

+ (void) pushInventoryLayer {
    CCScene *scene = [CCScene node];
    [scene addChild:[InventoryLayer node]];
    [[CCDirector sharedDirector] pushScene:scene];
}

+ (void) goInventoryLayer {
    
    CCScene *scene = [CCScene node];
    [scene addChild:[InventoryLayer node]];
    [[CCDirector sharedDirector] replaceScene:scene];
    
}

+ (void) goMenuLayer {
    
    CCScene *scene = [CCScene node];
    [scene addChild:[MenuLayer node]];
    [[CCDirector sharedDirector] replaceScene:scene];
    
}

+(void) go: (CCLayer *) layer {
    CCDirector *director = [CCDirector sharedDirector];
    CCScene *newScene = [SceneManager wrap:layer];
    if ([director runningScene]) {
        [director replaceScene:newScene];
    }
    else {
        [director runWithScene:newScene];
    }
}

+ (void) goString: (NSString *)layerName {    
    if ([layerName isEqualToString:@"Castle"]) {
        [self goCombatLayer];
    }
}


+(CCScene *) wrap: (CCLayer *) layer {
    CCScene *newScene = [CCScene node];
    [newScene addChild: layer];
    return newScene;
}

@end
