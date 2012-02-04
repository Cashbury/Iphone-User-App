//
//  CBPlacesViewTableCell.m
//  Cashbury
//
//  Created by Rami on 4/2/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#import "CBPlacesViewTableCell.h"

@implementation CBPlacesViewTableCell

@synthesize titleLabel, descriptionLabel, balanceLabel, placeImage;

//------------------------------------
// Init & dealloc
//------------------------------------
#pragma mark - Init & dealloc

- (id)initWithStyle:(UITableViewCellStyle)aStyle reuseIdentifier:(NSString *)theReuseIdentifier
{
    self = [super initWithStyle:aStyle reuseIdentifier:theReuseIdentifier];
    
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

- (void) dealloc
{
    [titleLabel release];
    [descriptionLabel release];
    [placeImage release];
    [balanceLabel release];
    
    [super dealloc];
}

//------------------------------------
// Overrides
//------------------------------------
#pragma mark - Overrides

- (void)setSelected:(BOOL)isSelected animated:(BOOL)isAnimated
{
    [super setSelected:isSelected animated:isAnimated];
}

@end
