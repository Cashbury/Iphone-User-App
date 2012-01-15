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
#import "CocoaQRCodeReader.h"
#import "LoginViewController.h"
#import "KZOpenHours.h"
#import "CBCitySelectorViewController.h"
#import "CBWalletSettingsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "KZCity.h"
#import "KZSnapController.h"
#import "KZCardsAtPlacesViewController.h"
#import "KZPlaceGrandCentralViewController.h"

@implementation KZPlacesViewController

@synthesize table_view, cityLabel;
@synthesize doneButton, delegate;

//------------------------------------
// Init & dealloc
//------------------------------------

#pragma mark - Init & dealloc

- (void) dealloc
{
    [cityLabel release];
	[table_view release];
    [doneButton release];
    
    [super dealloc];
}

//------------------------------------
// UIViewController methods
//------------------------------------
#pragma mark - UIViewController methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.delegate = self;
    
    // Set up done button
    UIImage *_buttonImage = [UIImage imageNamed:@"background-button.png"];
    UIImage *_stretchableButtonImage = [_buttonImage stretchableImageWithLeftCapWidth:5 topCapHeight:0];
    [doneButton setBackgroundImage:_stretchableButtonImage forState:UIControlStateNormal];
    [doneButton setBackgroundImage:_stretchableButtonImage forState:UIControlStateHighlighted];
    [self.doneButton setTitle:@"Back" forState:UIControlStateNormal];

    // Set up city label
    self.cityLabel.indicatorImage = [UIImage imageNamed:@"image-dropdown.png"];    
    self.cityLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *_recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapCityButton:)];
    [self.cityLabel addGestureRecognizer:_recognizer];
    [_recognizer release];
    
    // Listen to when the selected city changes
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didChangeSelectedCity:)
                                                 name:KZCityDidChangeSelectedCityNotification
                                               object:nil];
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.doneButton = nil;
	self.table_view = nil;
    self.cityLabel = nil;
    
    [super viewDidUnload];
}

//------------------------------------
// KZPlacesLibraryDelegate methods
//------------------------------------
#pragma mark - KZPlacesLibraryDelegate methods

- (void) didUpdatePlaces
{
	[KZApplication hideLoading];
    
	[table_view reloadData];
}

- (void) didFailUpdatePlaces
{
	[KZApplication hideLoading];
}

//------------------------------------
// UITableViewDataSource methods
//------------------------------------
#pragma mark - UITableViewDataSource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    
    // Prepare balance label
    CGRect _frame = CGRectMake(320-160, 5, 140, tableView.rowHeight - 10);
    UILabel *_balanceLabel = [[UILabel alloc] initWithFrame:_frame];
    
    _balanceLabel.tag = 213;
    _balanceLabel.adjustsFontSizeToFitWidth = NO;
    _balanceLabel.textAlignment = UITextAlignmentRight;
    _balanceLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    _balanceLabel.textColor = [UIColor grayColor];
    
    // Load the balance
    KZBusiness *_busines = _place.business;
    float _balance = [_busines getScore];
	NSString *_currency = [_busines getCurrencyCode];
    
    _balanceLabel.text = (_currency) ? [NSString stringWithFormat:@"%@%1.2f", _currency, _balance] : @"$0.00";
    
    [cell insertSubview:_balanceLabel atIndex:0];
    
    CGPoint _origin;
    _origin.x = cell.frame.size.width - 80;
    _origin.y = (int)(cell.frame.size.height/2);	
    _balanceLabel.center = _origin;
	
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.text = _place.business.name;
	cell.detailTextLabel.text = _place.name;
	
    return cell;
}

- (void) cashburies_button_touched:(id)_sender
{
	UIButton* btn = ((UIButton*)_sender);
    
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[KZPlacesLibrary getPlaces] count];
}

//------------------------------------
// UITableViewDelegate methods
//------------------------------------
#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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

//------------------------------------
// Actions
//------------------------------------
#pragma mark - Actions

- (void) didChangeSelectedCity:(NSNotification *)theNotification
{
    self.cityLabel.text = [KZCity getSelectedCityName];
}

- (void) didTapCityButton:(UIGestureRecognizer *)theRecognizer
{
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

- (IBAction) didTapCardsButton
{
	
}

//------------------------------------
// KZPlacesLibraryDelegate methods
//------------------------------------
#pragma mark - KZPlacesLibraryDelegate methods

- (void)navigationController:(UINavigationController *)theNavigationController
      willShowViewController:(UIViewController *)theViewController
                    animated:(BOOL)isAnimated
{
    if (theNavigationController == self.navigationController && theViewController == self)
    {
        self.navigationController.navigationBarHidden = YES;
        
        self.cityLabel.text = [KZCity getSelectedCityName];
        
        [KZPlacesLibrary shared].delegate = self;
        [[KZPlacesLibrary shared] requestPlacesWithKeywords:nil];
        [KZApplication showLoadingScreen:@"Loading Places"];
    }
}

@end
