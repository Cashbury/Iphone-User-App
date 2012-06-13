//
//  PayementEntryViewController.h
//  Cashbury
//
//  Created by Quintet on 4/25/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "CBAsyncImageView.h"
#import "CBMagnifiableViewController.h"
#import "PaymentSuccessViewController.h"
#import "RRSGlowLabel.h"
#import "PlaceView.h"
#import "Receipt.h"



@interface PayementEntryViewController : CBMagnifiableViewController<UIScrollViewDelegate>{
    
    NSMutableString *amtCurrency;
    NSMutableString *amountString;
    NSString *tipsString;
    SystemSoundID soundID;
    NSURL *soundURL;
    PlaceView *placeObject;
    NSInteger tipPer;
    
}

@property (retain, nonatomic) IBOutlet UIImageView *toastCafeBg;
@property (retain, nonatomic) IBOutlet CBAsyncImageView *userLogo;
@property (retain, nonatomic) IBOutlet UILabel *enterBillLbl;
@property (retain, nonatomic) IBOutlet UILabel *amountlabel;
@property (retain, nonatomic) IBOutlet UIView *keyBoardView;
@property (retain, nonatomic) IBOutlet UILabel *tipsLabel;
@property (retain, nonatomic) IBOutlet UILabel *billsTipsLabel;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (retain, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (retain, nonatomic) IBOutlet UIImageView *tipsSelectedArrow;
@property (retain, nonatomic) IBOutlet UIButton *payButton;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UIButton *cancelButton;
@property (retain, nonatomic) IBOutlet UIButton *addTipButton;
@property () BOOL isPinBased;
@property (retain, nonatomic)  PlaceView *placeObject;
- (IBAction)keyBoardAction:(id)sender;
- (IBAction)clearButton:(id)sender;
- (IBAction)exitButton:(id)sender;
- (IBAction)payButton:(id)sender;
- (IBAction)addTip:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;

@end
