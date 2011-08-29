//
//  CBDropDownLabel.m
//  Cashbury
//
//  Created by Rami on 25/5/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import "CBDropDownLabel.h"


@implementation CBDropDownLabel

@synthesize indicatorImage;

//------------------------------------
// init & dealloc
//------------------------------------
#pragma mark - init & dealloc

- (void) dealloc
{
    [indicator release];
    [indicatorImage release];
    
    [super dealloc];
}

//------------------------------------
// UIView methods
//------------------------------------
#pragma mark - UIView methods


- (void) layoutSubviews
{
    CGSize _stringSize = [self.text sizeWithFont:self.font 
                            constrainedToSize:self.frame.size
                                lineBreakMode:self.lineBreakMode];
    
    CGSize _frameSize = self.frame.size;
    CGSize _imageSize = indicator.image.size;
    
    CGFloat _x = _frameSize.width / 2 + _stringSize.width / 2 + 10;
    CGFloat _y = _frameSize.height / 2 - _imageSize.height / 2 + 2;

    CGRect _frame = CGRectMake(_x, _y, _imageSize.width, _imageSize.height);
    
    indicator.frame = _frame;
}


//------------------------------------
// Overrides
//------------------------------------
#pragma mark - Overrides

- (void) setText:(NSString *)theText
{
    [super setText:theText];
    
    [self setNeedsLayout];
}

- (void) setIndicatorImage:(UIImage *)theImage
{
    if (theImage)
    {
        if (!indicator)
        {
            indicator = [[[UIImageView alloc] init] retain];
			
            [self addSubview:indicator];
        }
        
        indicator.image = theImage;
        
        [self setNeedsLayout];
    }
}

@end
