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
#import "KZApplication.h"
#import "PlaceView.h"

@interface KZCustomerReceiptHistoryViewController : CBMagnifiableViewController <UITableViewDelegate, UITableViewDataSource, KZURLRequestDelegate>
{
    NSMutableDictionary*receiptDict;
}

@property (nonatomic, retain) PlaceView *place;
@property (nonatomic, retain) IBOutlet UILabel* titleLabel;
@property (nonatomic, retain) IBOutlet UITableView *table;
- (IBAction)goBack:(id)sender;

@end
