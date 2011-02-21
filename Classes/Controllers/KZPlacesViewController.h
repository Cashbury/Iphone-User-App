//
//  KZPlacesViewController.h
//  Kazdoor
//
//  Created by Rami on 12/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KZApplication.h"


@interface KZPlacesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, KZPlacesLibraryDelegate>
{
    KZPlacesLibrary *placesArchive;
}

@end
