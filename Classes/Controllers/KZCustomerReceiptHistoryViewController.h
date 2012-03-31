//
//  KZCustomerReceiptHistoryViewController.h
//  Cashbery
//
//  Created by Basayel Said on 8/25/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBMagnifiableViewController.h"
#import "KZReceiptHistoryDelegate.h"
#import "KZBusiness.h"

@interface KZCustomerReceiptHistoryViewController : CBMagnifiableViewController <UITableViewDelegate, UITableViewDataSource, KZReceiptHistoryDelegate>
{
    @private
    NSArray *receipts;
}

@property (nonatomic, retain) KZBusiness *business;

@property (nonatomic, retain) IBOutlet UILabel* titleLabel;
@property (nonatomic, retain) IBOutlet UITableView *table;

@end
