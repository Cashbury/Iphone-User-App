    //
//  MapViewController.m
//  Cashbury
//
//  Created by Basayel Said on 4/27/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import "MapViewController.h"
#import "KZPlace.h"
#import "KZApplication.h"

@implementation MapViewController

@synthesize mapView, directionsButton, parentController, place_btn, other_btn;

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
	[addAnnotation setTitle:place.business.name andSubtitle:place.name];
	[mapView addAnnotation:addAnnotation];
	[mapView setRegion:region animated:TRUE];
	[mapView regionThatFits:region];
	
    UIImage *buttonImagePressed = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretchableButtonImagePressed = [buttonImagePressed stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[directionsButton setBackgroundImage:stretchableButtonImagePressed forState:UIControlStateNormal];
    
    buttonImagePressed = [UIImage imageNamed:@"blueButton.png"];
	stretchableButtonImagePressed = [buttonImagePressed stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    [directionsButton setBackgroundImage:stretchableButtonImagePressed forState:UIControlStateHighlighted];
    
	[self.place_btn setTitle:[NSString stringWithFormat:@"%@ \\ Map", place.business.name] forState:UIControlStateNormal];
    //////////////////////////////////////////////////////
	/*
	UIFont *myFont = [UIFont boldSystemFontOfSize:22.0];	
	CGSize size = [place.business.name sizeWithFont:myFont forWidth:190.0 lineBreakMode:UILineBreakModeTailTruncation];
	
	[self.place_btn setTitle:place.business.name forState:UIControlStateNormal];
	CGRect other_frame = self.other_btn.frame;
	other_frame.origin.x = 50 + size.width;
	CGRect place_frame = self.place_btn.frame;
	place_frame.size.width = size.width;
	self.other_btn.frame = other_frame;
	self.place_btn.frame = place_frame;
	*/
	//////////////////////////////////////////////////////
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
    self.directionsButton = nil;
    self.parentController = nil;
    self.place_btn = nil;
    self.other_btn = nil;
    [super viewDidUnload];
	// Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[place release];
	[mapView release];
    [directionsButton release];
    [parentController release];
    [place_btn release];
    [other_btn release];
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

- (IBAction)goBackToPlace:(id)theSender {
	[self dismissModalViewControllerAnimated:NO];
    //[parentController didTapBackButton:nil];
}

- (IBAction)goBacktoPlaces:(id)theSender {
	[self dismissModalViewControllerAnimated:NO];
    [parentController goBacktoPlaces:nil];
}

@end
