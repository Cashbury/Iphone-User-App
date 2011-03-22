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

@implementation KZPlacesViewController



@synthesize tvCell;
//------------------------------------
// Init & dealloc
//------------------------------------
#pragma mark -
#pragma mark Init & dealloc

- (void) dealloc
{
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
	[self.navigationController setNavigationBarHidden:NO];
	self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
	self.navigationController.navigationBar.tintColor = [UIColor blackColor];
	self.title = @"Places";
	//[self.navigationController.navigationBar set
	UIImage *img = [UIImage imageNamed:@"btn-SnapitYellow.png"];
	UIButton *custom_btn = [UIButton buttonWithType:UIButtonTypeCustom];
	self.navigationController.toolbar.tintColor = [UIColor blackColor];
	custom_btn.frame = CGRectMake(0, 0, img.size.width, img.size.height);
	[custom_btn setImage:[UIImage imageNamed:@"btn-SnapitYellow.png"] forState:UIControlStateNormal];
	UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	
	UIBarButtonItem *_logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(logout_action:)];
	self.navigationItem.rightBarButtonItem = _logoutButton;
	[_logoutButton release];
	
	UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithCustomView:custom_btn];
	[custom_btn addTarget:self action:@selector(snap_action:) forControlEvents:UIControlEventTouchUpInside]; 
	NSMutableArray *arr = [NSMutableArray arrayWithObjects:flexibleSpace, btn, flexibleSpace, nil];
	self.toolbarItems = arr;
	
	[self.navigationController setToolbarHidden:NO animated:NO];
	
	[btn release];
	[flexibleSpace release];
    placesArchive = [[KZApplication shared] placesArchive];
    placesArchive.delegate = self;
    
    [placesArchive requestPlaces];
	
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

//------------------------------------
// KZPlacesLibraryDelegate methods
//------------------------------------
#pragma mark -
#pragma mark KZPlacesLibraryDelegate methods

- (void) didUpdatePlaces
{
	NSLog(@"\nDID UPDATE PLACES\n");
    UITableView *_tableView = (UITableView*) self.view;
	_places = [placesArchive places];
	NSLog(@",,, %d\n", [_places count]);
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
	//NSLog(@"<<< %@ >>>", (KZPlace*)[_places objectAtIndex:0].name);
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
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"PlacesCell"];
    }
	UIImageView *img;
	if ([_place hasAutoUnlockReward]) {
		img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn-Reward.png"]];
	} else {
		img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn-Reward-Gray.png"]];
	}
    [cell addSubview:img];
	CGPoint origin;// [gesture locationInView:[self superview]];
	origin.x = cell.frame.size.width - 60;
	origin.y = (int)cell.frame.size.height/2;
	
	[img setCenter:origin];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = _place.name;
	cell.detailTextLabel.text = _place.address;//([_place hasAutoUnlockReward] ? @"Get Reward" : @"");
    /*
	 
	 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	 if (cell == nil) {
	 [[NSBundle mainBundle] loadNibNamed:@"TVCell" owner:self options:nil];
	 cell = tvCell;
	 self.tvCell = nil;
	 }
	 UILabel *label;
	 label = (UILabel *)[cell viewWithTag:1];
	 label.text = [NSString stringWithFormat:@"%d", indexPath.row];
	 
	 label = (UILabel *)[cell viewWithTag:2];
	 label.text = [NSString stringWithFormat:@"%d", NUMBER_OF_ROWS - indexPath.row];
	 
	 return cell;
	 }
	 */
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
    
    
    KZPlace *_place = [[placesArchive places] objectAtIndex:indexPath.row];
    
    KZPlaceViewController *_placeController = [[KZPlaceViewController alloc] initWithPlace:_place];
	
	[self.navigationController setNavigationBarHidden:NO];
	self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
	self.navigationController.navigationBar.tintColor = [UIColor blackColor];
	
	[self.navigationController setToolbarHidden:NO];
	self.navigationController.toolbar.barStyle = UIBarStyleBlackOpaque;
	self.navigationController.toolbar.tintColor = [UIColor blackColor];
	
	
	UIBarButtonItem *_backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
	self.navigationItem.backBarButtonItem = _backButton;
	[_backButton release];

    [self.navigationController pushViewController:_placeController animated:YES];
    [_placeController release];
}




- (void) snap_action:(id) sender {
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
	[[KZApplication getAppDelegate].navigationController setNavigationBarHidden:NO animated:NO];
	[[KZApplication getAppDelegate].navigationController setToolbarHidden:NO animated:NO];
    [self dismissModalViewControllerAnimated:YES];
}


- (void)zxingControllerDidCancel:(ZXingWidgetController*)controller
{
	[[KZApplication getAppDelegate].navigationController setNavigationBarHidden:NO animated:NO];
	[[KZApplication getAppDelegate].navigationController setToolbarHidden:NO animated:NO];
    [self dismissModalViewControllerAnimated:YES];
}




- (void) logout_action:(id)sender {
	LoginViewController *loginViewController = [[KZApplication getAppDelegate] loginViewController];
	NSString *str_url = [NSString stringWithFormat:@"%@/users/sign_out.xml?auth_token=%@", API_URL, [KZApplication getAuthenticationToken]];
	NSURL *_url = [NSURL URLWithString:str_url];
    KZURLRequest *req = [[KZURLRequest alloc] initRequestWithURL:_url delegate:nil headers:nil];
	[req release];
	
	[KZApplication setUserId:nil];
	[KZApplication setAuthenticationToken:nil];
	
	[[FacebookWrapper shared] logout];
	
	UIWindow *window = [[[KZApplication getAppDelegate] window] retain];
	
	int upper_bound = [[window subviews] count] - 1;
	UIView *v = [[window subviews] objectAtIndex:upper_bound];
	[v removeFromSuperview];
	[window addSubview:[loginViewController view]];
    [window makeKeyAndVisible];
	[window release];
}


@end
