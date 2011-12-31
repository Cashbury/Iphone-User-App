    //
//  DummySplashViewController.m
//  Cashbery
//
//  Created by Basayel Said on 6/13/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import "DummySplashViewController.h"


@implementation DummySplashViewController

@synthesize lbl_loadong, activity_indicator;

- (void) setLoadingMessage:(NSString*)str_message {
	self.lbl_loadong.text = str_message;
}


- (id) initWithMessage:(NSString*)_message {
	if (self = [self initWithNibName:@"DummySplashView" bundle:nil]) {
		[self setLoadingMessage:_message];
		return self;
	}
	return nil;
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
*/

- (void) viewWillAppear:(BOOL)isAnimated
{
    [super viewWillAppear:isAnimated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void) viewDidAppear:(BOOL)animated {
	[self.activity_indicator startAnimating];
}

- (void) viewWillDisappear:(BOOL)animated {
	[self.activity_indicator stopAnimating];
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


@end
