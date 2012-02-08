//
//  UIImage+Utils.m
//  Cashbury
//
//  Created by Rami Khawandi on 4/11/11.
//  Copyright (c) 2011 __MyCompanyName__ Ltd. All rights reserved.
//

#import "UIImage+Utils.h"

@implementation UIImage (Utils)

- (UIImage *) imageByScalingProportionallyToFillSize:(CGSize)theSize upscale:(BOOL)shouldUpscale
{
    UIImage *_sourceImage = self;
    UIImage *_newImage = nil;
    
    CGSize _imageSize = _sourceImage.size;
    CGFloat _width = _imageSize.width;
    CGFloat _height = _imageSize.height;
    
    CGFloat _targetWidth = theSize.width;
    CGFloat _targetHeight = theSize.height;
    
    CGPoint _newOrigin = CGPointMake(0, 0);
    
    // Return the source image if upscaling is not needed
    if (shouldUpscale == NO && (_targetWidth >= _width || _targetHeight >= _height))
    {
        return _sourceImage;
    }
    
    CGFloat _scaleFactor = 0.0;
    CGFloat _scaledWidth = _targetWidth;
    CGFloat _scaledHeight = _targetHeight;
    
    if (CGSizeEqualToSize(_imageSize, theSize) == NO)
    {
        CGFloat _widthFactor = _targetWidth / _width;
        CGFloat _heightFactor = _targetHeight / _height;
        
        // Use the larger factor in order to fill
        _scaleFactor = MAX(_widthFactor, _heightFactor);
        
        _scaledWidth  = _width * _scaleFactor;
        _scaledHeight = _height * _scaleFactor;
        
        if (_widthFactor < _heightFactor)
        {
            _newOrigin.x = (_targetWidth - _scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(theSize);
    
    CGRect _rect = CGRectZero;
    _rect.origin = _newOrigin;
    _rect.size.width  = _scaledWidth;
    _rect.size.height = _scaledHeight;
    
    [_sourceImage drawInRect:_rect];
    
    _newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return _newImage ;
}

@end
