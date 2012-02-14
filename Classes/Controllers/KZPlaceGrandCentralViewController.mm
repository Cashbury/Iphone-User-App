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
#import "KZCustomerReceiptHistoryViewController.h"

@interface KZPlaceGrandCentralViewController (PrivateMethods)
- (void) setSavingsLabelText:(NSNumber *)theNumber forBusiness:(KZBusiness *)theBusiness;
@end

@implementation KZPlaceGrandCentralViewController

@synthesize cashburies_modal,
			place,
			lbl_brand_name, 
			lbl_place_name, 
			lbl_balance, 
			lbl_address, 
			tbl_places_images, 
			map_view, 
			cell_buttons,
			cell_map_cell,
			cell_address,
			zoom_level,
            backButton,
            openNowLabel;

@synthesize aboutCell, aboutLabel, savingsLabel, businessImage;



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
	vc.delegate = self;
    
    [self magnifyViewController:vc duration:0.35];
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
		[menu addButtonWithTitle:@"Call"];
		[menu addButtonWithTitle:@"Cancel"];
		menu.cancelButtonIndex = 1;
		[menu showInView:self.view];
		[menu release];
	}
}

- (IBAction) openHoursAction {
	if ([self.place.open_hours count] < 1) return;

    OpenHoursViewController *_controller = [[OpenHoursViewController alloc] initWithPlace:place];
    _controller.delegate = self;
    
    [self magnifyViewController:_controller duration:0.35];
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
    
    // Set the address
	NSMutableString* str_address = [[NSMutableString alloc] init];
	if ([KZUtils isStringValid:self.place.address]) [str_address appendString:self.place.address];
	if ([KZUtils isStringValid:self.place.cross_street]) [str_address appendFormat:@" @ %@", self.place.cross_street];
    self.lbl_address.text = str_address;
    
	self.lbl_brand_name.text = self.place.business.name;
	
	// Show 
    self.map_view.showsUserLocation = YES;
    
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
    
    [self.businessImage loadImageWithAsyncUrl:self.place.business.image_url];
    
}


- (void) viewDidUnload
{
	self.place = nil;
	self.lbl_brand_name = nil;
	self.lbl_place_name = nil;
	self.lbl_balance = nil;
	self.lbl_address = nil;
	self.tbl_places_images = nil; 
	self.map_view = nil;
	self.cell_buttons = nil;
    self.backButton = nil;
    self.openNowLabel = nil;
    self.aboutCell = nil;
    self.savingsLabel = nil;
    self.aboutLabel = nil;
    self.businessImage = nil;
    
    [super viewDidUnload];
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
- (void) viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
    
    NSString *_openNow = (self.place.is_open) ? @"Open now" : @"Closed now";
    
	if (self.place.distance > 0.0)
    {
		if (self.place.distance > 1000.0)
        {
			_openNow = [_openNow stringByAppendingFormat:@" - %0.1lf km away", self.place.distance/1000.0];
		}
        else
        {
			_openNow = [_openNow stringByAppendingFormat:@" - %0.0lf meters away", self.place.distance];
		}
	}
    self.openNowLabel.text = _openNow;
    
    self.aboutLabel.text = self.place.about;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
	[self.navigationController setNavigationBarHidden:YES animated:YES];
    
    KZBusiness *_busines = self.place.business;
    
    // Listen to balance & savings updates
    NSNotificationCenter *_nc = [NSNotificationCenter defaultCenter];
    [_nc addObserver:self selector:@selector(didUpdateBalance:) name:KZBusinessBalanceNotification object:_busines];
    [_nc addObserver:self selector:@selector(didUpdateSavings:) name:KZBusinessSavingsNotification object:_busines];
    
    // Load the balance
    float _balance = [[_busines totalBalance] floatValue];
	NSString *_currency = [_busines getCurrencyCode];
    
    if (_currency == nil)
    {
        // Default to dollar sign
        _currency = @"$";
    }
    
    self.lbl_balance.text = [NSString stringWithFormat:@"%@%1.2f", _currency, _balance];
    
    [self setSavingsLabelText:[_busines savingsBalance] forBusiness:_busines];
}

