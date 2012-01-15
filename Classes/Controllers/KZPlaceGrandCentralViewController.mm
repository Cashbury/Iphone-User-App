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
#import "MKMapView+ZoomLevel.h"

@implementation KZPlaceGrandCentralViewController

@synthesize cashburies_modal,
			place,
			lbl_brand_name, 
			lbl_place_name, 
			lbl_balance, 
			img_card, 
			lbl_address, 
			tbl_places_images, 
			btn_menu_opener, 
			map_view, 
			cell_buttons,
			cell_map_cell,
			cell_address,
			lbl_phone_number,
			lbl_ready_rewards,
			lbl_open_hours,
			img_open_hours,
			img_cashburies,
			zoom_level;



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
	KZCardsAtPlacesViewController* vc = [[[KZCardsAtPlacesViewController alloc] initWithPlace:self.place] autorelease];
	[nav pushViewController:vc animated:YES];
}


// just opens the menu if it is already open it does not close it

- (IBAction) openCashburiesAction {
	if ([[self.place getRewards] count] < 1) return;
	KZPlaceViewController *vc = [[KZPlaceViewController alloc] initWithPlace:place];
	self.cashburies_modal = vc;
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
	if ([self.place.open_hours count] < 1) return;
	OpenHoursViewController *vc = [[OpenHoursViewController alloc] initWithPlace:place];
	vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:vc animated:YES];
//    vc.parentController = self;
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
		if (self.place.distance > 1000.0) {
			[str_address appendFormat:@" - %0.1lf km away", self.place.distance/1000.0];
		} else {
			[str_address appendFormat:@" - %0.0lf meters away", self.place.distance];
		}
	}
	self.lbl_address.text = str_address;
	self.lbl_brand_name.text = self.place.business.name;
	//////////////////////////////////////
	self.lbl_place_name.text = @"";//[NSString stringWithFormat:@"- %@", self.place.name];
	//////////////////////////////////////
	self.lbl_phone_number.text = [self.place.phone stringByReplacingCharactersInRange:NSMakeRange(0, 3) withString:@""];
	NSUInteger unlocked_rewards_count = [self.place numberOfUnlockReward];
	NSUInteger all_rewards_count = [[self.place getRewards] count];
	self.lbl_ready_rewards.text = [NSString stringWithFormat:@"%d out of %d ready", 
											unlocked_rewards_count, all_rewards_count];
	
	UIImage* img_c = nil;
	if (unlocked_rewards_count > 0) {
		img_c = [UIImage imageNamed:@"places_menu_cashburies_green.png"];
	} else if (all_rewards_count > 0) {
		img_c = [UIImage imageNamed:@"places_menu_cashburies_yellow.png"];
	} else {
		img_c = [UIImage imageNamed:@"places_menu_cashburies_gray.png"];
	}
	[self.img_cashburies setImage:img_c];
	
	// set the open hours text and image
	UIImage* img_open = nil;
	if ([self.place.open_hours count] > 0) {
		self.lbl_open_hours.text = @"  now";	//(self.place.is_open ? @"now" : @"Closed now");
		if (self.place.is_open) {
			img_open = [UIImage imageNamed:@"places_menu_open.png"];
		} else {
			img_open = [UIImage imageNamed:@"places_menu_closed.png"];
		}
	} else {	// no open hours available
		self.lbl_open_hours.text = @"Sign not setup";
		img_open = [UIImage imageNamed:@"places_menu_open_btn_disabled.png"];
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
	
	///// The Card Image
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
	//////[self.map_view setRegion:region animated:NO];
	//////[self.map_view regionThatFits:region];

	CLLocationCoordinate2D centerCoord = { location.latitude, location.longitude };
	self.zoom_level = 15;
	BOOL show_my_location = YES;
	
	if (self.place.distance > 20000.0) {
		show_my_location = NO;
	} else {
		if (self.place.distance > 10000.0) {	// more than 10 km
			self.zoom_level = 13;
		} else if (self.place.distance > 2000.0) {	/// more than 2 km
			self.zoom_level = 14;
		} else {	// less than 2 km
			self.zoom_level = 15;
		}
	}
	/*
	if (show_my_location) {
		CLLocationCoordinate2D coordinate;
		coordinate.longitude = [[LocationHelper getLongitude] doubleValue];
		coordinate.latitude = [[LocationHelper getLatitude] doubleValue];
		[self.map_view setCenterCoordinate:coordinate];
		if ([self.map_view showsUserLocation] == NO) {
			[self.map_view setShowsUserLocation:YES];
		}
	}
	 */
	[self.map_view setCenterCoordinate:centerCoord zoomLevel:self.zoom_level animated:YES];
	
    
	
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
}


- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)aUserLocation {
	
	CLLocation *place_location = [[CLLocation alloc] initWithLatitude:self.place.latitude longitude:self.place.longitude];
	CLLocation *my_location = [[CLLocation alloc] initWithLatitude:[[LocationHelper getLatitude] doubleValue] longitude:[[LocationHelper getLongitude] doubleValue]];
	//float distance = [place_location getDistanceFrom:my_location];
	
    MKCoordinateRegion region;
    //MKCoordinateSpan span;
    //span.latitudeDelta = 0.05;
    //span.longitudeDelta = 0.05;
    CLLocationCoordinate2D location;
    location.latitude = aUserLocation.coordinate.latitude;
    location.longitude = aUserLocation.coordinate.longitude;
    //region.span = span;
    region.center = location;
	
	//AddressAnnotation *addAnnotation = [[AddressAnnotation alloc] initWithCoordinate:my_location.coordinate];
	//[addAnnotation ];
	//[addAnnotation setTitle:place.business.name andSubtitle:self.place.name];
	//[self.map_view addAnnotation:addAnnotation];
	
    [self.map_view setRegion:region animated:YES];
	[self.map_view setCenterCoordinate:place_location.coordinate zoomLevel:self.zoom_level animated:YES];
	
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
- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self performSelectorInBackground:@selector(loadPlaceImages) withObject:nil];
}

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
	self.cell_buttons = nil;
	
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
//	NSUInteger count = ceil([self.place.images_thumbs count]/4.0) + 2;
//	if (count < 6) count = 6; 
//    return count;
    return 5;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0) {
		return self.cell_address;
	} else if (indexPath.row == 1) {
		return self.cell_map_cell;
	}
    else if (indexPath.row == 2)
    {
        return self.cell_buttons;
    }
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlacesImages"];
	
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"PlacesImages"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
	UIButton *btn = nil;
	UIImageView *img = nil;
	NSUInteger i = 0;
	NSUInteger images_index = (indexPath.row - 2) * 4;
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

	NSUInteger unlocked_rewards_count = [self.place numberOfUnlockReward];
	NSUInteger all_rewards_count = [[self.place getRewards] count];
	self.lbl_ready_rewards.text = [NSString stringWithFormat:@"%d out of %d ready", 
								   unlocked_rewards_count, all_rewards_count];
	
	UIImage* img_c = nil;
	if (unlocked_rewards_count > 0) {
		img_c = [UIImage imageNamed:@"places_menu_cashburies_green.png"];
	} else if (all_rewards_count > 0) {
		img_c = [UIImage imageNamed:@"places_menu_cashburies_yellow.png"];
	} else {
		img_c = [UIImage imageNamed:@"places_menu_cashburies_gray.png"];
	}
	[self.img_cashburies setImage:img_c];
}

- (void) loadPlaceImages {
	
	/////////////LOAD PLACES
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	NSUInteger i = 0;
	NSUInteger count = [self.place.images_thumbs count];
	NSLog(@"COUNT: %d", count);
	for (i = 0; i < count; i++) {
		UIImageView* img_view = (UIImageView*)[self.tbl_places_images viewWithTag:1000 + i];
		NSLog(@"========= %d ", i);
		NSString* thumb = (NSString*)[self.place.images_thumbs objectAtIndex:i];
		NSLog(@"----- %@ ", thumb);
		UIImage* img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:thumb]]];
		[img_view setImage:img];
	}
	[pool release];
	 
}

- (void) imageButtonClicked:(id)_sender {
	NSUInteger index = [_sender tag]-3000;
	NSLog(@"Want to Open Image of Index: %d", index);
	if (index < 0 || index >= [self.place.images count]) return;
	////////TODO do this when there are images and when I know how it will look like
	//UIImage* img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[self.place.images objectAtIndex:index]]];
	
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0) {
		return self.cell_address.frame.size.height;
	} else if (indexPath.row == 1) {
		return self.cell_map_cell.frame.size.height;
	} else if (indexPath.row == 2) {
		return self.cell_buttons.frame.size.height;
	} else {
		return 80;
	}
}


@end
