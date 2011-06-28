//
//  OpenHoursViewController.h
//  Cashbury
//
//  Created by Basayel Said on 5/4/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KZPlace.h"
#import "KZPlaceInfoViewController.h"

@interface OpenHoursViewController : UIViewController {
	KZPlace *place;
}

@property (nonatomic, retain) IBOutlet UIButton *place_btn;
//@property (nonatomic, retain) IBOutlet UIButton *other_btn;

@property (nonatomic, retain) KZPlaceInfoViewController *parentController;

- (id) initWithPlace:(KZPlace *) _place;

- (IBAction)goBackToPlace:(id)theSender;

- (IBAction)goBacktoPlaces:(id)theSender;

@end
