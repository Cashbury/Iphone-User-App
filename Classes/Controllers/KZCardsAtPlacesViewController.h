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
#import <MessageUI/MFMailComposeViewController.h>

@interface KZCardsAtPlacesViewController : UIViewController <KZPlacesLibraryDelegate, CBMagnifiableViewControllerDelegate, KZURLRequestDelegate, MFMailComposeViewControllerDelegate>
{
    @private
    BOOL frontCardIsAbove;
    
    BOOL isTipping;
    float tip;
}

@property (nonatomic, retain) IBOutlet UIView *cardContainer;
@property (nonatomic, retain) IBOutlet UIView *frontCard;
@property (nonatomic, retain) IBOutlet UIView *backCard;
@property (nonatomic, retain) IBOutlet UIView *qrCard;

@property (nonatomic, retain) IBOutlet UIImageView *qrCardTitleImage;
@property (nonatomic, retain) IBOutlet UIView *tipperView;
@property (nonatomic, retain) IBOutlet CBAsyncImageView *qrImage;
@property (nonatomic, retain) IBOutlet UIButton *button1;
@property (nonatomic, retain) IBOutlet UIButton *button2;
@property (nonatomic, retain) IBOutlet UIButton *button3;
@property (nonatomic, retain) IBOutlet UIButton *tipDescription;
@property (nonatomic, retain) IBOutlet UIButton *doneButton;

@property (nonatomic, retain) IBOutlet UIImageView *frontCardBackground;
@property (nonatomic, retain) IBOutlet UILabel *customerName;
@property (nonatomic, retain) IBOutlet CBAsyncImageView *profileImage;

@property (nonatomic, retain) IBOutlet UILabel *savingsBalance;

- (IBAction) showQRCode:(id)sender;
- (IBAction) flipCard:(id)sender;

- (IBAction) didTapPlaces:(id)sender;
- (IBAction) didTapSnap:(id)sender;

- (IBAction) didTapDoneButton:(id)theSender;

- (IBAction) didTapLoad:(id)theSender;
- (IBAction) didTapProfile:(id)sender;
- (IBAction) didTapReceipts:(id)theSender;
- (IBAction) didTapSupport:(id)theSender;
- (IBAction) didTapMessages:(id)theSender;
- (IBAction) didTapGifts:(id)theSender;

- (IBAction) didTapOnTip:(id)theSender;
- (IBAction) didTapOnTipButton1:(id)sender;
- (IBAction) didTapOnTipButton2:(id)sender;
- (IBAction) didTapOnTipButton3:(id)sender;


@end