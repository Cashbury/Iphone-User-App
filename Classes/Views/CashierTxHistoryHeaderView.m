//
//  CashierTxHistoryHeaderView.m
//  Cashbery
//
//  Created by Rami Khawandi on 5/12/11.
//  Copyright (c) 2011 Cashbury. All rights reserved.
//

#import "CashierTxHistoryHeaderView.h"

@implementation CashierTxHistoryHeaderView

@synthesize title, description;

- (void) dealloc
{
    [title release];
    [description release];
    
    [super dealloc];
}

@end
