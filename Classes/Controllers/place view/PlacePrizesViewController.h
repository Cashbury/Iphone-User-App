//
//  PlacePrizesViewController.h
//  Cashbury
//
//  Created by Mrithula Ancy on 7/4/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceView.h"
#import "CBMagnifiableViewController.h"
#import "FreeReward.h"

@interface PlacePrizesViewController : CBMagnifiableViewController<UIScrollViewDelegate,FreeViewDelegate>
@property (retain, nonatomic) IBOutlet UILabel *titleName;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) PlaceView *placeObject;
- (IBAction)goBack:(id)sender;

@end
