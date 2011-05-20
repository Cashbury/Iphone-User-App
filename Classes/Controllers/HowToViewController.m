//
//  HowToViewController.m
//  Cashbery
//
//  Created by Basayel Said on 5/17/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import "HowToViewController.h"
#import "KZApplication.h"


@implementation HowToViewController
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		// Initialization code
	}
	return self;
}
*/
@synthesize how_to_earn_view, how_to_snap_view, txt_how_to_earn, place_btn, other_btn, reward;

- (id) initWithReward:(KZReward*)_reward {
	if (self = [super initWithNibName:@"HowTo" bundle:nil]) {
		self.reward = _reward;
	}
	return self;
}

/*
 Implement loadView if you want to create a view hierarchy programmatically
- (void)loadView {
}
 */


// If you need to do additional setup after loading the view, override viewDidLoad.
- (void)viewDidLoad {
	[super viewDidLoad];
	//////////////////////////////////////////////////////
	UIFont *myFont = [UIFont boldSystemFontOfSize:22.0];	
	CGSize size = [self.reward.place.businessName sizeWithFont:myFont forWidth:190.0 lineBreakMode:UILineBreakModeTailTruncation];
	
	[self.place_btn setTitle:self.reward.place.businessName forState:UIControlStateNormal];
	CGRect other_frame = self.other_btn.frame;
	other_frame.origin.x = 50 + size.width;
	CGRect place_frame = self.place_btn.frame;
	place_frame.size.width = size.width;
	self.other_btn.frame = other_frame;
	self.place_btn.frame = place_frame;
	
	//////////////////////////////////////////////////////
}
 


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}

/*
- (void)dealloc {
	[super dealloc];
}
*/

- (IBAction)didTapBackButton:(id)theSender
{
    [self dismissModalViewControllerAnimated:YES];
}


- (IBAction)goBacktoPlaces:(id)theSender {
	[self dismissModalViewControllerAnimated:YES];
	[[KZApplication getAppDelegate].navigationController popViewControllerAnimated:YES];
}

- (void) showHowToSnap {
	self.how_to_earn_view.hidden = YES;
	self.how_to_snap_view.hidden = NO;
}

- (void) showHowToEarnPoints {
	self.how_to_earn_view.hidden = NO;
	self.how_to_snap_view.hidden = YES;
	self.txt_how_to_earn.text = self.reward.how_to_get_amount;
}

@end
