//
//  Inventory.m
//  TestProject
//
//  Created by Rebecca Langer on 13-01-02.
//
//

#import "Inventory.h"
#import "CWLSynthesizeSingleton.h"

@implementation Inventory

//CWL_SYNTHESIZE_SINGLETON_FOR_CLASS(Inventory);

// Inventory has FoodItems as children
// Also there's some type of InventoryLayer or InventoryScene to display this shiznit

+ (id) createInventory
{
	return [[self alloc] initInventory];
}

- (id) initInventory
{
	if ((self = [super init]) ) {
        
        foods = [[NSMutableArray alloc] initWithCapacity:10];
        
        FoodItem *food = [FoodItem foodItemWithName:@"Apple"];
        [foods addObject:food];

	}
    
	return self;
}

- (Boolean) isEmpty
{
    if (foods == NULL) {
        return true;
    }
    
    return false;
    
    
}

- (void) addItem: (FoodItem *) item
{
    [foods addObject:item];
}

@end
