//
//  LinkedLocation.m
//  Lesson1
//
//  Created by Rebecca Langer on 12-10-16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LinkedLocation.h"

@implementation LinkedLocation

+ (id)linkedLocationWithX:(float)xVal andY: (float)yVal
{
	return [[self alloc] initWithX:xVal andY:yVal];
}

- (id)initWithX:(float)xVal andY: (float)yVal
{
    if ((self = [super init]) ) {
        x = xVal;
        y = yVal;
    }
    return self;
}

- (void)setNext:(LinkedLocation*)nextLocation
{
    NSLog(@"Set Next");
    next = nextLocation;
}

- (void)releaseChain
{
    [next releaseChain];
}


@end
