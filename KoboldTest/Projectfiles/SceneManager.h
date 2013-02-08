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

@interface SceneManager : NSObject

+ (void) goNavLayer;
+ (void) goInventoryLayer;
+ (void) goString: (NSString *)layerName;

@end
