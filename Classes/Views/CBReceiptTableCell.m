//
//  CBReceiptTableCell.m
//  Cashbury
//
//  Created by ramikhawandi on 31/3/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#import "CBReceiptTableCell.h"

@implementation CBReceiptTableCell

@synthesize imageView, placeLabel, dateLabel, amountLabel;

- (void) dealloc
{
    [imageView release];
    [placeLabel release];
    [dateLabel release];
    [amountLabel release];
    
    [super dealloc];
}

@end
