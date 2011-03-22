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
<UITableViewDelegate, UITableViewDataSource, KZPlacesLibraryDelegate, ZXingDelegate, ScanHandlerDelegate>
{
    KZPlacesLibrary *placesArchive;
	NSArray *_places;
	UITableViewCell *tvCell;
}

@property (nonatomic, assign) IBOutlet UITableViewCell *tvCell;

- (void) snap_action:(id) sender;

@end
