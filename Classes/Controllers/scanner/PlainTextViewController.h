//
//  PlainTextViewController.h
//  Cashbury
//
//  Created by Mrithula Ancy on 7/9/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlainTextViewController : UIViewController
@property (retain, nonatomic) IBOutlet UIImageView *barImgView;
@property (retain, nonatomic) IBOutlet UIView *containerView;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UILabel *plainTextView;
- (IBAction)goBack:(id)sender;

@end
