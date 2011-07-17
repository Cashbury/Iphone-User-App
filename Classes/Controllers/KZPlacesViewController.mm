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
	self.navigationController.navigationBar.tintColor = [UIColor blackColor];
	
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
	
	UIView* v = [cell viewWithTag:213];
	if (v != nil) {
		[v removeFromSuperview];
	}
	
	if ([[_place getRewards] count] > 0) {
		UIImageView *img;
		if ([_place hasAutoUnlockReward]) {
			img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn-reward_green.png"]];
		} else {
			img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn-reward_gray.png"]];
		}
		[img setTag:213];
		
		
		img.backgroundColor = [UIColor clearColor];
		img.opaque = NO;
		[cell addSubview:img];	// the image to the view
		CGPoint origin;// [gesture locationInView:[self superview]];
		origin.x = cell.frame.size.width - 55;
		origin.y = (int)(cell.frame.size.height/2);	
		[img setCenter:origin];
		
		//add the button
		UIButton* btn = [[UIButton alloc] initWithFrame:img.frame];
		[btn addTarget:self action:@selector(cashburies_button_touched:) forControlEvents:UIControlEventTouchUpInside];
		btn.tag = indexPath.row;
		[cell addSubview:btn];
		
		
		[img release];
	}
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.text = _place.business.name;
	cell.detailTextLabel.text = _place.name;
	
    return cell;
}

- (void) cashburies_button_touched:(id)_sender {
	UIButton* btn = ((UIButton*)_sender);
	[[KZApplication getAppDelegate].tool_bar_vc hideToolBar];
    KZPlace *_place = [[KZPlacesLibrary getPlaces] objectAtIndex:btn.tag];
	KZPlaceGrandCentralViewController *_placeController = [[KZPlaceGrandCentralViewController alloc] initWithPlace:_place];
	KZPlaceViewController *vc = [[KZPlaceViewController alloc] initWithPlace:_place];
	_placeController.cashburies_modal = vc;
	
	vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self.navigationController pushViewController:_placeController animated:YES];
	[self presentModalViewController:vc animated:YES];
	
	/*
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.75];
    [UIView setAnimationBeginsFromCurrentState:YES];        
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:YES];
	[self.navigationController pushViewController:_placeController animated:NO];
	[self presentModalViewController:vc animated:NO];
    [UIView commitAnimations];
	 */
	
	[_placeController release];
	[vc release];
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
    // KZPlaceViewController *_placeController = [[KZPlaceViewController alloc] initWithPlace:_place];
	
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
