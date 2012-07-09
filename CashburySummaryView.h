//
//  CashburySummaryView.h
//  Cashbury
//
//  Created by Mrithula Ancy on 7/6/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceView.h"
#import "PlaceGrandViewController.h"

@interface CashburySummaryView : UIView
@property () NSInteger type;
@property (retain, nonatomic) IBOutlet UILabel *cashBackLabel;
@property (retain, nonatomic) IBOutlet UILabel *downLabel;
@property (retain, nonatomic) IBOutlet UIButton *enjoyButton;
@property (retain, nonatomic) IBOutlet UILabel *startAmtLabel;
@property (retain, nonatomic) IBOutlet UISlider *slider;
@property (retain, nonatomic) IBOutlet UILabel *endAmtLabel;
@property (retain, nonatomic) IBOutlet UIView *cashBackView;
@property (retain, nonatomic) IBOutlet UIView *starView;
@property (retain, nonatomic) PlaceView *placeView;
@property (retain, nonatomic) PlaceReward *reward;
@property (retain, nonatomic) IBOutlet UIScrollView *starScrollView;

- (IBAction)tapToEnjoyButton:(id)sender;

@end
