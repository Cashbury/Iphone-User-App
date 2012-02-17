//
//  OpenHoursViewController.h
//  Cashbury
//
//  Created by Basayel Said on 5/4/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KZPlace.h"
#import "CBMagnifiableViewController.h"

@interface OpenHoursViewController : CBMagnifiableViewController {
	KZPlace *place;
	NSMutableDictionary* days_hours;
	NSMutableArray* all_hours;
	NSUInteger rows_count;
}

@property (nonatomic, retain) IBOutlet UILabel *lbl_title;
@property (nonatomic, retain) IBOutlet UIButton *place_btn;
//@property (nonatomic, retain) IBOutlet UIButton *other_btn;

@property (nonatomic, retain) IBOutlet UIButton *btn_close;

- (id) initWithPlace:(KZPlace *) _place;

- (IBAction)goBackToPlace:(id)theSender;

- (IBAction)goBacktoPlaces:(id)theSender;

@end
