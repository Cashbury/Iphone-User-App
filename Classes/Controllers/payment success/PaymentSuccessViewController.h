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



@interface PaymentSuccessViewController : UIViewController

@property (retain, nonatomic) NSString *billAmount;
@property (retain, nonatomic) NSString *tipsAmount;
@property (retain, nonatomic) IBOutlet UIView *paidView;
@property (retain, nonatomic) IBOutlet UILabel *timeDateLabel;
@property (retain, nonatomic) IBOutlet UILabel *billLabel;
@property (retain, nonatomic) IBOutlet UILabel *tipsLabel;
@property (retain, nonatomic) IBOutlet UILabel *totalAmtLabel;
@property (retain, nonatomic) IBOutlet UIImageView *bottonBar;
- (IBAction)goBack:(id)sender;
- (IBAction)doneClicked:(id)sender;

@end
