//
//  CashierTxReceiptHistoryCell.m
//  Cashbery
//
//  Created by Rami Khawandi on 5/12/11.
//  Copyright (c) 2011 Cashbury. All rights reserved.
//

#import "CashierTxReceiptHistoryCell.h"

@implementation CashierTxReceiptHistoryCell

@synthesize date, name, amount, refundButton, icon;
@synthesize receipt;

- (void) setReceipt:(NSDictionary *)theReceipt
{
    self.icon.image = [UIImage imageNamed:@"icon-gained.png"];
    
    self.date.text = (NSString *) [theReceipt objectForKey:@"date_time"];
    self.name.text = (NSString *) [theReceipt objectForKey:@"customer_name"];
    self.amount.text = (NSString *) [theReceipt objectForKey:@"spend_money"];
}

- (void) dealloc
{
    [date release];
    [name release];
    [amount release];
    [refundButton release];
    [icon release];
    
    [receipt release];
    
    [super dealloc];
}

@end
