    //
//  GrantViewController.m
//  Cashbury
//
//  Created by Basayel Said on 3/22/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import "GrantViewController.h"
#import "KZApplication.h"
#import "KZUserInfo.h"
#import "FacebookWrapper.h"
#import "KZPlaceGrandCentralViewController.h"

@implementation GrantViewController


@synthesize lblBusinessName, lblBranchAddress, lblReward, lblTime, lblName, viewReceipt, share_string, img_register, biz, place, reward;

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


- (id) initWithBusiness:(KZBusiness*)_biz andPlace:(KZPlace*)_place andReward:(KZReward*)_reward {
	if (self = [self initWithNibName:@"GrantView" bundle:nil]) {
		self.biz = _biz;
		self.place = _place;
		self.reward = _reward;
	}
	return self;
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[viewReceipt setHidden:YES];
	self.lblBusinessName.text = self.biz.name;
	img_url = self.biz.image_url;
	if (self.place != nil) self.lblBranchAddress.text = self.place.address;
	self.lblName.text = [NSString stringWithFormat:@"By %@", [[KZUserInfo shared] getFullName]];
	self.share_string = self.reward.fb_enjoy_msg;//[NSString stringWithFormat:@"Just enjoyed %@ from %@", self.reward.name, self.biz.name];
	self.lblReward.text = self.reward.name;
	// set time and date
	NSDate* date = [NSDate date];
	NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"hh:mm:ss a MM.dd.yyyy"];
	NSString* str = [formatter stringFromDate:date];
	self.lblTime.text = [NSString stringWithFormat:@"Requested at %@", str];
	[formatter release];
	
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
	[self.img_register setImage:[UIImage imageNamed:@"bottom_receipt_g.png"]];
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
	//UIViewController* vc = self.parentViewController;
	//[vc dismissModalViewControllerAnimated:YES];
	UINavigationController* nav = [KZApplication getAppDelegate].navigationController;

    KZPlaceGrandCentralViewController* vc = (KZPlaceGrandCentralViewController*)nav.topViewController;
    [vc.cashburies_modal reloadView];
    
	[self dismissModalViewControllerAnimated:YES];
	//[[KZApplication getAppDelegate].navigationController popViewControllerAnimated:YES];
}

- (IBAction) share_btn:(id)sender {
	[FacebookWrapper setPublishDelegate:self];
	[[FacebookWrapper shared] publishStreamWithText:self.share_string andCaption:lblBusinessName.text andImage:img_url];
}

- (void) didPublish {
	NSLog(@"Published");
}

@end
