//
//  KZUnlockedRewardViewController.h
//  Cashbery
//
//  Created by Basayel Said on 6/22/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TouchXML.h"
#import "KZReward.h"
#import "KZApplication.h"
#import "KZAccount.h"
#import "GrantViewController.h"
 
@interface KZUnlockedRewardViewController : UIViewController <KZURLRequestDelegate> {
    KZReward *reward;
	KZPlace *place;
	KZURLRequest *req;
}


@property (nonatomic, retain) IBOutlet UILabel *lbl_reward_name;
@property (nonatomic, retain) IBOutlet UILabel *lbl_brand_name;
@property (nonatomic, retain) IBOutlet UILabel *lbl_heading1;
@property (nonatomic, retain) IBOutlet UILabel *lbl_heading2;
@property (nonatomic, retain) IBOutlet UIImageView *img_reward_image;
@property (nonatomic, retain) IBOutlet UIImageView *img_enjoy_crown;
@property (nonatomic, retain) IBOutlet UIImageView *img_enjoy_text;

@property (nonatomic, retain) UIViewController* place_vc;

@property (nonatomic, retain) IBOutlet UILabel* lbl_cost_score;
@property (nonatomic, retain) IBOutlet UIButton* btn_gray_card;
@property (nonatomic, retain) KZURLRequest *redeem_request;
@property (nonatomic, retain) KZReward *reward;
@property (nonatomic, retain) KZPlace *place;

- (IBAction) returnToStampsScreen;
- (IBAction) enjoyReward;
- (id) initWithReward:(KZReward*)theReward;

@end
