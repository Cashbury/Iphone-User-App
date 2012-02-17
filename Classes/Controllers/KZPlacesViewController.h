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
#import "CBMagnifiableViewController.h"

@interface KZPlacesViewController : CBMagnifiableViewController 
<UITableViewDelegate, UITableViewDataSource, KZPlacesLibraryDelegate, UINavigationControllerDelegate>

@property (nonatomic, retain) IBOutlet UITableView *table_view;

@property (nonatomic, retain) IBOutlet CBDropDownLabel *cityLabel;

@property (nonatomic, retain) IBOutlet UIButton *doneButton;

- (IBAction) didTapCardsButton;

@end
