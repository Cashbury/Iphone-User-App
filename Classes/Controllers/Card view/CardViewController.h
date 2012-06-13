//
//  CardViewController.h
//  Cashbury
//
//  Created by Mrithula Ancy on 6/8/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "CBMagnifiableViewController.h"
#import "CBAsyncImageView.h"

@interface CardViewController : CBMagnifiableViewController<UIScrollViewDelegate,CBMagnifiableViewControllerDelegate>
@property (retain, nonatomic) IBOutlet CBAsyncImageView *userIconImage;
@property (retain, nonatomic) IBOutlet UILabel *usernameLabel;
@property (retain, nonatomic) IBOutlet UIImageView *msgNotiIconImage;
@property (retain, nonatomic) IBOutlet UIView *containerView;
@property (retain, nonatomic) IBOutlet UIView *cardView;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UIButton *lockButton;
@property (retain, nonatomic) IBOutlet UIView *controlPanelView;
@property (retain, nonatomic) IBOutlet UIPageControl *pageView;
- (IBAction)cpButtonsClicked:(id)sender;
- (IBAction)flipCard:(id)sender;

- (IBAction)goBack:(id)sender;
@end
