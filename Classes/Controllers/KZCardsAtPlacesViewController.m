    //
//  KZCardsAtPlacesViewController.m
//  Cashbery
//
//  Created by Basayel Said on 6/26/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import "KZCardsAtPlacesViewController.h"
#import "CXMLElement+Helpers.h"
#import "TouchXML.h"
#import "CBWalletSettingsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "KZSnapController.h"
#import "KZApplication.h"
#import "KZUserInfo.h"
#import "KZPlacesLibrary.h"
#import "KZReceiptController.h"
#import "KZUserIDCardViewController.h"

@implementation KZCardsAtPlacesViewController

@synthesize place, view_card, view_user_id_card, img_user_id_card, lbl_title;

- (id) initWithPlace:(KZPlace*)_place {
	if (self = [self initWithNibName:@"KZCardsAtPlaces" bundle:nil]) {
		self.place = _place;
	}
	return self;
}


- (void) didTapSettingsButton:(id)theSender {
	[[KZApplication getAppDelegate].tool_bar_vc hideToolBar];
    CBWalletSettingsViewController *_controller = [[CBWalletSettingsViewController alloc] initWithNibName:@"CBWalletSettingsView"
                                                                                                   bundle:nil];
    
    CATransition *_transition = [CATransition animation];
    _transition.duration = 0.35;
    _transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    _transition.type = kCATransitionMoveIn;
    _transition.subtype = kCATransitionFromBottom;
    
    [self.navigationController.view.layer addAnimation:_transition forKey:kCATransition];
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:_controller animated:NO];
    
    [_controller release];
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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationController.navigationBar.tintColor = [UIColor blackColor];
	// these 3 lines
    UIButton *_settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _settingsButton.frame = CGRectMake(0, 0, 80, 44);
    [_settingsButton addTarget:self action:@selector(didTapSettingsButton:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = _settingsButton;
	
	[self.navigationItem setLeftBarButtonItem:[[[UIBarButtonItem alloc] initWithCustomView:[[UIView new] autorelease]] autorelease]];
	if (self.place != nil && self.place.business.has_user_id_card == YES) {
		self.lbl_title.text = [NSString stringWithFormat:@"Card @ %@", self.place.business.name];
	}
	
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


- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	[self.navigationController setToolbarHidden:YES];
	[[KZApplication getAppDelegate].tool_bar_vc showToolBar:self.navigationController];
}


- (void)dealloc {
    [super dealloc];
}

- (IBAction) didTapPlaces {
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) didTapSnap {
	[KZSnapController snapInPlace:nil];
}

- (IBAction) didTapUseCard {
	KZUserIDCardViewController* user_id_card = [[KZUserIDCardViewController alloc] initWithPlace:self.place];
	user_id_card.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[[KZApplication getAppDelegate].navigationController presentModalViewController:user_id_card animated:YES];
	[user_id_card release];
	
	/*
	if (self.place == nil || self.place.business.has_user_id_card == NO) return; 
	UIView* super_view = nil;
	if (self.view_user_id_card.superview == nil) {
		super_view = self.view_card.superview;
		self.view_user_id_card.frame = self.view_card.frame;
	} else {
		super_view = self.view_user_id_card.superview;
		self.view_card.frame = self.view_user_id_card.frame;
	}
	//////////TODO animation
//	[UIView  beginAnimations:@"show_card" context: nil];
//	[UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
//	[UIView setAnimationDuration:0.75];
	if (self.view_user_id_card.superview == nil) {
//		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view_user_id_card cache:YES];
		
		//[self.view_card removeFromSuperview];
		[super_view insertSubview:self.view_user_id_card aboveSubview:self.view_card];
		//NSLog(@"Sending REQUEST TO : %@", [NSString stringWithFormat:@"%@/users/%@/get_id.xml?auth_token=%@", API_URL, self.place.business.identifier, [KZUserInfo shared].auth_token]);
		
		/////// Show the QR Code
		NSMutableDictionary *_headers = [[NSMutableDictionary alloc] init];
		[_headers setValue:@"application/xml" forKey:@"Accept"];
		KZURLRequest* req = [[KZURLRequest alloc] initRequestWithString:[NSString stringWithFormat:@"%@/users/%@/get_id.xml?auth_token=%@", API_URL, self.place.business.identifier, [KZUserInfo shared].auth_token] 
															  andParams:nil 
															   delegate:self 
																headers:_headers 
													  andLoadingMessage:nil];
		[_headers release];
		 
	} else {
//		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view_user_id_card cache:YES];
		[self.view_user_id_card removeFromSuperview];
		//[super_view insertSubview:self.view_card aboveSubview:self.view_user_id_card];
		////////////FIXME tttttttttttttttt
		//[[KZPlacesLibrary shared] requestPlacesWithKeywords:nil];
		[KZReceiptController getAndShowAllReceipts:self];
	}
	
//	[UIView commitAnimations];
	*/
}

/*
- (void) KZURLRequest:(KZURLRequest *)theRequest didFailWithError:(NSError*)theError {
	//NSLog(@"An Error has occured when requesting the User ID QRCode");
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Sorry a server error has occurred while getting your ID. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alert show];
	[alert release];

	[theRequest release];
}

- (void) KZURLRequest:(KZURLRequest *)theRequest didSucceedWithData:(NSData*)theData {
	CXMLDocument *_document = [[[CXMLDocument alloc] initWithData:theData options:0 error:nil] autorelease];
	NSLog([_document description]);
	CXMLElement* _image_node = [_document nodeForXPath:@"/hash/user-id-image-url" error:nil];
	CXMLElement* _timer_node = [_document nodeForXPath:@"/hash/starting-timer-seconds" error:nil];
	NSString* qr_code_image_url = [_image_node stringValue];
	int timer_seconds = [[_timer_node stringValue] intValue];
	[KZApplication showLoadingScreen:@"Generating..."];
	UIImage* img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:qr_code_image_url]]];
	[self.img_user_id_card setImage:img];
	[KZApplication hideLoading];
	[theRequest release];
}
 */
@end
