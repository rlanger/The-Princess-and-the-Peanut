//
//  Inventory.h
//  TestProject
//
//  Created by Rebecca Langer on 13-01-02.
//
//

#import "CCNode.h"
#import "FoodItem.h"

@interface Inventory : CCNode
{
@public
        NSMutableArray *foods;
}
+ (id) createInventory;
- (id) initInventory;
- (Boolean) isEmpty;
- (void) addItem: (FoodItem *) item;

@end
