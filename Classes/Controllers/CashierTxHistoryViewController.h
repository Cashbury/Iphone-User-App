//
//  CashierTxHistoryViewController.h
//  Cashbery
//
//  Created by Basayel Said on 8/21/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CashierTxHistoryHeaderView.h"

@interface CashierTxHistoryViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	NSMutableArray* days_array;
	BOOL is_menu_open;
}

@property (nonatomic, retain) IBOutlet UILabel* lbl_title;
@property (nonatomic, retain) IBOutlet UIView* view_menu;
@property (nonatomic, retain) IBOutlet UIView* view_cover;
@property (nonatomic, retain) IBOutlet UIImageView* img_menu_arrow;

@property (nonatomic, retain) IBOutlet UIButton* btn_ring_up;
@property (nonatomic, retain) IBOutlet UIButton* btn_receipts;
@property (nonatomic, retain) IBOutlet UIButton* btn_load_up;

- (IBAction) openCloseMenu;
- (IBAction) goBackToSettings:(id)sender;
- (IBAction) showTransactionHistory;
- (IBAction) showRingUp;
- (IBAction) showLoadUp;

+ (CashierTxHistoryHeaderView *) headerViewWithTitle:(NSString *)theTitle description:(NSString *)theDescription;

- (id) initWithDaysArray:(NSMutableArray*)_days;

@end
