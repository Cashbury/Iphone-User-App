//
//  KZPlacesViewController.m
//  Kazdoor
//
//  Created by Rami on 12/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import "KZApplication.h"
#import "KZPlacesLibrary.h"
#import "KZPlacesViewController.h"
#import "KZPlaceViewController.h"
#import "KZPlace.h"
#import "KZReward.h"
#import "QRCodeReader.h"
#import "LoginViewController.h"
#import "KZOpenHours.h"
#import "UINavigationBar+CustomBackground.h"
#import "CBCitySelectorViewController.h"
#import "CBWalletSettingsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "KZCity.h"

@interface KZPlacesViewController (Private)
	- (void) didTapSettingsButton:(id)theSender;
@end


@implementation KZPlacesViewController

BOOL is_visible = NO;
static KZPlacesViewController *singleton_places_vc = nil;

@synthesize tvCell, searchBar, table_view, cityLabel;

//------------------------------------
// Init & dealloc
//------------------------------------

#pragma mark -
#pragma mark Init & dealloc

- (void) dealloc {
    self.cityLabel = nil;
	self.tvCell = nil;
	self.searchBar = nil;
	self.table_view = nil;
    [super dealloc];
}

//------------------------------------
// UIViewController methods
//------------------------------------
#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];
	//////TODO Comment these lines and uncomment the one next to them
	/*[self.navigationController setNavigationBarHidden:NO];
	self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;*/
	self.navigationController.navigationBar.tintColor = [UIColor blackColor];
	//self.title = @"Cashbury";
	//[self.navigationController setNavigationBarHidden:YES];
	
	// these 3 lines
    UIButton *_settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _settingsButton.frame = CGRectMake(0, 0, 80, 44);
    [_settingsButton addTarget:self action:@selector(didTapSettingsButton:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = _settingsButton;
	
    // Set up city label
    self.cityLabel.indicatorImage = [UIImage imageNamed:@"image-dropdown.png"];    
    self.cityLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *_recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapCityButton:)];
    [self.cityLabel addGestureRecognizer:_recognizer];
    [_recognizer release];    
}

- (void)viewDidUnload {
    [super viewDidUnload];
	self.table_view = nil;
    self.cityLabel = nil;
    self.tvCell = nil;
    self.searchBar = nil;
}

- (void) viewDidAppear:(BOOL)animated {
	//[placesArchive requestPlacesWithKeywords:searchBar.text];
	self.cityLabel.text = [KZCity getSelectedCityName];
    UITableView *_tableView = self.table_view;
	NSArray *_places = [KZPlacesLibrary places];
    is_visible = YES;
    //[self.cityLabel setText:[KZCity getSelectedCityName]];
}

- (void) viewDidDisappear:(BOOL)animated {
	is_visible = NO;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


//------------------------------------
// KZPlacesLibraryDelegate methods
//------------------------------------
#pragma mark -
#pragma mark KZPlacesLibraryDelegate methods

- (void) didUpdatePlaces {
	NSLog(@"################### didUpdatePlaces");
	[KZApplication hideLoading];
	[table_view reloadData];
	if (!is_visible) {
		[[KZApplication getAppDelegate].navigationController pushViewController:self animated:YES];
		[[KZApplication getAppDelegate].window addSubview:[[KZApplication getAppDelegate].navigationController view]];
	}
}

- (void) didFailUpdatePlaces {
	NSLog(@"####: Failed to update places.");
}

//------------------------------------
// UITableViewDataSource methods
//------------------------------------
#pragma mark -
#pragma mark UITableViewDataSource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlacesCell"];
	
    NSArray *_places = [KZPlacesLibrary places];
	KZPlace *_place = [_places objectAtIndex:indexPath.row];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"PlacesCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
	UIImageView *img;
	if ([_place hasAutoUnlockReward]) {
		img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn-reward_green.png"]];
	} else {
		img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn-reward_gray.png"]];
	}
	[img setTag:213];
	UIView* v = [cell viewWithTag:213];
	if (v != nil) {
		[v removeFromSuperview];
	}
	
	img.backgroundColor = [UIColor clearColor];
	img.opaque = NO;

    [cell addSubview:img];
	CGPoint origin;// [gesture locationInView:[self superview]];
	origin.x = cell.frame.size.width - 55;
	origin.y = (int)(cell.frame.size.height/2);
	
	[img setCenter:origin];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.text = _place.businessName;
	cell.detailTextLabel.text = _place.name;
	[img release];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[KZPlacesLibrary places] count];
}

