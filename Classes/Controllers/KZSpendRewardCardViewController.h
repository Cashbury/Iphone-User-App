//
//  KZSpendRewardCardViewController.h
//  Cashbery
//
//  Created by Basayel Said on 8/1/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KZReward.h"
#import "KZUnlockedSpendRewardViewController.h"

@interface KZSpendRewardCardViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
	
}

@property (nonatomic, retain) KZReward* reward;
@property (nonatomic, retain) KZUnlockedSpendRewardViewController* unlocked_reward_vc;
@property (nonatomic, retain) IBOutlet UILabel* lbl_reward_name;
@property (nonatomic, retain) IBOutlet UILabel* lbl_valid_until;
@property (nonatomic, retain) IBOutlet UILabel* lbl_legal_terms;
@property (nonatomic, retain) IBOutlet UILabel* lbl_reward_description;
@property (nonatomic, retain) IBOutlet UILabel* lbl_progress_text;
@property (nonatomic, retain) IBOutlet UILabel* lbl_reward_money_amount;
@property (nonatomic, retain) IBOutlet UIButton* btn_show_unlocked;
@property (nonatomic, retain) IBOutlet UITableView* tbl_card_details;
@property (nonatomic, retain) IBOutlet UITableViewCell* cell_top;
@property (nonatomic, retain) IBOutlet UITableViewCell* cell_middle;
@property (nonatomic, retain) IBOutlet UITableViewCell* cell_bottom;

- (id) initWithReward:(KZReward*)theReward;

- (IBAction) showUnlockedScreen;

@end
