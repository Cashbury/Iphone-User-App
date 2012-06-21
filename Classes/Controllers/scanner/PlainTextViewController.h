//
//  PlainTextViewController.h
//  Cashbury
//
//  Created by Mrithula Ancy on 6/21/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RRSGlowLabel.h"

@interface PlainTextViewController : UIViewController

@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet RRSGlowLabel *plainTextLabel;
@property (retain, nonatomic)  NSString *titleString;
@property (retain, nonatomic)  NSString *plainText;
- (IBAction)goBack:(id)sender;
@end
