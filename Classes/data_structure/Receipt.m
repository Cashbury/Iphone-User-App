//
//  Receipt.m
//  Cashbury
//
//  Created by Mrithula Ancy on 6/13/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#import "Receipt.h"

@implementation Receipt
@synthesize tipPercentage, creditused, balanceCredit, savedAmt, billTotal, tipAmt, place;

-(void)dealloc{
    [tipPercentage release];
    [creditused release];
    [balanceCredit release];
    [savedAmt release];
    [billTotal release];
    [tipAmt release];
    [place release];
    [super dealloc];
}
@end
