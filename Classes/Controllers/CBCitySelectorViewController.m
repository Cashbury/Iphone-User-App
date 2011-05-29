//
//  CBCitySelectorController.m
//  Cashbery
//
//  Created by Rami on 17/5/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import "CBCitySelectorViewController.h"
#import <QuartzCore/QuartzCore.h>


@implementation CBCitySelectorViewController

@synthesize cancelButton, tbl_cities, currentCityLabel;

//------------------------------------
// Init & dealloc
//------------------------------------
#pragma mark - Init & dealloc

- (void)dealloc
{
    [cancelButton release];
    [tbl_cities release];
    [cityBank release];
    [currentCityLabel release];
    
    [super dealloc];
}

//------------------------------------
// UIViewController methods
//------------------------------------
#pragma mark - UIViewController methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *_buttonImage = [UIImage imageNamed:@"background-button.png"];
    UIImage *_stretchableButtonImage = [_buttonImage stretchableImageWithLeftCapWidth:5 topCapHeight:0];
    
    [cancelButton setBackgroundImage:_stretchableButtonImage forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:_stretchableButtonImage forState:UIControlStateHighlighted];
    
    [self.cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    
    // Label the current city
    self.currentCityLabel.indicatorImage = [UIImage imageNamed:@"image-dropdown-highlighted.png"];
    
    self.currentCityLabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *_recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close:)];
    [self.currentCityLabel addGestureRecognizer:_recognizer];
    [_recognizer release];

    self.currentCityLabel.text = [KZCity getSelectedCityName];
    
    // Request a list of cities
    cityBank = [[KZCity alloc] init];
    [cityBank getCitiesFromServer:self];
    cities = [[NSDictionary alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.cancelButton = nil;
    self.tbl_cities = nil;
    self.currentCityLabel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//------------------------------------
// IBAction methods
//------------------------------------
#pragma mark - IBAction methods

- (IBAction) close:(id)theSender
{
    CATransition *_transition = [CATransition animation];
    _transition.duration = 0.35;
    _transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    _transition.type = kCATransitionPush;
    _transition.subtype = kCATransitionFromTop;
    
    [self.navigationController.view.layer addAnimation:_transition forKey:kCATransition];
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController popViewControllerAnimated:NO];
}


//------------------------------------
// UITableViewDataSource methods
//------------------------------------
#pragma mark -
#pragma mark UITableViewDataSource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"city_cell"];
    
	if (cell == nil)
    {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"city_cell"] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
	}
    
    NSArray *_cities = [cities allValues];
    if ([_cities count] > indexPath.row)
    {
        NSString *_cityName = (NSString *) [_cities objectAtIndex:indexPath.row];
        cell.textLabel.text = _cityName;
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [cities count];
}

//------------------------------------
// UITableViewDelegate methods
//------------------------------------
#pragma mark -
#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.currentCityLabel.text = (NSString *) [[cities allValues] objectAtIndex:indexPath.row];
    
    NSString *_id = (NSString *) [[cities allKeys] objectAtIndex:indexPath.row];
    
    [KZCity setSelectedCityId:_id];
}


//------------------------------------
// CitiesDelegate methods
//------------------------------------
#pragma mark - CitiesDelegate methods

- (void) gotCities:(NSMutableDictionary *)_cities
{
    cities = _cities;
    
    [self.tbl_cities reloadData];
}

- (void) gotError:(NSString*)_error
{
    
}

@end
