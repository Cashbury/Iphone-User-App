//
//  CBQRScanViewController.h
//  Cashbury
//
//  Created by ramikhawandi on 21/3/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBQRScanViewController : UIViewController

@property (nonatomic, retain) IBOutlet UILabel *typeLabel;
@property (nonatomic, retain) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, retain) IBOutlet UIButton *actionButton;

- (IBAction) didTapClear:(id)theSender;

- (IBAction) didTapAction:(id)theSender;

@end