- (void) viewWillDisappear:(BOOL)isAnimated
{
    [super viewWillDisappear:isAnimated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc
{
	[place release];
	[lbl_brand_name release];
	[lbl_place_name release];
	[lbl_balance release];
	[lbl_address release];
	[tbl_places_images release]; 
	[map_view release];
	[cell_buttons release];
    [backButton release];
    [openNowLabel release];
    [aboutCell release];
    [savingsLabel release];
    [aboutLabel release];
    [businessImage release];
	
    [super dealloc];
}

#pragma mark - Private Methods

- (void) setSavingsLabelText:(NSNumber *)theNumber forBusiness:(KZBusiness *)theBusiness
{
    float _savings = [theNumber floatValue];
	NSString *_currency = [theBusiness getCurrencyCode];
    
    if (_currency == nil)
    {
        // Default to dollar sign
        _currency = @"$";
    }
    
    self.savingsLabel.text = [NSString stringWithFormat:@"You saved %@%1.2f so far here with Cashbury", _currency, _savings];
}

#pragma mark - Actions

- (void) didUpdateBalance:(NSNotification *)theNotification
{
    KZBusiness *_busines = (KZBusiness *) [theNotification object];
    
    NSNumber *_moneyBalance = (NSNumber *) [[theNotification userInfo] objectForKey:@"totalBalance"];
    
    float _balance = [_moneyBalance floatValue];
	NSString *_currency = [_busines getCurrencyCode];
    
    if (_currency == nil)
    {
        // Default to dollar sign
        _currency = @"$";
    }
    
    self.lbl_balance.text = [NSString stringWithFormat:@"%@%1.2f", _currency, _balance];
}

- (void) didUpdateSavings:(NSNotification *)theNotification
{
    KZBusiness *_busines = (KZBusiness *) [theNotification object];
    
    NSNumber *_savingsNumber = (NSNumber *) [[theNotification userInfo] objectForKey:@"savings"];
    
    [self setSavingsLabelText:_savingsNumber forBusiness:_busines];
}

- (IBAction)loadAction:(id)sender
{
    
}

- (IBAction)receiptsAction:(id)sender
{
    KZCustomerReceiptHistoryViewController *_controller = [[KZCustomerReceiptHistoryViewController alloc] initWithNibName:@"KZCustomerReceiptHistoryView" bundle:nil];
    _controller.delegate = self;
    
    [self magnifyViewController:_controller duration:0.35];
    
    _controller.titleLabel.text = self.place.business.name;
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
    return 6;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0) {
		return self.cell_buttons;
	}
    else if (indexPath.row == 1)
    {
        return self.cell_map_cell;
    }
    else if (indexPath.row == 2)
    {
        return self.cell_address;
    }
    else if (indexPath.row == 5)
    {
        return self.aboutCell;
    }
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlacesImages"];
	
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"PlacesImages"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIButton *btn = nil;
        CBAsyncImageView *img = nil;
        NSUInteger i = 0;
        NSUInteger images_index = (indexPath.row - 3) * 4;
        for (i = 0; i < 4; i++)
        {
            img = [[CBAsyncImageView alloc] initWithFrame:CGRectMake(i * 80, 0, 79, 79)];
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
            
            if (images_index < [self.place.images_thumbs count])
            {
                NSString *_urlString = (NSString*)[self.place.images_thumbs objectAtIndex:images_index];
                
                [img loadImageWithAsyncUrl:[NSURL URLWithString:_urlString]];
            }
            
            images_index += 1;
        }
    }
	
    return cell;
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
		return self.cell_buttons.frame.size.height;
	} else if (indexPath.row == 1) {
		return self.cell_map_cell.frame.size.height;
	} else if (indexPath.row == 2) {
		return self.cell_address.frame.size.height;
	} else if (indexPath.row == 5) {
		return self.aboutCell.frame.size.height;
	} else {
		return 80;
	}
}

//------------------------------------
// CBMagnifiableViewControllerDelegate methods
//------------------------------------
#pragma mark - CBMagnifiableViewControllerDelegate methods

- (void) dismissViewController:(CBMagnifiableViewController *)theController
{
    UIViewController *_controllerToRemove = theController;
    
    if (theController.navigationController)
    {
        _controllerToRemove = theController.navigationController;
    }
    
    [self diminishViewController:_controllerToRemove duration:0.35];
    
    [_controllerToRemove release];
}

@end
