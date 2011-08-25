//
//  KZCardPanelViewController.h
//  Cashbery
//
//  Created by Basayel Said on 8/25/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KZBusiness.h"
#import "KZReceiptHistoryDelegate.h"

@interface KZCardPanelViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, KZReceiptHistoryDelegate>  {
	KZBusiness* biz;
}

@property (nonatomic, retain) IBOutlet UILabel* lbl_title;
@property (nonatomic, retain) IBOutlet UILabel* lbl_balance;
@property (nonatomic, retain) IBOutlet UITableViewCell* cell_load_up;
@property (nonatomic, retain) IBOutlet UITableViewCell* cell_receipts;
@property (nonatomic, retain) IBOutlet UITableViewCell* cell_support;
@property (nonatomic, retain) IBOutlet UITableViewCell* cell_locations;


- (id) initWithBusiness:(KZBusiness*)_biz;

- (IBAction) goBack;
- (IBAction) goBackToPlaces;
- (IBAction) goBackToCards;
- (IBAction) showReceiptsHistory;

- (void) didTapSettingsButton:(id)theSender;


@end
