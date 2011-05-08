    //
//  KZPlaceInfoViewController.m
//  Kazdoor
//
//  Created by Rami on 11/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "KZPlaceInfoViewController.h"
#import "MapViewController.h"
#import "KZApplication.h"
#import "OpenHoursViewController.h"
#import "KZOpenHours.h"


@implementation KZPlaceInfoViewController

@synthesize nameLabel, streetLabel, addressLabel, navItem, imgLogo, lblPhone, lblOpen, lblMap, btnMap, btnPhone, btnOpen;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil place:(KZPlace *)thePlace
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        place = [thePlace retain];
    }
	
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navItem.title = place.businessName;
    self.nameLabel.text = [NSString stringWithFormat:@"%@", place.businessName];
    
	if (place.phone != nil && [place.phone isEqual:@""] == NO) {
		[self.btnPhone setHidden:NO];
		[self.lblPhone setHidden:NO];
		self.lblPhone.text = [NSString stringWithFormat:@"Call - %@", place.phone];
	} else {
		[self.lblPhone setHidden:YES];
		[self.btnPhone setHidden:YES];
	}

	if (place.address != nil && [place.address isEqual:@""] != YES) {		
		self.streetLabel.text = [NSString stringWithFormat:@"%@", place.address];
		self.addressLabel.text = [NSString stringWithFormat:@"%@, %@, %@", place.city, place.country, place.zipcode];
	}
	if (place.longitude != 0 && place.latitude != 0) {
		[self.lblMap setHidden:NO];
		[self.btnMap setHidden:NO];
	} else {
		[self.lblMap setHidden:YES];
		[self.btnMap setHidden:YES];
	}

	self.lblOpen.text = (place.is_open ? @"Open - Store Hours" : @"Closed - Store Hours");
	//place.open_hours
}

- (void)viewDidUnload
{
    
	self.nameLabel = nil;
    self.streetLabel = nil;
    self.addressLabel = nil;
    self.navItem = nil;
    [super viewDidUnload];
}


- (IBAction)didTapBackButton:(id)theSender
{
    [self dismissModalViewControllerAnimated:YES];
}


- (void)dealloc
{
    [nameLabel release];
    [streetLabel release];
    [addressLabel release];
    [navItem release];
    [place release];
    
	
	
    [super dealloc];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) { 
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", place.phone]]];	
	}
}

- (IBAction)doCall:(id)theSender {
	if (place.phone != nil && [place.phone isEqual:@""] != YES) { 
		UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:@"This will quit Cashbury and call the store." delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
		[menu setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
		[menu addButtonWithTitle:@"Call Store"];
		[menu addButtonWithTitle:@"Cancel"];
		menu.cancelButtonIndex = 1;
		[menu showInView:self.view];
		[menu release];
	}
}


- (IBAction)doShowMap:(id)theSender {
	MapViewController *vc = [[MapViewController alloc] initWithPlace:place];
	vc.modalPresentationStyle = UIModalPresentationFullScreen;
	vc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
	[self presentModalViewController:vc animated:YES];
	[vc release];
}

- (IBAction)doShowOpenHours:(id)theSender {
	OpenHoursViewController *vc = [[OpenHoursViewController alloc] initWithPlace:place];
	[self presentModalViewController:vc animated:YES];
	[vc release];
}


@end
