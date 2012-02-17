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
#import "CBPlacesViewTableCell.h"
#import "NSBundle+Helpers.h"

@interface KZPlacesViewController (PrivateMethods)
- (NSArray *) tableCellsForBusiness:(KZBusiness *)theBusiness;
@end


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

- (void) viewDidAppear:(BOOL)isAnimated
{
    [super viewDidAppear:isAnimated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveBalance:)
                                                 name:KZBusinessBalanceNotification
                                               object:nil];
}

- (void) viewDidDisappear:(BOOL)isAnimated
{
    [super viewDidDisappear:isAnimated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KZBusinessBalanceNotification object:nil];
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
    NSArray *_places = [KZPlacesLibrary getPlaces];
	KZPlace *_place = [_places objectAtIndex:indexPath.row];
    
    CBPlacesViewTableCell *cell = (CBPlacesViewTableCell *) [tableView dequeueReusableCellWithIdentifier:@"PlacesCell"];
	
    if (cell == nil)
    {
        cell = [[NSBundle mainBundle] loadObjectFromNibNamed:@"CBPlacesViewTableCell"
                                                       class:[CBPlacesViewTableCell class]
                                                       owner:self
                                                     options:nil];
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    // Load the balance
    KZBusiness *_busines = _place.business;
    float _balance = [[_busines totalBalance] floatValue];
	NSString *_currency = [_busines getCurrencyCode];
    
    if (!_currency)
    {
        _currency = @"$";
    }
    
    cell.balanceLabel.text = [NSString stringWithFormat:@"%@%1.2f", _currency, _balance];
    
    cell.titleLabel.text = _place.business.name;
    
    [cell.placeImage loadImageWithAsyncUrl:_place.business.image_url];
    
    NSString *_detailLabelText = (_place.is_open) ? @"Open now" : @"Closed";
    
    if (_place.distance > 0.0)
    {
		if (_place.distance > 1000.0)
        {
			_detailLabelText = [_detailLabelText stringByAppendingFormat:@" - %0.1lf km away", _place.distance/1000.0];
		}
        else
        {
			_detailLabelText = [_detailLabelText stringByAppendingFormat:@" - %0.0lf meters away", _place.distance];
		}
	}
    
	cell.descriptionLabel.text = _detailLabelText;
	
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[KZPlacesLibrary getPlaces] count];
}

//------------------------------------
// UITableViewDelegate methods
//------------------------------------
#pragma mark - UITableViewDelegate methods

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
// Private methods
//------------------------------------
#pragma mark - Private methods

- (NSArray *) tableCellsForBusiness:(KZBusiness *)theBusiness
{
    NSArray *_places = [KZPlacesLibrary getPlaces];
    NSInteger _placeCount = [_places count];
    
    NSMutableArray *_rows = [[NSMutableArray alloc] init];
    
    for (int _i = 0; _i < _placeCount; _i++)
    {
        KZPlace *_place = (KZPlace *) [_places objectAtIndex:_i];
        
        if (_place.business.identifier == theBusiness.identifier)
        {
            [_rows addObject:[table_view cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_i inSection:0]]];
        }
    }
    
    return _rows;
}

//------------------------------------
// Actions
//------------------------------------
#pragma mark - Actions

- (void) didReceiveBalance:(NSNotification *)theNotification
{
    NSDictionary *_userInfo = [theNotification userInfo];
    
    KZBusiness *_business = (KZBusiness *) [theNotification object];
    
    NSString *_currency = [_business getCurrencyCode];
    
    if (!_currency)
    {
        _currency = @"$";
    }
    
    NSArray *_cells = [self tableCellsForBusiness:_business];
    
    for (CBPlacesViewTableCell *_cell in _cells)
    {
        UILabel *_balanceSubview = (UILabel *) [_cell viewWithTag:213];
        
        NSNumber *_moneyBalance = (NSNumber *) [_userInfo objectForKey:@"totalBalance"];
        float _balance = [_moneyBalance floatValue];
        
        _cell.balanceLabel.text = [NSString stringWithFormat:@"%@%1.2f", _currency, _balance];
    }
}

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
