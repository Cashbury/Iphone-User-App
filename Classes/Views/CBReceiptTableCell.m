//
//  CBReceiptTableCell.m
//  Cashbury
//
//  Created by ramikhawandi on 31/3/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#import "CBReceiptTableCell.h"

@implementation CBReceiptTableCell

@synthesize placeLabel, dateLabel, amountLabel;

- (void) dealloc
{
    [placeLabel release];
    [dateLabel release];
    [amountLabel release];
    
    [super dealloc];
}

@end
