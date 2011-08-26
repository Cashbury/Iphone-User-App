//
//  KZCustomerReceiptHistoryViewController.h
//  Cashbery
//
//  Created by Basayel Said on 8/25/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KZBusiness.h"


@interface KZCustomerReceiptHistoryViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	NSArray* receipts;
	KZBusiness* biz;
}

@property (nonatomic, retain) IBOutlet UILabel* lbl_title;
@property (nonatomic, retain) IBOutlet UILabel* lbl_balance;

@property (nonatomic, retain) IBOutlet UILabel* lbl_money;
@property (nonatomic, retain) IBOutlet UILabel* lbl_date_time;
@property (nonatomic, retain) IBOutlet UILabel* lbl_place_name;
@property (nonatomic, retain) IBOutlet UILabel* lbl_R;

- (id) initWithCustomerRceipts:(NSArray*)_receipts andBusiness:(KZBusiness*)_biz;

- (IBAction) goBack;
- (IBAction) goBackToPlaces;
- (IBAction) goBackToCards;

- (void) didTapSettingsButton:(id)theSender;

@end
