//
//  KZPlaceInfoViewController.h
//  Kazdoor
//
//  Created by Rami on 11/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KZPlace.h"

@interface KZPlaceInfoViewController : UIViewController <UIActionSheetDelegate>
{
    KZPlace *place;
	
}

@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *streetLabel;
@property (nonatomic, retain) IBOutlet UILabel *addressLabel;
@property (nonatomic, retain) IBOutlet UIImageView *imgLogo;
@property (nonatomic, retain) IBOutlet UINavigationItem *navItem;

@property (nonatomic, retain) IBOutlet UILabel *lblMap;

@property (nonatomic, retain) IBOutlet UILabel *lblPhone;

@property (nonatomic, retain) IBOutlet UILabel *lblOpen;

@property (nonatomic, retain) IBOutlet UIButton *btnMap;

@property (nonatomic, retain) IBOutlet UIButton *btnPhone;

@property (nonatomic, retain) IBOutlet UIButton *btnOpen;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil place:(KZPlace *)thePlace;

- (IBAction)didTapBackButton:(id)theSender;

- (IBAction)doCall:(id)theSender;

- (IBAction)doShowMap:(id)theSender;

- (IBAction)doShowOpenHours:(id)theSender;


@end
