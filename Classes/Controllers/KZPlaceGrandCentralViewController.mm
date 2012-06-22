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
@synthesize firstCell;
@synthesize imagesCell;

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



- (id) initWithPlace:(PlaceView*) _place {
	if (self = [self initWithNibName:@"KZPlaceGrandCentralView" bundle:nil]) {
		self.place = _place;
	} 
	return self;
}

- (IBAction) backToPlacesAction {
	//[self.navigationController popViewControllerAnimated:YES];
    [self diminishViewController:self duration:0.35];
}

#pragma mark Button clicks

- (IBAction)loadAction:(id)sender
{
    
}

- (IBAction)receiptsAction:(id)sender
{
  
    KZCustomerReceiptHistoryViewController *_controller = [[KZCustomerReceiptHistoryViewController alloc] initWithNibName:@"KZCustomerReceiptHistoryView" bundle:nil];
    _controller.place           =   self.place;
     
     [self magnifyViewController:_controller duration:0.35];
     
     _controller.titleLabel.text = self.place.name;
}

- (IBAction) showCardsAction {/*
	[[self retain] autorelease];
	UINavigationController *nav = self.navigationController;
	[[nav retain] autorelease];
	[nav popViewControllerAnimated:NO];
	KZCardsAtPlacesViewController* vc = [[[KZCardsAtPlacesViewController alloc] initWithPlace:self.place] autorelease];
	[nav pushViewController:vc animated:YES];*/
}


// just opens the menu if it is already open it does not close it

- (IBAction) openCashburiesAction {/*
	if ([[self.place getRewards] count] < 1) return;
	KZPlaceViewController *vc = [[KZPlaceViewController alloc] initWithPlace:place];
	vc.delegate = self;
    
    [self magnifyViewController:vc duration:0.35];*/
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
	//if ([self.place.hoursArray count] < 1) return;

    OpenHoursViewController *_controller    =   [[OpenHoursViewController alloc] initWithPlace:place];
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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set the address
	NSMutableString* str_address = [[NSMutableString alloc] init];
	if ([KZUtils isStringValid:self.place.address]) [str_address appendString:self.place.address];
	if ([KZUtils isStringValid:self.place.crossStreet]) [str_address appendFormat:@" @ %@", self.place.crossStreet];
    self.lbl_address.text = str_address;
    
	self.lbl_brand_name.text = self.place.name;
	
    
	// Map
    self.map_view.showsUserLocation = YES;
    
	CLLocationCoordinate2D location;
	location.latitude = self.place.latitude;
    location.longitude = self.place.longitude;
	MKCoordinateRegion region;
	MKCoordinateSpan span;
	span.latitudeDelta = 0.003139;
	span.longitudeDelta = 0.003645;
	
	region.span = span;
	region.center = location;	
	AddressAnnotation *addAnnotation = [[AddressAnnotation alloc] initWithCoordinate:location];
	[addAnnotation setTitle:place.name andSubtitle:self.place.name];
	[self.map_view addAnnotation:addAnnotation];

	CLLocationCoordinate2D centerCoord = { location.latitude, location.longitude };
	self.zoom_level = 15;
	BOOL show_my_location = YES;
	
    
    //Distance
    float dist  =   [self.place.discount floatValue];
	if (dist > 20000.0) {
		show_my_location = NO;
	} else {
		if (dist > 10000.0) {	// more than 10 km
			self.zoom_level = 13;
		} else if (dist > 2000.0) {	/// more than 2 km
			self.zoom_level = 14;
		} else {	// less than 2 km
			self.zoom_level = 15;
		}
	}
	[self.map_view setCenterCoordinate:centerCoord zoomLevel:self.zoom_level animated:YES];

    [self.businessImage loadImageWithAsyncUrl:[NSURL URLWithString:self.place.smallImgURL]];
    
    //images cell
    
    for (int i = 0; i <[self.place.imagesArray count]; i ++) {
        CBAsyncImageView *imgView   =   (CBAsyncImageView*)[imagesCell.contentView viewWithTag:i+1];
        [imgView loadImageWithAsyncUrl:[NSURL URLWithString:((PlaceImages*)[self.place.imagesArray objectAtIndex:i]).thumbURL]];
        
    }
    
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
    
    [self setFirstCell:nil];
    [self setImagesCell:nil];
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


- (void) viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
    
    NSString *_openNow  =   (self.place.isOpen) ? @"Open now" : @"Closed now";
    
    float placeDist     =   [self.place.distance floatValue];
    
	if (placeDist > 0.0)
    {
		if (placeDist > 1000.0)
        {
			_openNow = [_openNow stringByAppendingFormat:@" - %0.1lf km away", placeDist/1000.0];
		}
        else
        {
			_openNow = [_openNow stringByAppendingFormat:@" - %0.0lf meters away", placeDist];
		}
	}
    self.openNowLabel.text = _openNow;
    
    self.aboutLabel.text = self.place.about;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
	[self.navigationController setNavigationBarHidden:YES animated:YES];
    
    /*
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
    
    [self setSavingsLabelText:[_busines savingsBalance] forBusiness:_busines];*/
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
	
    [firstCell release];
    [imagesCell release];
    [super dealloc];
}




#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
		return self.firstCell;
	}

	if (indexPath.row == 1) {
		return self.cell_buttons;
	}
    else if (indexPath.row == 2)
    {
        return self.cell_map_cell;
    }
    else if (indexPath.row == 3)
    {
        return self.cell_address;
    }
    else if (indexPath.row == 5)
    {
        return self.aboutCell;
    }else {
        return imagesCell;
    }

    return nil;
}

- (void) imageButtonClicked:(id)_sender {
//	NSUInteger index = [_sender tag]-3000;
//	NSLog(@"Want to Open Image of Index: %d", index);
//	if (index < 0 || index >= [self.place.imagesArray count]) return;
//	////////TODO do this when there are images and when I know how it will look like
//	//UIImage* img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[self.place.images objectAtIndex:index]]];
	
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0) {
		return self.firstCell.frame.size.height;
	} else if (indexPath.row == 1) {
		return self.cell_buttons.frame.size.height;
	} else if (indexPath.row == 2) {
		return self.cell_map_cell.frame.size.height;
	} else if (indexPath.row == 3) {
		return self.cell_address.frame.size.height;
	} else if (indexPath.row == 4) {
		return self.imagesCell.frame.size.height;
	} else if (indexPath.row == 5) {
		return self.aboutCell.frame.size.height;
	}else {
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
