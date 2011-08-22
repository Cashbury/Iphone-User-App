//
//  CashierTxHistoryViewController.h
//  Cashbery
//
//  Created by Basayel Said on 8/21/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CashierTxHistoryViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	NSMutableArray* days_array;
}

@property (nonatomic, retain) IBOutlet UILabel* lbl_title;
@property (nonatomic, retain) IBOutlet UIView* view_menu;
@property (nonatomic, retain) IBOutlet UIImageView* img_menu_arrow;
@property (nonatomic, retain) IBOutlet UIButton* btn_back;

- (IBAction) backAction;

- (id) initWithDaysArray:(NSMutableArray*)_days;

@end
