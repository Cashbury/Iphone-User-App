    //
//  KZPlaceGrandCentralViewController.m
//  Cashbery
//
//  Created by Basayel Said on 7/4/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import "KZPlaceGrandCentralViewController.h"
#import "KZPlace.h"
#import "LocationHelper.h"
#import "KZPlaceViewController.h"
#import "OpenHoursViewController.h"
#import "KZCardsAtPlacesViewController.h"
#import "KZUtils.h"
#import "LocationHelper.h"
#import "QuartzCore/QuartzCore.h"

@implementation KZPlaceGrandCentralViewController

@synthesize place,
			lbl_brand_name, 
			lbl_place_name, 
			lbl_balance, 
			img_card, 
			lbl_address, 
			tbl_places_images, 
			btn_menu_opener, 
			map_view, 
			view_nav_bar,
			cell_map_cell,
			lbl_phone_number,
			lbl_ready_rewards,
			lbl_open_hours,
			img_open_hours;



- (id) initWithPlace:(KZPlace*) _place {
	if (self = [self initWithNibName:@"KZPlaceGrandCentralView" bundle:nil]) {
		self.place = _place;
	} 
	return self;
}

- (IBAction) backToPlacesAction {
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) showCardsAction {
	[[self retain] autorelease];
	UINavigationController *nav = self.navigationController;
	[[nav retain] autorelease];
	[nav popViewControllerAnimated:NO];
	KZCardsAtPlacesViewController* vc = [[[KZCardsAtPlacesViewController alloc] initWithNibName:@"KZCardsAtPlaces" bundle:nil] autorelease];
	[nav pushViewController:vc animated:YES];
}


// just opens the menu if it is already open it does not close it


- (IBAction) openCloseMenuAction {
	CGRect f = self.view_nav_bar.frame;
	if (!is_menu_open) {	// closed
		f.origin.y -= 134;
	} else {	// open
		f.origin.y += 134;
	}

	[UIView animateWithDuration:0.5 
					 animations:^(void){
									self.view_nav_bar.frame = f;
								} 
					 completion:^(BOOL finished){	
									if (is_menu_open) {
										[self.btn_menu_opener setSelected:YES];
									} else {
										[self.btn_menu_opener setSelected:NO];
									}
								}
	 ];
	
	is_menu_open = !is_menu_open;

}

- (void) openMenuSelector {
	if (is_menu_open) return; 
	[self openCloseMenuAction];
}

- (IBAction) openCashburiesAction {
	KZPlaceViewController *vc = [[KZPlaceViewController alloc] initWithPlace:place];
	vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:vc animated:YES];
	[vc release];
}

- (IBAction) openMapMenuAction {
	if (self.place.latitude > 0.0 || self.place.longitude > 0.0) { 
		UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:@"This will quit Cashbury and open Google maps." delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
		[menu setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
		[menu setTag:801];
		[menu addButtonWithTitle:@"Get Directions"];
		[menu addButtonWithTitle:@"Cancel"];
		menu.cancelButtonIndex = 1;
		
		[menu showInView:self.view];
		[menu release];
	}
}


- (IBAction) callPhoneMenuAction {
	if (self.place.phone != nil && [self.place.phone isEqual:@""] != YES) { 
		UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:@"This will quit Cashbury and call the store." delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
		[menu setTag:701];
		[menu setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
		[menu addButtonWithTitle:@"Call Store"];
		[menu addButtonWithTitle:@"Cancel"];
		menu.cancelButtonIndex = 1;
		[menu showInView:self.view];
		[menu release];
	}
}

- (IBAction) openHoursAction {
	OpenHoursViewController *vc = [[OpenHoursViewController alloc] initWithPlace:place];
	vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:vc animated:YES];
    vc.parentController = self;
	[vc release];
}

- (IBAction) aboutAction {
	NSLog(@"Pressed About Button...");
}



- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) { 
		if ([actionSheet tag] == 701) {		// phone
			NSLog(@"Calling %@ ...", self.place.phone);
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", self.place.phone]]];
		} else if ([actionSheet tag] == 801) {		// map
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://maps.google.com/?q=%lf,%lf&spn=0.005139,0.009645&z=16", self.place.latitude, self.place.longitude]]];
		}
	}
}







