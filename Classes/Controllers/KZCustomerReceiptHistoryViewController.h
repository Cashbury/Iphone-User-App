//
//  KZCustomerReceiptHistoryViewController.h
//  Cashbery
//
//  Created by Basayel Said on 8/25/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface KZCustomerReceiptHistoryViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	NSArray* receipts;
}

@property (nonatomic, retain) IBOutlet UILabel* lbl_title;
@property (nonatomic, retain) IBOutlet UILabel* lbl_balance;

- (id) initWithCustomerRceipts:(NSArray*)_receipts;

- (IBAction) goBack;
- (IBAction) goBackToPlaces;
- (IBAction) goBackToCards;

- (void) didTapSettingsButton:(id)theSender;

@end
