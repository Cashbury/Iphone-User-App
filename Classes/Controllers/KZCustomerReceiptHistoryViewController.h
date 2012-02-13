//
//  KZCustomerReceiptHistoryViewController.h
//  Cashbery
//
//  Created by Basayel Said on 8/25/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBMagnifiableViewController.h"


@interface KZCustomerReceiptHistoryViewController : CBMagnifiableViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) IBOutlet UILabel* titleLabel;

@end
