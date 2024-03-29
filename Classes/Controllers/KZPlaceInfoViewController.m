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
#import "KZUtils.h"
#import "QuartzCore/QuartzCore.h"

@implementation KZPlaceInfoViewController

@synthesize nameLabel, streetLabel, addressLabel, imgLogo, lblPhone, lblOpen, lblMap, btnMap, btnPhone, btnOpen, place_btn, other_btn, menu, menu_c, menu_eject;

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
    [self.navigationController setNavigationBarHidden:YES];
    //self.navItem.title = place.business.name;
    self.nameLabel.text = [NSString stringWithFormat:@"%@", place.business.name];
	//////////////////////////////////////////////////////
	UIFont *myFont = [UIFont boldSystemFontOfSize:22.0];	
	CGSize size = [place.business.name sizeWithFont:myFont forWidth:190.0 lineBreakMode:UILineBreakModeTailTruncation];
	
	[self.place_btn setTitle:place.business.name forState:UIControlStateNormal];
	CGRect other_frame = self.other_btn.frame;
	other_frame.origin.x = 50 + size.width;
	CGRect place_frame = self.place_btn.frame;
	place_frame.size.width = size.width;
	self.other_btn.frame = other_frame;
	self.place_btn.frame = place_frame;
	
	//////////////////////////////////////////////////////
	
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
	} else {
		self.streetLabel.text = @"";
	}
	
	
	NSMutableString *str_address = [NSMutableString stringWithFormat:@"%@", place.city];
	if ([KZUtils isStringValid:place.country]) {
		if ([str_address isEqual:@""] == NO) [str_address appendString:@", "];
		[str_address appendString:place.country];
	}
	if ([KZUtils isStringValid:place.zipcode]) {
		if ([str_address isEqual:@""] == NO) [str_address appendString:@", "];
		[str_address appendString:place.zipcode];
	}
	
	self.addressLabel.text = str_address;
	
	if (place.longitude != 0 && place.latitude != 0) {
		[self.lblMap setHidden:NO];
		[self.btnMap setHidden:NO];
	} else {
		[self.lblMap setHidden:YES];
		[self.btnMap setHidden:YES];
	}

	self.lblOpen.text = (place.is_open ? @"Open - Store Hours" : @"Closed - Store Hours");
	if (place.business.image_url != nil && [place.business.image_url isEqual:@""] != YES) { 
		// set the logo image
		req = [[KZURLRequest alloc] initRequestWithString:place.business.image_url andParams:nil delegate:self headers:nil andLoadingMessage:nil];
	}

    self.imgLogo.layer.masksToBounds = YES;
	self.imgLogo.layer.cornerRadius = 5.0;
	
}

- (void)viewDidUnload
{
	self.nameLabel = nil;
    self.streetLabel = nil;
    self.addressLabel = nil;
	[req release];
    //self.navItem = nil;
    [super viewDidUnload];
}


- (void)dealloc
{
    [nameLabel release];
    [streetLabel release];
    [addressLabel release];
    //[navItem release];
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
		UIActionSheet *action_sheet = [[UIActionSheet alloc] initWithTitle:@"This will quit Cashbury and call the store." delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
		[action_sheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
		[action_sheet addButtonWithTitle:@"Call Store"];
		[action_sheet addButtonWithTitle:@"Cancel"];
		action_sheet.cancelButtonIndex = 1;
		[action_sheet showInView:self.view];
		[action_sheet release];
	}
}


- (IBAction)doShowMap:(id)theSender {
	MapViewController *vc = [[MapViewController alloc] initWithPlace:place];
	//vc.modalPresentationStyle = UIModalPresentationFullScreen;
	//vc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
	[self presentModalViewController:vc animated:YES];
    vc.parentController = self;
	[vc release];
}

- (IBAction)doShowOpenHours:(id)theSender {
	OpenHoursViewController *vc = [[OpenHoursViewController alloc] initWithPlace:place];
	[self presentModalViewController:vc animated:YES];
    vc.parentController = self;
	[vc release];
}


- (IBAction)didTapBackButton:(id)theSender
{
	if (is_menu_open) {
		[self openCloseMenu];
		[self performSelector:@selector(menuAnimationDone) withObject:nil afterDelay:0.5];
	} else {
		[self menuAnimationDone];
	}
}

- (void) menuAnimationDone {
    [self dismissModalViewControllerAnimated:YES];
}


- (IBAction)goBacktoPlaces:(id)theSender {
	if (is_menu_open) {
		[self openCloseMenu];
		[self performSelector:@selector(menuAnimationDoneGoBackToPlaces) withObject:nil afterDelay:0.5];
	} else {
		[self menuAnimationDoneGoBackToPlaces];
	}
}

- (void) menuAnimationDoneGoBackToPlaces {
	[self dismissModalViewControllerAnimated:YES];
	[[KZApplication getAppDelegate].navigationController popViewControllerAnimated:YES];
}


- (void) KZURLRequest:(KZURLRequest *)theRequest didFailWithError:(NSError*)theError {
	///DO NOTHING
	[theRequest release];
}

- (void) KZURLRequest:(KZURLRequest *)theRequest didSucceedWithData:(NSData*)theData {
	UIImage *img = [UIImage imageWithData:theData];
	CGRect image_frame = self.imgLogo.frame;
	image_frame.size = img.size;
	self.imgLogo.frame = image_frame;
	[self.imgLogo setImage:img];
	[theRequest release];
}


- (IBAction) openCloseMenu {
	
	CGRect frame = self.menu.frame;
	if (is_menu_open == NO) {
		// open the menu (ejected)
		[self.menu_c setImage:[UIImage imageNamed:@"Info-nav-icon-ejected.png"]];
		[self.menu_eject setImage:[UIImage imageNamed:@"Ejected-Nav.png"]];
		is_menu_open = YES;
		frame.origin.y -= frame.size.height;
	} else {
		// close the menu (not ejected)
		[self.menu_c setImage:[UIImage imageNamed:@"Info-nav-icon-inuse.png"]];
		[self.menu_eject setImage:[UIImage imageNamed:@"Eject-Nav.png"]];
		is_menu_open = NO;
		frame.origin.y += frame.size.height;
	}
	
	// make animation
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	self.menu.frame = frame;
	[UIView commitAnimations];
	
}

@end