/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	is_menu_open = NO;
	NSMutableString* str_address = [[NSMutableString alloc] init];
	if ([KZUtils isStringValid:self.place.address]) [str_address appendString:self.place.address];
	if ([KZUtils isStringValid:self.place.cross_street]) [str_address appendFormat:@" @ %@", self.place.cross_street];
	if (self.place.distance > 0.0) {
		[str_address appendFormat:@" - %0.1lf %@ away", self.place.distance, self.place.distance_unit];
	}
	self.lbl_address.text = str_address;
	self.lbl_brand_name.text = self.place.business.name;
	//////////////////////////////////////
	self.lbl_place_name.text = @"";//[NSString stringWithFormat:@"- %@", self.place.name];
	//////////////////////////////////////
	self.lbl_phone_number.text = [self.place.phone stringByReplacingCharactersInRange:NSMakeRange(0, 3) withString:@""];
	NSUInteger unlocked_rewards_count = [self.place numberOfUnlockReward];
	self.lbl_ready_rewards.text = [NSString stringWithFormat:@"%d out of %d ready", 
								   unlocked_rewards_count, [[self.place getRewards] count]];
	
	//self.place.is_open = YES;
	// set the open hours text and image
	self.lbl_open_hours.text = @"now";	//(self.place.is_open ? @"now" : @"Closed now");
	UIImage* img_open = nil;
	if (self.place.is_open) {
		img_open = [UIImage imageNamed:@"places_menu_open.png"];
	} else {
		img_open = [UIImage imageNamed:@"places_menu_closed.png"];
	}
	CGRect f = self.img_open_hours.frame;
	f.size = img_open.size;
	self.img_open_hours.frame = f;
	[self.img_open_hours setImage:img_open];
	
	
	
	UIFont *myFont = self.lbl_brand_name.font;	
	CGSize size = [self.place.business.name sizeWithFont:myFont forWidth:290.0 lineBreakMode:UILineBreakModeTailTruncation];
	
	CGRect f1 = self.lbl_brand_name.frame;
	f1.size.width = size.width;
	self.lbl_brand_name.frame = f1;
	
	CGRect f2 = self.lbl_place_name.frame;
	f2.origin.x = f1.origin.x + f1.size.width + 5;
	self.lbl_place_name.frame = f2;
	
	
	//[self performSelectorInBackground:@selector(loadCardImage) withObject:nil];
	
	// Show Map
	CLLocationCoordinate2D location;
	location.latitude = self.place.latitude;
    location.longitude = self.place.longitude;
    //location.latitude = [[LocationHelper getLatitude] doubleValue];
    //location.longitude = [[LocationHelper getLongitude] doubleValue];
	
	
	MKCoordinateRegion region;
	MKCoordinateSpan span;
	span.latitudeDelta = 0.003139;
	span.longitudeDelta = 0.003645;
	
	region.span = span;
	region.center = location;	
	AddressAnnotation *addAnnotation = [[AddressAnnotation alloc] initWithCoordinate:location];
	[addAnnotation setTitle:place.business.name andSubtitle:self.place.name];
	[self.map_view addAnnotation:addAnnotation];
	[self.map_view setRegion:region animated:NO];
	[self.map_view regionThatFits:region];

	
	//CLLocation *loc1 = [[CLLocation alloc] initWithLatitude:[[LocationHelper getLatitude] doubleValue] longitude:[[LocationHelper getLongitude] doubleValue]];
	//double distance = [loc1 getDistanceFrom:newLocation];
	/*
	CLLocationCoordinate2D coordinate;
	coordinate.longitude = [[LocationHelper getLongitude] doubleValue];
	coordinate.latitude = [[LocationHelper getLatitude] doubleValue];
	[self.map_view setCenterCoordinate:coordinate];
    if ([self.map_view showsUserLocation] == NO) {
        [self.map_view setShowsUserLocation:YES];
    }
	 */
	[self performSelectorInBackground:@selector(loadPlaceImages) withObject:nil];
	[self performSelector:@selector(openMenuSelector) withObject:nil afterDelay:1.0];
}


- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)aUserLocation {
	CLLocation *place_location = [[CLLocation alloc] initWithLatitude:self.place.latitude longitude:self.place.longitude];
	CLLocation *my_location = [[CLLocation alloc] initWithLatitude:[[LocationHelper getLatitude] doubleValue] longitude:[[LocationHelper getLongitude] doubleValue]];
	float distance = [place_location getDistanceFrom:my_location];
	
	double zoom = 0.0;
	if (distance > 1000000) {
		zoom = 0.8;
	} else if (distance > 1000) {
		zoom = 0.009;
	} else {
		zoom = 0.002;
	}
	
	NSLog(@"===== %lf", zoom);
	
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = zoom;
    span.longitudeDelta = zoom;
    CLLocationCoordinate2D location;
    location.latitude = aUserLocation.coordinate.latitude;
    location.longitude = aUserLocation.coordinate.longitude;
    region.span = span;
    region.center = location;
    [self.map_view setRegion:region animated:YES];
}


- (void) loadCardImage {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	NSString* image_url = self.place.business.image_url;
	//NSLog(@"********* %@", image_url);
	if ([KZUtils isStringValid:image_url] == YES) { 
		UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:image_url]]];
		CGRect image_frame = self.img_card.frame; 
		image_frame.size = img.size;
		self.img_card.frame = image_frame;
		[self.img_card setImage:img];
		self.img_card.layer.masksToBounds = YES;
		self.img_card.layer.cornerRadius = 5.0;
		self.img_card.layer.borderColor = [UIColor grayColor].CGColor;
		self.img_card.layer.borderWidth = 1.0;
	}
	[pool release];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
/*
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
*/

- (void)dealloc {
	self.place = nil;
	self.lbl_brand_name = nil;
	self.lbl_place_name = nil;
	self.lbl_balance = nil;
	self.img_card = nil;
	self.lbl_address = nil;
	self.tbl_places_images = nil; 
	self.btn_menu_opener = nil;
	self.map_view = nil;
	self.view_nav_bar = nil;
	
    [super dealloc];
}
































#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	///////FIXME make te number of rows dynamic according to the number of place images
	NSUInteger count = ceil([[self.place.images_thumbs count] floatValue]/4.0) + 1;
	if (count < 5) count = 5; 
    return count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0) return self.cell_map_cell;
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlacesImages"];
	
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"PlacesImages"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
	UIButton *btn = nil;
	UIImageView *img = nil;
	NSUInteger i = 0;
	NSUInteger images_index = (indexPath.row - 1) * 4;
	for (i = 0; i < 4; i++) {
		img = [[UIImageView alloc] initWithFrame:CGRectMake(i * 80, 0, 79, 79)];
		[img setImage:[UIImage imageNamed:@"place_img_blank.png"]];
		[img setTag:1000 + images_index];
		btn = [[UIButton alloc] initWithFrame:CGRectMake(i * 80, 0, 79, 79)];
		[btn setTag:3000 + images_index];
		[btn addTarget:self 
				action:@selector(imageButtonClicked:) 
	  forControlEvents:UIControlEventTouchUpInside];
		[cell addSubview:img];
		[cell addSubview:btn];
		[img release];
		[btn release];
		images_index += 1;
	}
	
    return cell;
}

- (void) viewWillAppear:(BOOL)animated {
	[self.navigationController setNavigationBarHidden:YES animated:YES];	
}

- (void) loadPlaceImages {
	/////////////LOAD PLACES
	NSUInteger i = 0;
	NSUInteger count = [self.place.images_thumbs count];
	for (i = 0; i < count; i++) {
		UIImageView* img_view = (UIImageView*)[self.tbl_places_images viewWithTag:1000 + i];
		NSLog(@"========= %d ", i);
		NSLog(@"----- %@ ", [self.place.images_thumbs objectAtIndex:i]);
		UIImage* img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[self.place.images_thumbs objectAtIndex:i]]];
		[img_view setImage:img];
	}	
}

- (void) imageButtonClicked:(id)_sender {
	NSUInteger index = [_sender tag]-3000;
	NSLog(@"Want to Open Image of Index: %d", index);
	if (index < 0 || index >= [self.place.images count]) return;
	////////FIXME do this when there are images and when I know how it will look like
	//UIImage* img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[self.place.images objectAtIndex:index]]];
	
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0) {
		return self.cell_map_cell.frame.size.height;
	} else {
		return 80;
	}
}




@end
