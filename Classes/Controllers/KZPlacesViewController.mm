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
#import "KZSnapController.h"
#import "KZCardsAtPlacesViewController.h"
#import "KZPlaceGrandCentralViewController.h"


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
	
	// yellow setting bar
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
	[[KZApplication getAppDelegate].tool_bar_vc showToolBar:self.navigationController];
}

- (void)viewDidUnload {
    [super viewDidUnload];
	self.table_view = nil;
    self.cityLabel = nil;
    self.tvCell = nil;
    self.searchBar = nil;
}

- (void) viewDidAppear:(BOOL)animated {
	self.cityLabel.text = [KZCity getSelectedCityName];
    UITableView *_tableView = self.table_view;
	NSArray *_places = [KZPlacesLibrary getPlaces];
    is_visible = YES;
}

- (void) viewDidDisappear:(BOOL)animated {
	is_visible = NO;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
	[self.table_view reloadData];
	[[KZApplication getAppDelegate].tool_bar_vc showToolBar:self.navigationController];
}


//------------------------------------
// KZPlacesLibraryDelegate methods
//------------------------------------
#pragma mark -
#pragma mark KZPlacesLibraryDelegate methods

- (void) didUpdatePlaces {
	[KZApplication hideLoading];
	[table_view reloadData];
	if (![[KZApplication getAppDelegate].navigationController.viewControllers containsObject:self]) {
		[[KZApplication getAppDelegate].navigationController pushViewController:self animated:YES];
	}
	if (!is_visible) {
		[[KZApplication getAppDelegate].window addSubview:[KZApplication getAppDelegate].leather_curtain];
		[[KZApplication getAppDelegate].window addSubview:[KZApplication getAppDelegate].navigationController.view];
		[[KZApplication getAppDelegate].window makeKeyAndVisible];
	}
}

- (void) didFailUpdatePlaces {
	[KZApplication hideLoading];
}

//------------------------------------
// UITableViewDataSource methods
//------------------------------------
#pragma mark -
#pragma mark UITableViewDataSource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlacesCell"];
	
    NSArray *_places = [KZPlacesLibrary getPlaces];
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
    cell.textLabel.text = _place.business.name;
	cell.detailTextLabel.text = _place.name;
	[img release];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[KZPlacesLibrary getPlaces] count];
}

//------------------------------------
// UITableViewDelegate methods
//------------------------------------
#pragma mark -
#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [searchBar resignFirstResponder];
	[[KZApplication getAppDelegate].tool_bar_vc hideToolBar];
    KZPlace *_place = [[KZPlacesLibrary getPlaces] objectAtIndex:indexPath.row];
    
	KZPlaceGrandCentralViewController *_placeController = [[KZPlaceGrandCentralViewController alloc] initWithPlace:_place];
    ///////FIXME KZPlaceViewController *_placeController = [[KZPlaceViewController alloc] initWithPlace:_place];
	
	/*
	[UIView  beginAnimations: @"Showinfo"context: nil];
	[UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.75];
	[self.navigationController pushViewController:_placeController animated:NO];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
	[UIView commitAnimations];
	 */
	[self.navigationController pushViewController:_placeController animated:YES];
	
	
    [_placeController release];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	[self.searchBar resignFirstResponder];
	[[KZPlacesLibrary shared] requestPlacesWithKeywords:self.searchBar.text];
}

- (void) snap_action:(id) sender {
	[searchBar resignFirstResponder];
	[KZSnapController snapInPlace:nil];
}

//------------------------------------
// Actions
//------------------------------------
#pragma mark - Actions

- (void) didTapCityButton:(UIGestureRecognizer *)theRecognizer {
	[[KZApplication getAppDelegate].tool_bar_vc hideToolBar];
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
	[[KZApplication getAppDelegate].tool_bar_vc hideToolBar];
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

- (IBAction) didTapCardsButton {
	
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
