//
//  GrantViewController.h
//  Cashbury
//
//  Created by Basayel Said on 3/22/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KZBusiness.h"
#import "KZPlace.h"
#import "KZReward.h"

@interface GrantViewController : UIViewController {
	IBOutlet UILabel *lblBusinessName;
	IBOutlet UILabel *lblBranchAddress;
	IBOutlet UILabel *lblReward;
	IBOutlet UILabel *lblTime;
	IBOutlet UILabel *lblName;
	IBOutlet UIView *viewReceipt;
	NSString *share_string;
	NSString* img_url;
}

- (id) initWithBusiness:(KZBusiness*)_biz andPlace:(KZPlace*)_place andReward:(KZReward*)_reward;

- (IBAction) clear_btn:(id)sender;
- (IBAction) share_btn:(id)sender;

@property (nonatomic, retain) IBOutlet UILabel *lblBusinessName;
@property (nonatomic, retain) IBOutlet UILabel *lblBranchAddress;
@property (nonatomic, retain) IBOutlet UILabel *lblReward;
@property (nonatomic, retain) IBOutlet UILabel *lblTime;
@property (nonatomic, retain) IBOutlet UILabel *lblName;
@property (nonatomic, retain) IBOutlet UIView *viewReceipt;
@property (nonatomic, retain) IBOutlet UIImageView *img_register;
@property (nonatomic, retain) NSString *share_string;
@property (nonatomic, retain) KZReward *reward;
@property (nonatomic, retain) KZPlace *place;
@property (nonatomic, retain) KZBusiness *biz;
@end
