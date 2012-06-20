//
//  ScannedViewControllerViewController.h
//  Cashbury
//
//  Created by Mrithula Ancy on 6/14/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//
#define SCAN_TYPE_TEXT      10
#define SCAN_TYPE_EMAIL     11
#define SCAN_TYPE_CONTACT   12
#define SCAN_TYPE_WEB       13
#define SCAN_TYPE_PHONE     14

#define SCAN_TAG_SCANNEDHISTORY 20
#define SCAN_TAG_AFTERSCANNING  21

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "CBMagnifiableViewController.h"
#import "ContactDetails.h"
#import "RRSGlowLabel.h"

@interface ScannedViewControllerViewController : CBMagnifiableViewController<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>

@property () NSInteger tag;
@property (retain, nonatomic) IBOutlet UIView *containerView;
@property (retain, nonatomic) ContactDetails *contact;
@property (retain, nonatomic) IBOutlet UIView *webView;
@property (retain, nonatomic) IBOutlet UIButton *viewPlainTextButton;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UIView *textView;
@property (retain, nonatomic) IBOutlet UIView *phoneContactEmailView;
@property (retain, nonatomic) IBOutlet UIImageView *bottomSignalBar;
@property (retain, nonatomic) IBOutlet UILabel *typeLabel;
- (IBAction)goBack:(id)sender;
@end
