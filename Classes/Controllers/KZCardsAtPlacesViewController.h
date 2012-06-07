//
//  KZCardsAtPlacesViewController.h
//  Cashbery
//
//  Created by Basayel Said on 6/26/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KZPlace.h"
#import "CBDropDownLabel.h"
#import "KZPlacesLibrary.h"
#import "KZPlacesViewController.h"
#import "CBAsyncImageView.h"
#import "KZURLRequest.h"
#import "KZEngagementHandler.h"
#import "PaymentSuccessViewController.h"
#import "CWRingUpViewController.h"
#import "CBLockViewController.h"
#import "EngagementSuccessViewController.h"
#import "PayementEntryViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "ReceiptViewController.h"


@interface KZCardsAtPlacesViewController : UIViewController <KZPlacesLibraryDelegate, CBMagnifiableViewControllerDelegate, KZURLRequestDelegate,
                                                             MFMailComposeViewControllerDelegate,
                                                             KZEngagementHandlerDelegate,CBLockViewControllerDelegate, UIScrollViewDelegate>
{
    @private
    BOOL frontCardIsAbove;
    
    BOOL isTipping;
    float tip;
    
    NSString *userHashCode;
    
    CBMagnifiableViewController *loadingView;
    NSInteger lastSelected;

    SystemSoundID soundID;
    NSURL *soundURL;
    
}

@property (nonatomic, retain) IBOutlet UIView *cardContainer;
@property (nonatomic, retain) IBOutlet UIView *frontCard;
@property (nonatomic, retain) IBOutlet UIView *backCard;
@property (nonatomic, retain) IBOutlet UIView *qrCard;

@property (nonatomic, retain) IBOutlet UIImageView *qrCardTitleImage;
@property (nonatomic, retain) IBOutlet UIView *tipperView;
@property (nonatomic, retain) IBOutlet CBAsyncImageView *qrImage;
@property (nonatomic, retain) IBOutlet UIButton *tipDescription;
@property (nonatomic, retain) IBOutlet UIButton *doneButton;

@property (nonatomic, retain) IBOutlet UIImageView *frontCardBackground;
@property (nonatomic, retain) IBOutlet UILabel *customerName;
@property (nonatomic, retain) IBOutlet CBAsyncImageView *profileImage;

@property (nonatomic, retain) IBOutlet UILabel *savingsBalance;
@property (retain, nonatomic) IBOutlet UIView *frontInnerView;
@property (retain, nonatomic) IBOutlet UIImageView *mapFrameBg;
@property (retain, nonatomic) IBOutlet UIImageView *notificationIcon;
@property (retain, nonatomic) IBOutlet UIScrollView *cpScrollView;
@property (retain, nonatomic) IBOutlet UIButton *cpEjectButton;
@property (retain, nonatomic) IBOutlet UIPageControl *cpPageView;
@property (retain, nonatomic) IBOutlet UIScrollView *tipsScrollView;

- (IBAction) showQRCode:(id)sender;
- (IBAction) flipCard:(id)sender;
- (IBAction)controlPanelButtonClicked:(id)sender;

- (IBAction) didTapPlaces:(id)sender;
- (IBAction) didTapSnap:(id)sender;

- (IBAction) didTapDoneButton:(id)theSender;

- (IBAction) didTapLoad:(id)theSender;

- (IBAction) didTapOnTip:(id)theSender;
- (IBAction)playButtonClicked:(id)sender;


@end