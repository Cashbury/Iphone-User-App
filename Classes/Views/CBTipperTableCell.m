//
//  CBTipperTableCell.m
//  Cashbury
//
//  Created by Rami on 27/2/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#import "CBTipperTableCell.h"

@implementation CBTipperTableCell

@synthesize tipLabel;

//------------------------------------
// Init & dealloc
//------------------------------------
#pragma mark - Init & dealloc

- (id) initWithStyle:(UITableViewCellStyle)theStyle reuseIdentifier:(NSString *)theReuseIdentifier
{
    self = [super initWithStyle:theStyle reuseIdentifier:theReuseIdentifier];
    
    if (self)
    {
        self.tipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.tipLabel.font = [UIFont boldSystemFontOfSize:25];
        self.tipLabel.textColor = [UIColor whiteColor];
        self.tipLabel.highlightedTextColor = [UIColor yellowColor];
        self.tipLabel.textAlignment = UITextAlignmentCenter;
        self.tipLabel.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.tipLabel];
    }
    
    return self;
}

- (void) dealloc
{
    [tipLabel release];
    
    [super dealloc];
}

//------------------------------------
// Overrides
//------------------------------------
#pragma mark - Overrides

- (void)setSelected:(BOOL)isSelected animated:(BOOL)isAnimated
{
	[super setSelected:isSelected animated:isAnimated];
    
	self.tipLabel.highlighted = isSelected;
}

- (void) drawRect:(CGRect)theRect
{
    CGFloat _darkGray[4] = {0.176, 0.176, 0.176, 1};
    CGFloat _lightGray[4] = {0.29, 0.29, 0.29, 1};
    
    CGContextRef c = UIGraphicsGetCurrentContext();    
    CGContextBeginPath(c);
    
    CGContextSetStrokeColor(c, _lightGray);
    CGContextMoveToPoint(c, 0, self.frame.size.height);
    CGContextAddLineToPoint(c, self.frame.size.width, self.frame.size.height);
    CGContextStrokePath(c);
    
    CGContextSetStrokeColor(c, _darkGray);
    CGContextMoveToPoint(c, 0, 0);
    CGContextAddLineToPoint(c, self.frame.size.width, 0);
    CGContextStrokePath(c);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect contentRect = self.contentView.bounds;
        
    self.tipLabel.frame = contentRect;
}

@end