//------------------------------------
// UITableViewDelegate methods
//------------------------------------
#pragma mark -
#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [searchBar resignFirstResponder];
	
    KZPlace *_place = [[KZPlacesLibrary places] objectAtIndex:indexPath.row];
    
    KZPlaceViewController *_placeController = [[KZPlaceViewController alloc] initWithPlace:_place];
	
    [self.navigationController pushViewController:_placeController animated:YES];
    [_placeController release];
}


- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	[self.searchBar resignFirstResponder];
	[[KZPlacesLibrary shared] requestPlacesWithKeywords:self.searchBar.text];
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

- (void)zxingController:(ZXingWidgetController*)controller didScanResult:(NSString *)result {
    [KZApplication handleScannedQRCard:result withPlace:nil withDelegate:nil];
    [self dismissModalViewControllerAnimated:YES];
}


- (void)zxingControllerDidCancel:(ZXingWidgetController*)controller {
	///////FIXME remove this line
	//[KZApplication handleScannedQRCard:@"9a3d597bdcacffe1c65b" withPlace:nil withDelegate:nil];
	[[KZApplication getAppDelegate].navigationController setNavigationBarHidden:NO animated:NO];
    [self dismissModalViewControllerAnimated:YES];
}

/*- (void) logout_action:(id)sender {
	[searchBar resignFirstResponder];
	[[FacebookWrapper shared] logout];
	LoginViewController *loginViewController = [[KZApplication getAppDelegate] loginViewController];
	NSString *str_url = [NSString stringWithFormat:@"%@/users/sign_out.xml?auth_token=%@", API_URL, [KZApplication getAuthenticationToken]];
    KZURLRequest *req = [[[KZURLRequest alloc] initRequestWithString:str_url andParams:nil delegate:nil headers:nil andLoadingMessage:@"Loading..."] autorelease];
	
	[KZApplication setUserId:nil];
	[KZApplication setAuthenticationToken:nil];
	
	[KZApplication persistLogout];
	UIWindow *window = [[[KZApplication getAppDelegate] window] retain];
	
	[[KZApplication getAppDelegate].navigationController.view removeFromSuperview];
	[window addSubview:[loginViewController view]];
    [window makeKeyAndVisible];
	[window release];
}*/

//------------------------------------
// Actions
//------------------------------------
#pragma mark - Actions

- (void) didTapCityButton:(UIGestureRecognizer *)theRecognizer {
    CBCitySelectorViewController *_controller = [[CBCitySelectorViewController alloc] initWithNibName:@"CBCitySelectorView"
                                                                                               bundle:nil];
    
    CATransition *_transition = [CATransition animation];
    _transition.duration = 0.35;
    _transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    _transition.type = kCATransitionPush;
    _transition.subtype = kCATransitionFromBottom;
    
    [self.navigationController.view.layer addAnimation:_transition forKey:kCATransition];
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:_controller animated:NO];
    
    [_controller release];
}

- (void) didTapSettingsButton:(id)theSender {
    CBWalletSettingsViewController *_controller = [[CBWalletSettingsViewController alloc] initWithNibName:@"CBWalletSettingsView"
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

- (BOOL) isVisible {
	return is_visible;
}

+ (void) showPlacesScreen {
	if (singleton_places_vc == nil) {
		singleton_places_vc = [[KZPlacesViewController alloc] initWithNibName:@"KZPlacesView" bundle:nil];
	}
	[KZPlacesLibrary shared].delegate = singleton_places_vc;
	[[KZPlacesLibrary shared] requestPlacesWithKeywords:nil];
}

@end
