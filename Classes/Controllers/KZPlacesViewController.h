//
//  KZPlacesViewController.h
//  Kazdoor
//
//  Created by Rami on 12/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KZApplication.h"
#import <ZXingWidgetController.h>


@interface KZPlacesViewController : UIViewController 
<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, KZPlacesLibraryDelegate, ZXingDelegate, ScanHandlerDelegate>
{
    KZPlacesLibrary *placesArchive;
	NSArray *_places;
	UITableViewCell *tvCell;
}
@property (nonatomic, retain) IBOutlet UITableView *table_view;
@property (nonatomic, assign) IBOutlet UITableViewCell *tvCell;
@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;

@property (nonatomic, retain) IBOutlet UIButton *cityButton;

- (void) snap_action:(id) sender;

- (IBAction) didTapCityButton:(id)theSender;

@end
