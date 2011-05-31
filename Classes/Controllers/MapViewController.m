    //
//  MapViewController.m
//  Cashbury
//
//  Created by Basayel Said on 4/27/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import "MapViewController.h"
#import "KZPlace.h"

@implementation MapViewController

@synthesize mapView;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

- (id) initWithPlace:(KZPlace*)_place {
	if (self = [super initWithNibName:@"MapView" bundle:nil]) {
		place = [_place retain];
	}
	return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	CLLocationCoordinate2D location;
    location.latitude = place.latitude;
    location.longitude = place.longitude;
	
	MKCoordinateRegion region;
	MKCoordinateSpan span;
	span.latitudeDelta = 0.005139;
	span.longitudeDelta = 0.009645;
	
	region.span = span;
	region.center = location;	
	AddressAnnotation *addAnnotation = [[AddressAnnotation alloc] initWithCoordinate:location];
	[addAnnotation setTitle:place.businessName andSubtitle:place.name];
	[mapView addAnnotation:addAnnotation];
	[mapView setRegion:region animated:TRUE];
	[mapView regionThatFits:region];
	
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	self.mapView = nil;
    [super viewDidUnload];
	// Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[place release];
	[mapView release];
    [super dealloc];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://maps.google.com/?ie=UTF8&ll=%lf,%lf&spn=0.005139,0.009645&z=16", place.latitude, place.longitude]]];
	}
}

- (IBAction)showGoogleMapsButton:(id)theSender {
	if (place.latitude > 0 || place.longitude > 0) { 
		UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:@"This will quit Cashbury and open Google maps." delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
		[menu setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
		
		[menu addButtonWithTitle:@"Open Google Maps"];
		[menu addButtonWithTitle:@"Cancel"];
		menu.cancelButtonIndex = 1;
		
		[menu showInView:self.view];
		[menu release];
	}
}

- (IBAction)doClose:(id)theSender {
	[self dismissModalViewControllerAnimated:YES];
}

@end
