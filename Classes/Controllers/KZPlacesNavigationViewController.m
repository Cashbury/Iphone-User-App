    //
//  KZPlacesNavigationViewController.m
//  Cashbery
//
//  Created by Basayel Said on 6/20/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import "KZPlacesNavigationViewController.h"


@implementation KZPlacesNavigationViewController


@synthesize place_btn, other_btn;

- (id) initWithPlace:(KZPlace*)_place {
	if (self = [self initWithNibName:@"" bundle:nil]) {
		// order the buttons on the toolbar
		UIFont *myFont = [UIFont boldSystemFontOfSize:22.0];	
		CGSize size = [place.businessName sizeWithFont:myFont forWidth:190.0 lineBreakMode:UILineBreakModeTailTruncation];
		[self.place_btn setTitle:place.businessName forState:UIControlStateNormal];
		CGRect other_frame = self.other_btn.frame;
		other_frame.origin.x = 50 + size.width;
		CGRect place_frame = self.place_btn.frame;
		place_frame.size.width = size.width;
		self.other_btn.frame = other_frame;
		self.place_btn.frame = place_frame;
	}
	return self;
}

- (void) viewDidLoad {

}


- (IBAction) didTapInfoButton:(id)theSender {
	KZPlaceInfoViewController *_infoController = [[KZPlaceInfoViewController alloc] initWithNibName: @"KZPlaceInfoView" bundle: nil place: self.place];
	_infoController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:_infoController animated:YES];
	[_infoController release];
}

- (IBAction) goBack:(id)theSender {
	[self.navigationController popViewControllerAnimated:YES];
}



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

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}
*/


@end
