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

@interface KZPlaceGrandCentralViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, MKMapViewDelegate> {
	BOOL is_menu_open;
}

@property (nonatomic, retain) id<KZReloadableDelegate> cashburies_modal;
@property (nonatomic, retain) IBOutlet KZPlace* place;
@property (nonatomic, retain) IBOutlet UILabel* lbl_brand_name;
@property (nonatomic, retain) IBOutlet UILabel* lbl_place_name;
@property (nonatomic, retain) IBOutlet UILabel* lbl_balance;
@property (nonatomic, retain) IBOutlet UIImageView* img_card;
@property (nonatomic, retain) IBOutlet UIImageView* img_cashburies;
@property (nonatomic, retain) IBOutlet UIImageView* img_open_hours;
@property (nonatomic, retain) IBOutlet UILabel* lbl_address;
@property (nonatomic, retain) IBOutlet UIButton* btn_menu_opener;
@property (nonatomic, retain) IBOutlet UITableView* tbl_places_images;
@property (nonatomic, retain) IBOutlet MKMapView* map_view;
@property (nonatomic, retain) IBOutlet UITableViewCell* cell_buttons;
@property (nonatomic, retain) IBOutlet UITableViewCell* cell_map_cell;
@property (nonatomic, retain) IBOutlet UITableViewCell* cell_address;
@property (nonatomic, retain) IBOutlet UILabel* lbl_phone_number;
@property (nonatomic, retain) IBOutlet UILabel* lbl_ready_rewards;
@property (nonatomic, retain) IBOutlet UILabel* lbl_open_hours;
@property (nonatomic) NSUInteger zoom_level;

- (IBAction) backToPlacesAction;
- (IBAction) showCardsAction;
- (IBAction) openCloseMenuAction;
- (IBAction) openCashburiesAction;
- (IBAction) openMapMenuAction;
- (IBAction) openMapAction;
- (IBAction) callPhoneMenuAction;
- (IBAction) callPhoneAction;
- (IBAction) openHoursAction;
- (IBAction) aboutAction;

- (id) initWithPlace:(KZPlace*) _place;

@end
