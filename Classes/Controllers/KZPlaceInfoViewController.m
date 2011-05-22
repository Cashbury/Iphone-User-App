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
#import "UIView+Utils.h"

@implementation KZPlaceInfoViewController

@synthesize nameLabel, streetLabel, addressLabel, imgLogo, lblPhone, lblOpen, lblMap, btnMap, btnPhone, btnOpen, place_btn, other_btn;

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
    //self.navItem.title = place.businessName;
    self.nameLabel.text = [NSString stringWithFormat:@"%@", place.businessName];
	//////////////////////////////////////////////////////
	UIFont *myFont = [UIFont boldSystemFontOfSize:22.0];	
	CGSize size = [place.businessName sizeWithFont:myFont forWidth:190.0 lineBreakMode:UILineBreakModeTailTruncation];
	
	[self.place_btn setTitle:place.businessName forState:UIControlStateNormal];
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
	self.addressLabel.text = [NSString stringWithFormat:@"%@, %@, %@", (place.city == nil ? @"" : place.city), (place.country == nil ? @"" : place.country), (place.zipcode == nil ? @"" : place.zipcode)];
	
	if (place.longitude != 0 && place.latitude != 0) {
		[self.lblMap setHidden:NO];
		[self.btnMap setHidden:NO];
	} else {
		[self.lblMap setHidden:YES];
		[self.btnMap setHidden:YES];
	}

	self.lblOpen.text = (place.is_open ? @"Open - Store Hours" : @"Closed - Store Hours");
	if (place.brand_image != nil && [place.brand_image isEqual:@""] != YES) { 
		// set the logo image
		req = [[KZURLRequest alloc] initRequestWithString:place.brand_image andParams:nil delegate:self headers:nil andLoadingMessage:nil];
	}
    
    [self.imgLogo roundCornersUsingRadius:5 borderWidth:0 borderColor:nil];
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


- (IBAction)didTapBackButton:(id)theSender
{
    [self dismissModalViewControllerAnimated:YES];
}


- (IBAction)goBacktoPlaces:(id)theSender {
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


@end
