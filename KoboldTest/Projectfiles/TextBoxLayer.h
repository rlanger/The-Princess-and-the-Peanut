//
//  TextBoxLayer.h
//  TextBoxLayerSample
//
//  Created by Fabio Rodella on 1/19/11.
//  Copyright 2011 University of Waterloo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "TextBox.h"

typedef struct _FontDefHashElement
{
    NSUInteger		key;		// key. Font Unicode value
    ccBMFontDef		fontDef;	// font definition
    UT_hash_handle	hh;
} tFontDefHashElement;

@interface TextBoxLayer : CCLayerColor <TextBox> {
	
	CCLabelBMFont *textLabel;
	
	NSString *text;
	NSMutableArray *lines;
	
	float progress;
	int linesPerPage;
	int currentPageIndex;
	NSMutableString *currentPage;
	int currentPageCharCount;
	
	int totalPages;
	
	__weak id<TextBoxDelegate> delegate;
	
	BOOL ended;
}

@property (readwrite,weak) id<TextBoxDelegate> delegate;

- (NSString *)nextPage;

- (int)calculateStringSize:(NSString *)txt;

@end
