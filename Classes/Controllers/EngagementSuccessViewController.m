//
//  EngagementSuccessViewController.m
//  Cashbury
//
//  Created by Basayel Said on 3/21/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import "EngagementSuccessViewController.h"
#import "KZApplication.h"
#import "FacebookWrapper.h"
#import "KZRewardViewController.h"

@implementation EngagementSuccessViewController

@synthesize lblBusinessName, lblBranchAddress, lblTime, lblPoints, share_string;

/*
- (id) init {
	self = [super init];
	if (self != nil) {
		self.view = [[UIView alloc] ini
	}
	return self;
}
*/
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	[viewReceipt setHidden:YES];
}
	
- (void) viewDidAppear:(BOOL)animated {
	CGRect frame = self.view.frame;
	CGPoint origin;
	int old_y = viewReceipt.center.y; 
	origin.x = viewReceipt.center.x;
	origin.y = viewReceipt.center.y*3;
	[viewReceipt setCenter:origin];
	[viewReceipt setHidden:NO];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1];
	origin.y = old_y;
	[viewReceipt setCenter:origin];
	[UIView commitAnimations];
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


- (IBAction) clear_btn:(id)sender {
	UINavigationController *nav = [KZApplication getAppDelegate].navigationController;
	[nav setToolbarHidden:NO animated:NO];
	[nav setNavigationBarHidden:NO animated:NO];
	[nav popViewControllerAnimated:YES];
}

- (IBAction) share_btn:(id)sender {
	[FacebookWrapper setPublishDelegate:self];
	[[FacebookWrapper shared] publishStreamWithText:self.share_string andCaption:lblBusinessName.text];
}


- (void) didPublish {
	NSLog(@"Published");
}

@end
