//
//  FoodItem.m
//  TestProject
//
//  Created by Rebecca Langer on 13-01-02.
//
//

#import "FoodItem.h"

@implementation FoodItem

// Each food item has a type (e.g. barcode)
// Types are defined in a constants file of some kind

+ (id)foodItemWithName:(NSString *)aName
{
	return [[self alloc] initWithName:aName];
}

- (id)initWithName:(NSString *)aName
{
	if ((self = [super init]) ) {
        
        name = aName;
        ingredients = aName;
        ID = 0; //not yet assigned to inventory
	}
    
	return self;
}

- (NSString *)getName
{
    return name;
}

- (int)getID
{
    return ID;
}

@end
