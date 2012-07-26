//
//  PaymentSuccessViewController.h
//  Cashbury
//
//  Created by jayanth S on 4/18/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PinEntryViewController.h"
#import "PayementEntryViewController.h"
#import "Receipt.h"



@interface PaymentSuccessViewController : UIViewController<UIScrollViewDelegate>
@property (retain, nonatomic) IBOutlet UILabel *youSavedLabel;
@property (retain, nonatomic) IBOutlet UIView *paidView;
@property (retain, nonatomic) IBOutlet UILabel *billLabel;
@property (retain, nonatomic) IBOutlet UILabel *tipsLabel;
@property (retain, nonatomic) IBOutlet UILabel *totalAmtLabel;
@property (retain, nonatomic) IBOutlet UIImageView *bottonBar;
@property (retain, nonatomic) IBOutlet UIScrollView *successScrollView;
@property (retain, nonatomic) IBOutlet UIButton *facebookButton;
@property (retain, nonatomic) IBOutlet UIButton *tweetButton;
@property (retain, nonatomic) IBOutlet UIButton *refundButton;
@property (retain, nonatomic) IBOutlet UILabel *shopnameLabel;
@property (retain, nonatomic) IBOutlet UILabel *addressLabel;
@property (retain, nonatomic) IBOutlet UILabel *timeStamplabel;
@property (retain, nonatomic) IBOutlet UILabel *receiptNumberLabel;
@property (retain, nonatomic) IBOutlet UIView *authorizeView;
@property () NSInteger tag;
@property (retain, nonatomic) IBOutlet UILabel *spendMoreLabel;
@property (retain, nonatomic) IBOutlet UILabel *tounlockLabel;
@property (retain, nonatomic) IBOutlet UIButton *crownButton;
@property (retain, nonatomic) IBOutlet UILabel *earnedSpinLabel;
@property (retain, nonatomic) IBOutlet UILabel *spinWinAwesomeLabel;
@property (retain, nonatomic) IBOutlet UILabel *giveUrFriendsLabel;
@property (retain, nonatomic) IBOutlet UIImageView *paidImageView;

@property (retain, nonatomic) IBOutlet UIButton *spin2WinButton;
@property (retain, nonatomic) Receipt *receiptObject;
- (IBAction)goBack:(id)sender;
- (IBAction)doneClicked:(id)sender;
- (IBAction)spinToWin:(id)sender;
- (IBAction)refundClicked:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *doneButton;

@end
