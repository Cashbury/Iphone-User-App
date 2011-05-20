//
//  KZPlaceViewController.h
//  Kazdoor
//
//  Created by Rami on 13/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <ZXingWidgetController.h>
#import "KZApplication.h"
#import "KZReward.h"
#import "KZStampView.h"

@interface KZRewardViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, KZURLRequestDelegate>
{
    
    NSUInteger earnedPoints;
    KZReward *reward;
	KZPlace *place;
	UIImage *tile;
	KZURLRequest *req;
}

@property (nonatomic, retain) IBOutlet UILabel *lbl_brand_name;
@property (nonatomic, retain) IBOutlet UILabel *lbl_reward_name;
@property (nonatomic, retain) IBOutlet UIImageView *img_reward_image;
@property (nonatomic, retain) IBOutlet UILabel *lbl_heading1;
@property (nonatomic, retain) IBOutlet UILabel *lbl_heading2;
@property (nonatomic, retain) IBOutlet UILabel *lbl_legal_terms;
@property (nonatomic, retain) IBOutlet UILabel *lbl_needed_points;
@property (nonatomic, retain) IBOutlet UITableView *tbl_table_view;
@property (nonatomic, retain) IBOutlet UITableViewCell *cell1_snap_to_win;
@property (nonatomic, retain) IBOutlet UITableViewCell *cell2_headings;
@property (nonatomic, retain) IBOutlet UITableViewCell *cell3_stamps;
@property (nonatomic, retain) IBOutlet UITableViewCell *cell4_terms;
@property (nonatomic, retain) IBOutlet UITableViewCell *cell5_bottom;
@property (nonatomic, retain) KZURLRequest *redeem_request;
@property (nonatomic, retain) KZStampView *stampView;
@property (nonatomic, retain) KZReward *reward;
@property (nonatomic, retain) KZPlace *place;

- (IBAction) didTapSnapButton:(id)theSender;

- (id) initWithReward:(KZReward*)theReward;

@end
