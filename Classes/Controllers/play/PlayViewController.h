//
//  PlayViewController.h
//  Cashbury
//
//  Created by jayanth S on 4/26/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//
#define FROM_CARDVIEW   10
#define FROM_BILLVIEW   20
#import <UIKit/UIKit.h>
#import "CBMagnifiableViewController.h"
#import "PayementEntryViewController.h"
#import "PinEntryViewController.h"

@interface PlayViewController : CBMagnifiableViewController<UIScrollViewDelegate>{
    
    NSMutableArray *imagesArrayOne,*imagesArrayTwo,*imagesArrayThree;
    NSMutableArray *positionArray;
    NSMutableArray *spingFloatArray;
    NSTimer *scrollTimer,*scrollTimer2,*scrollTimer3;
    NSInteger tag;
}
@property (retain, nonatomic) IBOutlet UIScrollView *scrollThree;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollTwo;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollOne;
@property (retain, nonatomic) IBOutlet UIView *spinContainerView;
@property (retain, nonatomic) IBOutlet UIScrollView *fullScrollView;
@property () NSInteger tag;

- (IBAction)backButtonClicked:(id)sender;
- (IBAction)spinButtonClicked:(id)sender;
- (IBAction)myPrizesClicked:(id)sender;
- (IBAction)prizeBoardClicked:(id)sender;
- (IBAction)winnersBoardClicked:(id)sender;

@end
