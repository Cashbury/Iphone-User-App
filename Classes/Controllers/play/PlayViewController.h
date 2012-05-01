//
//  PlayViewController.h
//  Cashbury
//
//  Created by jayanth S on 4/26/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBMagnifiableViewController.h"

@interface PlayViewController : CBMagnifiableViewController<UIScrollViewDelegate>{
    
    NSMutableArray *spinImagesArray;
    NSMutableArray *positionArray;
    NSMutableArray *spingFloatArray;
    NSTimer *scrollTimer,*scrollTimer2,*scrollTimer3;
}
@property (retain, nonatomic) IBOutlet UIScrollView *scrollThree;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollTwo;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollOne;
@property (retain, nonatomic) IBOutlet UIView *spinContainerView;
@property (retain, nonatomic) IBOutlet UIScrollView *fullScrollView;
- (IBAction)backButtonClicked:(id)sender;
- (IBAction)spinButtonClicked:(id)sender;

@end
