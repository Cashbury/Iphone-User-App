//
//  KZStampView.m
//  Kazdoor
//
//  Created by Rami on 7/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "KZStampView.h"

#define STAMP_TAG_OFFSET 123

@interface KZStampView (PrivateMethods)
- (void) initStampImageViews;
- (UIImageView *) stampImageViewAtIndex:(NSUInteger) theIndex;
- (CGFloat) XForRow:(NSUInteger)theRow column:(NSUInteger)theColumn;
- (CGFloat) YForRow:(NSUInteger)theRow column:(NSUInteger)theColumn;
- (NSUInteger) tagForViewAtIndex:(NSUInteger)theIndex;
@end

@implementation KZStampView

@synthesize numberOfStamps, numberOfCollectedStamps, hasCompletedStamps;

//------------------------------------
// Init & dealloc
//------------------------------------
#pragma mark -
#pragma mark Init & dealloc

- (id) initWithFrame:(CGRect)theFrame numberOfStamps:(NSUInteger)theStamps numberOfCollectedStamps:(NSUInteger)theCollectedStamps
{
    self = [super initWithFrame:theFrame];
    if (self != nil)
    {
        numberOfStamps = theStamps;
        
        [self initStampImageViews];
        
        self.numberOfCollectedStamps = theCollectedStamps;
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

//------------------------------------
// Private methods
//------------------------------------
#pragma mark -
#pragma mark Private methods

- (void) layoutSubviews
{
    NSUInteger _viewTag = 0;
    
    for (int _i = 0; _i < numberOfStamps; _i++)
    {
        _viewTag = [self tagForViewAtIndex:_i];
        
        UIImageView *_view = [self stampImageViewAtIndex:_viewTag];
        
        NSString *_imageName = nil;
        
        if (numberOfStamps > 2 && _viewTag == (numberOfStamps - 1))
        {
            _imageName = (self.hasCompletedStamps) ? @"btn-crown-green.png" : @"btn-crown.png" ;
        }
        else
        {
            if (self.hasCompletedStamps)
            {
                _imageName = @"Stamp-green.png";
            }
            else
            {
                _imageName = (_viewTag < numberOfCollectedStamps) ? @"Stamp-y.png" : @"Stamp-gray.png";
            }
        }
        
        _view.image = [UIImage imageNamed:_imageName];
    }
}


//------------------------------------
// Public methods
//------------------------------------
#pragma mark -
#pragma mark Public methods

- (void) setNumberOfCollectedStamps:(NSUInteger)theStamps
{
    numberOfCollectedStamps = theStamps;
    
    [self setNeedsLayout];
}

- (BOOL) hasCompletedStamps
{
    return (numberOfCollectedStamps >= numberOfStamps);
}

//------------------------------------
// Private methods
//------------------------------------
#pragma mark -
#pragma mark Private methods

- (void) initStampImageViews;
{
    CGFloat _x = 0;
    CGFloat _y = 0;
    CGFloat _height = 0;
    
    CGFloat _imageWidth = 0;
    CGFloat _imageHeight = 0;
    
    CGRect _frame = CGRectZero;
    
    NSUInteger _row = 0;
    NSUInteger _rowIndex = 0;
    
    for (int _i = 0; _i < numberOfStamps; _i++)
    {
        // Determine the row
        _row = (_i / 5);
        _rowIndex = (_i % 5);
        
        _imageWidth = (_i == 2) ? 71 : 48;
        _imageHeight = (_i == 2) ? 71 : 48;
        
        _x = [self XForRow:_row column:_rowIndex];
        _y = [self YForRow:_row column:_rowIndex];
        
        _frame = CGRectMake(_x, _y, _imageWidth, _imageHeight);
        
        UIImageView *_stamp = [[UIImageView alloc] initWithFrame:_frame];
        _stamp.tag = STAMP_TAG_OFFSET + [self tagForViewAtIndex:_i];
        
        [self addSubview:_stamp];
        [_stamp release];
        
        if (_i == (numberOfStamps - 1))
        {
            _height = _y + _imageHeight;
        }
    }
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, _height);
}

- (CGFloat) XForRow:(NSUInteger)theRow column:(NSUInteger)theColumn
{
    CGFloat _x = 0;
    
    switch (theColumn)
    {
        case 0:
            _x = 22;
            break;
            
        case 1:
            _x = 73;
            break;
            
        case 2:
            _x = (theRow == 0) ? 125.5 : 138;
            break;
            
        case 3:
            _x = 203;
            break;
            
        case 4:
            _x = 255;
            break;
            
        default:
            break;
    }
    
    return _x;
}

 - (CGFloat) YForRow:(NSUInteger)theRow column:(NSUInteger)theColumn
{
    CGFloat _y = 0;
    
    switch (theRow)
    {
        case 0:
            _y = (theColumn == 2) ? 0 : 12.5;
            break;
            
        default:
            _y = 80 + (20 + 46) * (theRow - 1);
            break;
    }
    
    return _y;
}

- (NSUInteger) tagForViewAtIndex:(NSUInteger)theIndex
{
    if (numberOfStamps > 2)
    {
        if (theIndex == 2)
        {
            return numberOfStamps - 1;
        }
        else if (theIndex < 2)
        {
            return theIndex;
        }
        else
        {
            return theIndex - 1;
        }
    }
    else
    {
        return theIndex;
    }
}

- (UIImageView *) stampImageViewAtIndex:(NSUInteger) theIndex
{
    UIView *_view = [self viewWithTag:(STAMP_TAG_OFFSET + theIndex)];
    
    return (_view) ? (UIImageView *) _view : nil;
}

@end
