//
//  ReceiptViewController.h
//  Cashbury
//
//  Created by jayanth S on 5/9/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBMagnifiableViewController.h"
#import "RRSGlowLabel.h"

@interface ReceiptViewController : CBMagnifiableViewController
@property (retain, nonatomic) NSString *qrCode;
@property (retain, nonatomic) IBOutlet RRSGlowLabel *qrCodeLabel;
- (IBAction)doneButtonClicked:(id)sender;

@end