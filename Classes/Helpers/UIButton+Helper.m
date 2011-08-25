//
//  UIButton+Helper.m
//  Cashbery
//
//  Created by Basayel Said on 8/23/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import "UIButton+Helper.h"
#import "QuartzCore/QuartzCore.h"

@implementation UIButton (Helper)


- (void) setCustomStyle {
	[self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"CWR_pattern.png"]]];
	
	
	self.layer.borderColor = [UIColor lightGrayColor].CGColor;
	self.layer.borderWidth = 1.0;
	
	
	self.layer.cornerRadius = 5.0;
	
	self.layer.shadowColor = [UIColor redColor].CGColor;
	//self.layer.shadowOpacity = 1.0;
	self.layer.shadowRadius = 1.0;
	self.layer.shadowOffset = CGSizeMake(0.0, 1.0);
	self.layer.masksToBounds = YES;
}

@end
