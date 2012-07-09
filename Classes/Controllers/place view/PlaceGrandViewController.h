//
//  PlaceGrandViewController.h
//  Cashbury
//
//  Created by Mrithula Ancy on 7/6/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#define CASHBURY_SUMMARY_STARVIEW   100
#define CASHBURY_SUMMARY_CASHBACK   101
#define CASHBURY_SUMMARY_TAPTOENJOY   102


#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "PlaceView.h"
#import "CBMagnifiableViewController.h"
#import "CBAsyncImageView.h"


@interface PlaceGrandViewController : CBMagnifiableViewController<UIActionSheetDelegate,MKMapViewDelegate>
@property (retain, nonatomic) IBOutlet UIImageView *placeImageBg;
@property (retain, nonatomic) IBOutlet CBAsyncImageView *placeIconImage;
@property (retain, nonatomic) IBOutlet UILabel *placeInfoLabel;
@property (retain, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (retain, nonatomic) IBOutlet UILabel *cashboxAmtLabel;
@property (retain, nonatomic) IBOutlet UILabel *credictsSavedLabel;
@property (retain, nonatomic) IBOutlet MKMapView *placeMapView;
@property (retain, nonatomic) IBOutlet UIView *placeImagesView;
@property (retain, nonatomic) IBOutlet UILabel *aboutLabel;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) PlaceView *placeObject;
@property (retain, nonatomic) IBOutlet UIScrollView *placeScrollView;
@property (retain, nonatomic) IBOutlet UIScrollView *summaryScroll;

- (IBAction)hoursClicked:(id)sender;
- (IBAction)cashburiesClicked:(id)sender;
- (IBAction)receiptsClicked:(id)sender;
- (IBAction)directionClicked:(id)sender;
- (IBAction)calButtonClicked:(id)sender;
- (IBAction)goBack:(id)sender;
@end
