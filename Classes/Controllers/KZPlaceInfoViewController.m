    //
//  KZPlaceInfoViewController.m
//  Kazdoor
//
//  Created by Rami on 11/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "KZPlaceInfoViewController.h"


@implementation KZPlaceInfoViewController

@synthesize nameLabel, streetLabel, addressLabel, navItem;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil place:(KZPlace *)thePlace
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        place = [thePlace retain];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navItem.title = place.name;
    self.nameLabel.text = place.name;
    self.streetLabel.text = place.address;
    self.addressLabel.text = [NSString stringWithFormat:@"%@, %@, %@", place.city, place.country, place.zipcode];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    self.nameLabel = nil;
    self.streetLabel = nil;
    self.addressLabel = nil;
    self.navItem = nil;
}


- (IBAction)didTapBackButton:(id)theSender
{
    [self dismissModalViewControllerAnimated:YES];
}


- (void)dealloc
{
    [nameLabel release];
    [streetLabel release];
    [addressLabel release];
    [navItem release];
    
    [place release];
    
    [super dealloc];
}


@end
