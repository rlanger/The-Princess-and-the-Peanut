//
//  InventoryLayer.h
//  TestProject
//
//  Created by Rebecca Langer on 13-01-02.
//
//

#import <GameKit/GameKit.h>
#import "cocos2d.h"
#import "Inventory.h"
#import "FoodItem.h"
#import "NavLayer.h"

// ADD: import barcode reader APIs
#import "ZBarSDK.h"

@interface InventoryLayer : CCLayer
< ZBarReaderDelegate >
{
    Inventory *inventory;
    CCMenu *menu;
}

// returns a CCScene that contains the InventoryLayer as the only child
+(CCScene *) scene;


@end
