//
//  KZPlacesViewController.h
//  Kazdoor
//
//  Created by Rami on 12/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBDropDownLabel.h"
#import "KZPlacesLibrary.h"
#import "KZSnapController.h"


@interface KZPlacesViewController : UIViewController 
<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, KZPlacesLibraryDelegate>
{
	UITableViewCell *tvCell;
}
@property (nonatomic, retain) IBOutlet UITableView *table_view;
@property (nonatomic, assign) IBOutlet UITableViewCell *tvCell;
@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;

@property (nonatomic, retain) IBOutlet CBDropDownLabel *cityLabel;

- (void) snap_action:(id) sender;
- (IBAction) didTapCardsButton;

+ (void) showPlacesScreen;
@end
