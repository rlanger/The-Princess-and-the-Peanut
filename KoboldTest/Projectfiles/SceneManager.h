//
//  SceneManager.h
//  KoboldTest
//
//  Created by Rebecca Langer on 13-01-31.
//
//

#import <Foundation/Foundation.h>

#import "cocos2d.h"
#import "NavLayer.h"
#import "InventoryLayer.h"
#import "MenuLayer.h"
#import "CombatLayer.h"

@interface SceneManager : NSObject

+ (void) popLayer;
+ (void) goNavLayer;
+ (void) goCombatLayer;
+ (void) pushInventoryLayer;
+ (void) goInventoryLayer;
+ (void) goMenuLayer;
+ (void) goString: (NSString *)layerName;

@end
