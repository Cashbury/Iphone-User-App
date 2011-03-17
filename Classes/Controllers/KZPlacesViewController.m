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

@implementation KZPlacesViewController

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
	self.title = @"Cashbury Places";
	
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
    UITableView *_tableView = (UITableView*) self.view;
	_places = [placesArchive places];
    [_tableView reloadData];
}

- (void) didFailUpdatePlaces
{
}

//------------------------------------
// UITableViewDataSource methods
//------------------------------------
#pragma mark -
#pragma mark UITableViewDataSource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *_cell = [tableView dequeueReusableCellWithIdentifier:@"PlacesCell"];
    
    KZPlace *_place = [_places objectAtIndex:indexPath.row];
    
    if (_cell == nil)
    {
        _cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PlacesCell"];
    }
    
    _cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    _cell.textLabel.text = _place.name;
    
    return _cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[placesArchive places] count];
}

//------------------------------------
// UITableViewDelegate methods
//------------------------------------
#pragma mark -
#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *_places = [placesArchive places];
    
    KZPlace *_place = [_places objectAtIndex:indexPath.row];
    
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


@end
