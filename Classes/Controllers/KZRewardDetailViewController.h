//
//  KZRewardDetailViewController.h
//  Kazdoor
//
//  Created by Rami on 27/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KZReward.h"
#import "KZApplication.h"

@interface KZRewardDetailViewController : UIViewController <ScanHandlerDelegate>
{
    KZPointsLibrary *pointsArchive;
}

@property (nonatomic, retain) KZReward *reward;

@property (nonatomic, retain) IBOutlet UILabel *rewardTitle;
@property (nonatomic, retain) IBOutlet UILabel *placeName;

@property (nonatomic, retain) IBOutlet UILabel *statusLabel;
@property (nonatomic, retain) IBOutlet UIProgressView *progressView;

@property (nonatomic, retain) IBOutlet UIButton *redeemButton;

@property (nonatomic, retain) IBOutlet UILabel *grantedLabel;
@property (nonatomic, retain) IBOutlet UILabel *instructionLabel;

- (id)initWithReward:(KZReward*)theReward;

- (IBAction)didTapRedeemButton:(id)theSender;

@end
