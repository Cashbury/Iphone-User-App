//
//  CBCitySelectorController.m
//  Cashbury
//
//  Created by Rami on 17/5/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import "CBCitySelectorViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "KZPlacesViewController.h"
#import "CBWalletSettingsViewController.h"
#import "NSBundle+Helpers.h"

@implementation CBCitySelectorCell

@synthesize cityFlag, cityLabel;

+ (CBCitySelectorCell *) citySelectorCellWithName:(NSString *)theCityName flagURL:(NSURL *)theFlagURL
{
    CBCitySelectorCell *_cell = [[NSBundle mainBundle] loadObjectFromNibNamed:@"CBCitySelectorCell"
                                                                        class:[CBCitySelectorCell class]
                                                                        owner:self
                                                                      options:nil];
    
    _cell.cityLabel.text = theCityName;
    _cell.cityFlag.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:theFlagURL]];
    
    return _cell;
}

- (void) dealloc
{
    [cityFlag release];
    [cityLabel release];
    
    [super dealloc];
}

@end

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
	
	self.navigationController.navigationBar.tintColor = [UIColor blackColor];
	// these 3 lines
    UIButton *_settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _settingsButton.frame = CGRectMake(0, 0, 320, 44);
    [_settingsButton addTarget:self action:@selector(didTapSettingsButton:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = _settingsButton;
	
	[self.navigationItem setLeftBarButtonItem:[[[UIBarButtonItem alloc] initWithCustomView:[[UIView new] autorelease]] autorelease]];
    
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

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:YES];
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
    //self.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:_controller animated:NO];
    
    [_controller release];
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
    //self.navigationController.navigationBarHidden = YES;
    [self.navigationController popViewControllerAnimated:NO];
}


//------------------------------------
// UITableViewDataSource methods
//------------------------------------
#pragma mark -
#pragma mark UITableViewDataSource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CBCitySelectorCell *cell = (CBCitySelectorCell *) [tableView dequeueReusableCellWithIdentifier:@"city_cell"];
    
	if (cell == nil)
    {
        cell = [[NSBundle mainBundle] loadObjectFromNibNamed:@"CBCitySelectorCell"
                                                       class:[CBCitySelectorCell class]
                                                       owner:self
                                                     options:nil];
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
	}
    
    NSArray *_cities = [cities allKeys];
    
    if ([_cities count] > indexPath.row)
    {
		NSString* city_id = [_cities objectAtIndex:indexPath.row];
        NSString *_cityName = (NSString *) [cities valueForKey:city_id];
        
        NSString *_flagURLString = (NSString *) [flags_urls valueForKey:city_id];
        
		if ([KZCity isSelectedCity:city_id]) {
			UIImageView *img;
			img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right-y.png"]];
			[img setTag:110];
			img.backgroundColor = [UIColor clearColor];
			img.opaque = NO;
			
			[cell addSubview:img];
			CGPoint origin;// [gesture locationInView:[self superview]];
			origin.x = cell.frame.size.width - 35;
			origin.y = (int)(cell.frame.size.height/2);
			
			[img setCenter:origin];
			cell.accessoryType = UITableViewCellAccessoryNone;
			[img release];
		} else {
			UIView *img = [cell viewWithTag:110];
			if (img != nil) {
				[img removeFromSuperview];
			}
		}
        cell.cityLabel.text = _cityName;
        
        if (_flagURLString)
        {
            NSURL *_flagURL = [NSURL URLWithString:_flagURLString];
            cell.cityFlag.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:_flagURL]];
        }
        else
        {
            cell.cityFlag.image = nil;
        }
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
	//[self.tbl_cities reloadData];
	[self close:nil];
}


//------------------------------------
// CitiesDelegate methods
//------------------------------------
#pragma mark - CitiesDelegate methods

- (void) gotCities:(NSMutableDictionary *)_cities andFlags:(NSDictionary*)_flags_urls
{
    cities = _cities;
    flags_urls = _flags_urls;
    [self.tbl_cities reloadData];
}

- (void) gotError:(NSString*)_error
{
    
}

@end
