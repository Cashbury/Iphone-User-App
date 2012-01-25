//
//  KZPlaceGrandCentralViewController.h
//  Cashbery
//
//  Created by Basayel Said on 7/4/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KZPlace.h"
#import <MapKit/MapKit.h>
#import "AddressAnnotation.h"
#import "KZReloadableDelegate.h"
#import "CBAsyncImageView.h"
#import "CBMagnifiableViewController.h"

@interface KZPlaceGrandCentralViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, MKMapViewDelegate,CBMagnifiableViewControllerDelegate>

@property (nonatomic, retain) id<KZReloadableDelegate> cashburies_modal;
@property (nonatomic, retain) IBOutlet KZPlace* place;
@property (nonatomic, retain) IBOutlet UILabel* lbl_brand_name;
@property (nonatomic, retain) IBOutlet UILabel* lbl_place_name;
@property (nonatomic, retain) IBOutlet UILabel* lbl_balance;
@property (nonatomic, retain) IBOutlet UILabel *openNowLabel;
@property (nonatomic, retain) IBOutlet UILabel* lbl_address;
@property (nonatomic, retain) IBOutlet UITableView* tbl_places_images;
@property (nonatomic, retain) IBOutlet MKMapView* map_view;
@property (nonatomic, retain) IBOutlet UITableViewCell* cell_buttons;
@property (nonatomic, retain) IBOutlet UITableViewCell* cell_map_cell;
@property (nonatomic, retain) IBOutlet UITableViewCell* cell_address;
@property (nonatomic, retain) IBOutlet UIButton *backButton;

@property (nonatomic, retain) IBOutlet UITableViewCell *aboutCell;
@property (nonatomic, retain) IBOutlet UILabel *aboutLabel;
@property (nonatomic, retain) IBOutlet UILabel *savingsLabel;

@property (nonatomic, retain) IBOutlet CBAsyncImageView *businessImage;

@property (nonatomic) NSUInteger zoom_level;

- (IBAction) backToPlacesAction;
- (IBAction) openCashburiesAction;
- (IBAction) openMapMenuAction;
- (IBAction) openMapAction;
- (IBAction) callPhoneMenuAction;
- (IBAction) callPhoneAction;
- (IBAction) openHoursAction;

- (IBAction) loadAction:(id)sender;
- (IBAction) receiptsAction:(id)sender;

- (id) initWithPlace:(KZPlace*) _place;

@end
