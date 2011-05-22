//
//  KZPlacesViewController.m
//  Kazdoor
//
//  Created by Rami on 12/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "KZPlacesViewController.h"
#import "KZPlaceViewController.h"
#import "KZPlacesLibrary.h"
#import "KZPlace.h"
#import "KZReward.h"
#import "QRCodeReader.h"
#import "LoginViewController.h"
#import "KZOpenHours.h"
#import "UINavigationBar+CustomBackground.h"
#import "CBCitySelectorViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation KZPlacesViewController



@synthesize tvCell, searchBar, table_view, cityButton;
//------------------------------------
// Init & dealloc
//------------------------------------
#pragma mark -
#pragma mark Init & dealloc

- (void) dealloc
{
    [cityButton release];
    [table_view release];
    [searchBar release];
    [tvCell release];
    
    [super dealloc];
}

//------------------------------------
// UIViewController methods
//------------------------------------
#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad
{
    [super viewDidLoad];
	//////TODO Comment these lines and uncomment the one next to them
	/*[self.navigationController setNavigationBarHidden:NO];
	self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;*/
	self.navigationController.navigationBar.tintColor = [UIColor blackColor];
	//self.title = @"Cashbury";
	//[self.navigationController setNavigationBarHidden:YES];
	
	/*
	UIImage *snap_img = [UIImage imageNamed:@"btn-snap.png"];
	UIImage *places_img = [UIImage imageNamed:@"btn-places.png"];
	
	UIButton *snap_btn = [UIButton buttonWithType:UIButtonTypeCustom];
	snap_btn.frame = CGRectMake(80, 14, snap_img.size.width, snap_img.size.height);
	[snap_btn setImage:snap_img forState:UIControlStateNormal];
	UIBarButtonItem *snap_bar_btn = [[UIBarButtonItem alloc] initWithCustomView:snap_btn];
	[snap_btn addTarget:self action:@selector(snap_action:) forControlEvents:UIControlEventTouchUpInside];
	[self.navigationController.toolbar addSubview:snap_btn];
	
	UIButton *places_btn = [UIButton buttonWithType:UIButtonTypeCustom];
	places_btn.frame = CGRectMake(240 - places_img.size.width, 12, places_img.size.width, places_img.size.height);
	[places_btn setImage:places_img forState:UIControlStateNormal];
	[self.navigationController.toolbar addSubview:places_btn];
	*/
	/////TODO comment these 3 lines
	UIBarButtonItem *_logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(logout_action:)];
	self.navigationItem.rightBarButtonItem = _logoutButton;
	[_logoutButton release];
    
    [self.cityButton setTitleColor:RGB(94,92,93) forState:UIControlStateNormal];
    [self.cityButton setTitleColor:RGB(94,92,93) forState:UIControlStateHighlighted];
	
	//[self.navigationController setToolbarHidden:NO animated:NO];
	
    placesArchive = [[KZApplication shared] placesArchive];
    placesArchive.delegate = self;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
	self.table_view = nil;
    self.cityButton = nil;
    self.tvCell = nil;
    self.searchBar = nil;
}


- (void) viewDidAppear:(BOOL)animated {
	[placesArchive requestPlacesWithKeywords:searchBar.text];
	//////FIXME remove this line
	[self.navigationController setNavigationBarHidden:NO];
}


//------------------------------------
// KZPlacesLibraryDelegate methods
//------------------------------------
#pragma mark -
#pragma mark KZPlacesLibraryDelegate methods

- (void) didUpdatePlaces
{
    UITableView *_tableView = self.table_view;
	_places = [placesArchive places];
    [_tableView reloadData];
}

- (void) didFailUpdatePlaces
{
	NSLog(@"####: Failed to update places.");
}

//------------------------------------
// UITableViewDataSource methods
//------------------------------------
#pragma mark -
#pragma mark UITableViewDataSource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlacesCell"];
	/*
	if (cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"PlacesTableCellView" owner:self options:nil];
		cell = tvCell;
		self.tvCell = nil;
	}
	 
	UIImageView *reward_image = (UIImageView *)[cell viewWithTag:1];
	[reward_image setImage:[UIImage imageNamed:@"btn-Reward.png"]];
	*/
    _places = [placesArchive places];
	KZPlace *_place = [_places objectAtIndex:indexPath.row];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"PlacesCell"];
    }
	UIImageView *img;
	if ([_place hasAutoUnlockReward]) {
		img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn-reward_green.png"]];
	} else {
		img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn-reward_gray.png"]];
	}
	
	
	img.backgroundColor = [UIColor clearColor];
	img.opaque = NO;

    [cell addSubview:img];
	CGPoint origin;// [gesture locationInView:[self superview]];
	origin.x = cell.frame.size.width - 75;
	origin.y = (int)(cell.frame.size.height/2);
	
	[img setCenter:origin];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = _place.businessName;
	cell.detailTextLabel.text = _place.name;
	[img release];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_places count];
}

