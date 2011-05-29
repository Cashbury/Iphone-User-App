//
//  UIView+Utils.m
//  Cashbury
//
//  Created by Rami on 22/5/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import "UIView+Utils.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (NAUtils)

- (void) roundCornersUsingRadius:(CGFloat)theRadius borderWidth:(CGFloat)theBorderWidth borderColor:(UIColor*)theBorderColor
{
    CALayer *_viewLayer = self.layer;
    
    _viewLayer.cornerRadius = theRadius;
    _viewLayer.masksToBounds = YES;
    
    if(theBorderWidth > 0.0)
    {
        _viewLayer.borderWidth = theBorderWidth;
        _viewLayer.borderColor = [theBorderColor CGColor];
    }
}

@end
