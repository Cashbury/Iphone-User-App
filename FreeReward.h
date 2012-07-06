//
//  FreeReward.h
//  Cashbury
//
//  Created by Mrithula Ancy on 7/5/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceView.h"
#import "CBAsyncImageView.h"
#import "KZApplication.h"
#import "KZURLRequest.h"
#import "KZUserInfo.h"

@protocol FreeViewDelegate <NSObject>

-(void)showGrantView:(PlaceReward*)reward;

@end

@interface FreeReward : UIView<KZURLRequestDelegate>

- (IBAction)eButton:(id)sender;
@property (retain, nonatomic) PlaceView *placeObject;
@property (retain, nonatomic) PlaceReward *rewardObject;
@property (retain, nonatomic) IBOutlet UILabel *pointsNeededLabel;
@property (retain, nonatomic) IBOutlet UILabel *rewardNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *detailsLabel;
@property (retain, nonatomic) IBOutlet UIButton *eButton;
@property (retain, nonatomic) IBOutlet UIView *unLockView;
@property (retain, nonatomic) IBOutlet UIImageView *crownImageView;
@property (retain, nonatomic) IBOutlet CBAsyncImageView *placeImageView;
@property (retain, nonatomic) IBOutlet UIScrollView *lockedScroll;
@property (retain, nonatomic) IBOutlet UIView *lockView;
@property (retain, nonatomic) IBOutlet UIImageView *tapToEnjoy;
@property (retain, nonatomic) IBOutlet UIButton *njoyButton;
@property (retain, nonatomic) id<FreeViewDelegate>freeDelegate;
- (IBAction)tapToEnjoyButtonClicked:(id)sender;
@end
