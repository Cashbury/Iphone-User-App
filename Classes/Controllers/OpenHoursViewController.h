//
//  OpenHoursViewController.h
//  Cashbury
//
//  Created by Basayel Said on 5/4/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KZPlace.h"

@interface OpenHoursViewController : UITableViewController {
	KZPlace *place;
}

- (id) initWithPlace:(KZPlace *) _place;

- (IBAction) closeMe;

@end
