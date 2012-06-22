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
#import "PlaceView.h"

@interface OpenHoursViewController : CBMagnifiableViewController {
	PlaceView *place;
	NSMutableDictionary* days_hours;
	NSUInteger rows_count;
}

@property (nonatomic, retain) IBOutlet UILabel *lbl_title;
@property (nonatomic, retain) IBOutlet UIButton *place_btn;

@property (nonatomic, retain) IBOutlet UIButton *btn_close;

- (id) initWithPlace:(PlaceView *) _place;
- (IBAction)goBack:(id)sender;


@end
