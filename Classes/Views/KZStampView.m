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
- (UIImageView *) stampImageAtIndex:(NSUInteger) theIndex;
@end

@implementation KZStampView

@synthesize numberOfStamps, numberOfCollectedStamps;

//------------------------------------
// Init & dealloc
//------------------------------------
#pragma mark -
#pragma mark Init & dealloc

- (id) initWithFrame:(CGRect)theFrame numberOfStamps:(NSUInteger)theStamps numberOfCollectedStamps:(NSUInteger)theCollectedStamps
{
    if (self = [super initWithFrame:theFrame])
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
// Public methods
//------------------------------------
#pragma mark -
#pragma mark Public methods

- (void) update
{
    for (int _i = 0; _i < numberOfStamps; _i++)
    {
        UIImageView *_stampImage = [self stampImageAtIndex:_i];
        
        if (_i == (numberOfStamps -1))
        {
            _stampImage.image = [UIImage imageNamed:@"stamp-star.png"];
        }
        else
        {
            _stampImage.image = (_i < numberOfCollectedStamps) ? [UIImage imageNamed:@"stamp-punched.png"] : [UIImage imageNamed:@"stamp-unpunched.png"];
        }

    }
}

- (void) setNumberOfCollectedStamps:(NSUInteger)theStamps
{
    numberOfCollectedStamps = theStamps;
    
    [self update];
}

//------------------------------------
// Private methods
//------------------------------------
#pragma mark -
#pragma mark Private methods

- (void) initStampImageViews;
{
    for (int _i = 0; _i < numberOfStamps; _i++)
    {
        CGFloat _x = (18 + 7) * _i;
        CGRect _frame = CGRectMake(_x, 0, 18, 18);
        
        UIImageView *_stamp = [[UIImageView alloc] initWithFrame:_frame];
        _stamp.tag = STAMP_TAG_OFFSET + _i;
        
        [self addSubview:_stamp];
        
        [_stamp release];
    }
}

- (UIImageView *) stampImageAtIndex:(NSUInteger) theIndex
{
    return (UIImageView *) [self viewWithTag:(STAMP_TAG_OFFSET + theIndex)];
}

@end
