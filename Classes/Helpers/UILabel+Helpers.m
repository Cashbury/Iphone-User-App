//
//  UILabel+Helper.m
//  Cashbery
//
//  Created by Basayel Said on 8/1/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import "UILabel+Helpers.h"


@implementation UILabel (Helpers)

- (void) setVariableLinesText:(NSString*)_txt {
	UIFont *myFont = self.font;
	CGSize size = [_txt sizeWithFont:myFont constrainedToSize:CGSizeMake(self.frame.size.width, MAXFLOAT)];
	size.width = self.frame.size.width;
	[self setLineBreakMode:UILineBreakModeWordWrap];
	[self setMinimumFontSize:self.font.pointSize];
	[self setNumberOfLines:0];
	CGRect frame = self.frame;
	frame.size = size;
	self.frame = frame;
	self.text = _txt;

}

@end
