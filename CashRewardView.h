//
//  CashRewardView.h
//  Cashbury
//
//  Created by Mrithula Ancy on 7/5/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KazdoorAppDelegate.h"
#import "PlaceView.h"


@interface CashRewardView : UIView{
    KazdoorAppDelegate *appDelegate;
}

@property (retain, nonatomic) PlaceReward *rewardObject;
@property (retain, nonatomic) PlaceView *placeObject;
@property (retain, nonatomic) IBOutlet UIView *lockedView;
@property (retain, nonatomic) IBOutlet UIView *unLockedView;
@property (retain, nonatomic) IBOutlet UIScrollView *lockedScrollView;
@property (retain, nonatomic) IBOutlet UILabel *heading2Label;
@property (retain, nonatomic) IBOutlet UILabel *spendMoreLabel;
@property (retain, nonatomic) IBOutlet UILabel *spendUntilLabel;
@property (retain, nonatomic) IBOutlet UIImageView *coinnImageView;
@property (retain, nonatomic) IBOutlet UIButton *eButton;

- (IBAction)turnOver:(id)sender;
@property (retain, nonatomic) IBOutlet UILabel *pointsNeededLabel;
@end
