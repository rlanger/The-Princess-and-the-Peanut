//
//  FoodItem.h
//  TestProject
//
//  Created by Rebecca Langer on 13-01-02.
//
//

#import "CCNode.h"

@interface FoodItem : CCNode
{
    NSString *name;
    NSString *ingredients; //make this a proper struct later
    int ID;
}
 
+ (id) foodItemWithName:(NSString *)aName;
- (id) initWithName:(NSString *)aName;
- (NSString *)getName;
- (int)getID;

@end
