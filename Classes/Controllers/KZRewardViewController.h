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



@interface KZRewardViewController : UIViewController 
<ZXingDelegate, KZPointsLibraryDelegate, UIAlertViewDelegate, KZURLRequestDelegate, ScanHandlerDelegate>
{
    KZPointsLibrary *pointsArchive;
    
    NSUInteger earnedPoints;
    KZReward *reward;
	KZPlace *place;
    BOOL ready;
	
	KZURLRequest *redeem_request;
}

@property (nonatomic, retain) IBOutlet UILabel *businessNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *rewardNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, retain) IBOutlet UILabel *pointsValueLabel;
@property (nonatomic, retain) IBOutlet UIButton *button;
@property (nonatomic, retain) IBOutlet UIImageView *starImage;
@property (nonatomic, retain) IBOutlet UILabel *showToClaimLabel;
@property (nonatomic, retain) IBOutlet UILabel *grantRewardLabel;
@property (nonatomic, retain) IBOutlet UIImageView *gageBackground;
@property (nonatomic, retain) IBOutlet UILabel *pointsLabel;
@property (retain, nonatomic) KZURLRequest *redeem_request;
@property (nonatomic, retain) KZStampView *stampView;
@property (nonatomic, retain) KZReward *reward;
@property (nonatomic, retain) KZPlace *place;

- (id) initWithReward:(KZReward*)theReward;
- (void) checkRewards;

- (IBAction) didTapSnapButton:(id)theSender;

@end
