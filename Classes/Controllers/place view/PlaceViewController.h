//
//  PlaceViewController.h
//  Cashbury
//
//  Created by Mrithula Ancy on 6/7/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceView.h"
#import "PlacesViewCell.h"
#import "CardViewController.h"
#import "KZEngagementHandler.h"
#import "PlayViewController.h"
#import "PayementEntryViewController.h"
#import "PullToRefreshHeaderView.h"
#import "KZPlacesLibrary.h"
#import "KZUserInfo.h"
#import "KazdoorAppDelegate.h"
#import "TBXML.h"



@interface PlaceViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,KZEngagementHandlerDelegate,HeaderViewDelegate>{
    
    NSMutableArray *nearPlacesArray;
    NSMutableArray *farPlacesArray;
    BOOL didSlideDown;
    CBMagnifiableViewController *loadingView;
    PullToRefreshHeaderView *headerView;
    BOOL checkForRefresh;
    NSMutableData *receivedData;
    KazdoorAppDelegate *appDelegate;
    
}

@property (retain, nonatomic) IBOutlet UIView *mapContainerView;
@property (retain, nonatomic) IBOutlet UITableView *placesTableview;
- (IBAction)goToCardView:(id)sender;
- (IBAction)goToScanner:(id)sender;
- (IBAction)goToPlay:(id)sender;
@end
