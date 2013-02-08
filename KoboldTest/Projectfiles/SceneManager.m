//
//  SceneManager.m
//  KoboldTest
//
//  Created by Rebecca Langer on 13-01-31.
//
//

#import "SceneManager.h"

@implementation SceneManager



+ (void) goNavLayer {
    
    CCScene *scene = [CCScene node];
    [scene addChild:[NavLayer nodeWithGameLevel:1]];
    [[CCDirector sharedDirector] replaceScene:scene];
    
}

+ (void) goInventoryLayer {
    
    CCScene *scene = [CCScene node];
    [scene addChild:[InventoryLayer node]];
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
        [self goNavLayer];
    }
}


+(CCScene *) wrap: (CCLayer *) layer {
    CCScene *newScene = [CCScene node];
    [newScene addChild: layer];
    return newScene;
}

@end