//------------------------------------
// UITableViewDelegate methods
//------------------------------------
#pragma mark -
#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [searchBar resignFirstResponder];
    KZPlace *_place = [[placesArchive places] objectAtIndex:indexPath.row];
    
    KZPlaceViewController *_placeController = [[KZPlaceViewController alloc] initWithPlace:_place];
	
	//[self.navigationController setNavigationBarHidden:NO];
	//self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
	//self.navigationController.navigationBar.tintColor = [UIColor blackColor];
	
	//[self.navigationController setToolbarHidden:NO];
	//self.navigationController.toolbar.barStyle = UIBarStyleBlackOpaque;
	//self.navigationController.toolbar.tintColor = [UIColor blackColor];
	
	/*
	//UIBarButtonItem *_backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
	//self.navigationItem.backBarButtonItem = _backButton;
	//[_backButton release];
	 */
    [self.navigationController pushViewController:_placeController animated:YES];
    [_placeController release];
}


- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	[searchBar resignFirstResponder];
	[placesArchive requestPlacesWithKeywords:searchBar.text];
}

- (void) snap_action:(id) sender {
	[searchBar resignFirstResponder];
	ZXingWidgetController *widController = [[ZXingWidgetController alloc] initWithDelegate:self showCancel:YES OneDMode:NO];
	QRCodeReader* qrcodeReader = [[QRCodeReader alloc] init];
	NSSet *readers = [[NSSet alloc ] initWithObjects:qrcodeReader,nil];
	[qrcodeReader release];
	widController.readers = readers;
	[readers release];
	widController.soundToPlay = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"beep-beep" ofType:@"aiff"] isDirectory:NO];
	[self presentModalViewController:widController animated:YES];
	[widController release];
}

- (void)zxingController:(ZXingWidgetController*)controller didScanResult:(NSString *)result
{
    [KZApplication handleScannedQRCard:result withPlace:nil withDelegate:nil];
	//[[KZApplication getAppDelegate].navigationController setNavigationBarHidden:NO animated:NO];
	//[[KZApplication getAppDelegate].navigationController setToolbarHidden:NO animated:NO];
    [self dismissModalViewControllerAnimated:YES];
}


- (void)zxingControllerDidCancel:(ZXingWidgetController*)controller
{
	//[[KZApplication getAppDelegate].navigationController setNavigationBarHidden:NO animated:NO];
	//[[KZApplication getAppDelegate].navigationController setToolbarHidden:NO animated:NO];
    [self dismissModalViewControllerAnimated:YES];
}




- (void) logout_action:(id)sender {
	[searchBar resignFirstResponder];
	[[FacebookWrapper shared] logout];
	LoginViewController *loginViewController = [[KZApplication getAppDelegate] loginViewController];
	NSString *str_url = [NSString stringWithFormat:@"%@/users/sign_out.xml?auth_token=%@", API_URL, [KZApplication getAuthenticationToken]];
	NSURL *_url = [NSURL URLWithString:str_url];
    KZURLRequest *req = [[KZURLRequest alloc] initRequestWithURL:_url delegate:nil headers:nil];
	[req autorelease];
	
	[KZApplication setUserId:nil];
	[KZApplication setAuthenticationToken:nil];
	
	[KZApplication persistLogout];
	UIWindow *window = [[[KZApplication getAppDelegate] window] retain];
	
	[[KZApplication getAppDelegate].navigationController.view removeFromSuperview];
	[window addSubview:[loginViewController view]];
    [window makeKeyAndVisible];
	[window release];
}

//------------------------------------
// IBAction methods
//------------------------------------
#pragma mark - IBAction methods

- (IBAction) didTapCityButton:(id)theSender
{
    CBCitySelectorViewController *_controller = [[CBCitySelectorViewController alloc] initWithNibName:@"CBCitySelectorView"
                                                                                               bundle:nil];
    
    CATransition *_transition = [CATransition animation];
    _transition.duration = 0.35;
    _transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    _transition.type = kCATransitionMoveIn;
    _transition.subtype = kCATransitionFromBottom;
    
    [self.navigationController.view.layer addAnimation:_transition forKey:kCATransition];
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:_controller animated:NO];
    
    [_controller release];
}

@end
