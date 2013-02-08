//
//  LinkedLocation.h
//  Lesson1
//
//  Created by Rebecca Langer on 12-10-16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LinkedLocation : NSObject {
    @public
    float x;
    float y;
    LinkedLocation *next;
}

+ (id)linkedLocationWithX:(float)xVal andY: (float)yVal;
- (id)initWithX:(float)xVal andY: (float)yVal;
- (void)setNext:(LinkedLocation*)nextLocation;
- (void)releaseChain;

@end
