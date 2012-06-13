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
#import "Receipt.h"


@interface PinEntryViewController : UIViewController{
    NSMutableString *pinEntryString;
    NSInteger currentPosition;
    
}

@property (retain, nonatomic) IBOutlet UILabel *billLabel;
@property (retain, nonatomic) IBOutlet UILabel *totalLabel;
@property (retain, nonatomic) IBOutlet UIImageView *passcode1;
@property (retain, nonatomic) IBOutlet UIImageView *passcode2;
@property (retain, nonatomic) IBOutlet UIImageView *passcode3;
@property (retain, nonatomic) IBOutlet UIImageView *passcode4;
@property (retain, nonatomic) IBOutlet UILabel *shopName;



@property (retain, nonatomic) IBOutlet CBAsyncImageView *userImage;
@property (retain, nonatomic) IBOutlet UILabel *pinMesgLabel;


@property (retain, nonatomic) Receipt *receiptObj;

- (IBAction)keyboardAction:(id)sender;
- (IBAction)goBack:(id)sender;
- (IBAction)clearItems:(id)sender;
@end
