    //
//  GrantViewController.m
//  Cashbury
//
//  Created by Basayel Said on 3/22/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import "GrantViewController.h"
#import "KZApplication.h"
#import "FacebookWrapper.h"

@implementation GrantViewController


@synthesize lblBusinessName, lblBranchAddress, lblReward, lblTime, lblName, viewReceipt, share_string, img_register;

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
	[self performSelector:@selector(animationDone) withObject:nil afterDelay:1.0];
}

- (void) animationDone {
	[self.img_register setImage:[UIImage imageNamed:@"BottomBarGreen.png"]];
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
	[self dismissModalViewControllerAnimated:YES];
	[[KZApplication getAppDelegate].navigationController popViewControllerAnimated:YES];
}

- (IBAction) share_btn:(id)sender {
	[FacebookWrapper setPublishDelegate:self];
	[[FacebookWrapper shared] publishStreamWithText:self.share_string andCaption:lblBusinessName.text andImage:nil];
}

- (void) didPublish {
	NSLog(@"Published");
}

@end
