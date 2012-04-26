//
//  PinEntryViewController.h
//  Cashbury
//
//  Created by jayanth S on 4/18/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "CBAsyncImageView.h"
#import "PaymentSuccessViewController.h"


@interface PinEntryViewController : UIViewController{
    NSString *pinEntryString;
    NSInteger currentPosition;
}

@property (retain, nonatomic) IBOutlet UILabel *billLabel;
@property (retain, nonatomic) IBOutlet UILabel *tipsLabel;
@property (retain, nonatomic) IBOutlet UILabel *totalLabel;

@property (retain, nonatomic) NSString *tipString;
@property (retain, nonatomic) NSString *billString;
@property (retain, nonatomic) IBOutlet CBAsyncImageView *userImage;
@property (retain, nonatomic) IBOutlet UILabel *pinMesgLabel;
@property (retain, nonatomic) IBOutlet UIImageView *firstTickImgView;
@property (retain, nonatomic) IBOutlet UIImageView *secTickImgView;
@property (retain, nonatomic) IBOutlet UIImageView *thirdTickImgView;
@property (retain, nonatomic) IBOutlet UIImageView *fourthTickImgView;

- (IBAction)keyboardAction:(id)sender;
- (IBAction)goBack:(id)sender;
- (IBAction)clearItems:(id)sender;
@end
