    //
//  KZUserIDCardViewController.m
//  Cashbery
//
//  Created by Basayel Said on 8/10/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import "KZUserIDCardViewController.h"
#import "CXMLElement+Helpers.h"
#import "TouchXML.h"
#import "CBWalletSettingsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "KZApplication.h"
#import "KZUserInfo.h"
#import "KZReceiptController.h"

@implementation KZUserIDCardViewController

@synthesize img_user_id_card, business;

- (id) initWithBusiness:(KZBusiness*)_biz {
	if (self = [self initWithNibName:@"KZUserIDCardView" bundle:nil]) {
		self.business = _biz;
	}
	return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	/////// Show the QR Code
	NSMutableDictionary *_headers = [[NSMutableDictionary alloc] init];
	[_headers setValue:@"application/xml" forKey:@"Accept"];
	KZURLRequest* req = [[KZURLRequest alloc] initRequestWithString:[NSString stringWithFormat:@"%@/users/%@/get_id.xml?auth_token=%@", 
																			API_URL, self.business.identifier, [KZUserInfo shared].auth_token] 
														  andParams:nil 
														   delegate:self 
															headers:_headers 
												  andLoadingMessage:@"Loading..."];
	[_headers release];
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



- (void)dealloc {
    [super dealloc];
}


/*

- (IBAction) didTapUseCard {
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
		
	}
	
	//	[UIView commitAnimations];
	
}
*/

- (IBAction) doneAction {
	[KZReceiptController getAllReceiptsWithDelegate:self];
	//[self dismissModalViewControllerAnimated:YES];
}

- (void) KZURLRequest:(KZURLRequest *)theRequest didFailWithError:(NSError*)theError {
	//NSLog(@"An Error has occured when requesting the User ID QRCode");
	[KZApplication hideLoading];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Sorry a server error has occurred while getting your ID. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alert show];
	[alert release];
	
	[theRequest release];
}

- (void) KZURLRequest:(KZURLRequest *)theRequest didSucceedWithData:(NSData*)theData {
	@try {	
		CXMLDocument *_document = [[[CXMLDocument alloc] initWithData:theData options:0 error:nil] autorelease];
		NSLog([_document description]);
		CXMLElement* _image_node = [_document nodeForXPath:@"/hash/user-id-image-url" error:nil];
		CXMLElement* _timer_node = [_document nodeForXPath:@"/hash/starting-timer-seconds" error:nil];
		NSString* qr_code_image_url = [_image_node stringValue];
		int timer_seconds = [[_timer_node stringValue] intValue];
		UIImage* img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:qr_code_image_url]]];
		[self.img_user_id_card setImage:img];
		[theRequest release];
	}@catch (NSException * e) {
		[self KZURLRequest:theRequest didFailWithError:nil];
	}
}

- (void) gotReceipts {
	KZSpendReceiptViewController* receipt = [KZReceiptController getNextReceipt];
	
	if (receipt != nil) { 
		[self dismissModalViewControllerAnimated:NO];
		[[KZApplication getAppDelegate].navigationController presentModalViewController:receipt animated:YES];
	}
}

- (void) noMoreReceipts {
	[self dismissModalViewControllerAnimated:NO];
}

- (void) noReceiptsFound {
	/*
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cashbury" message:@"No Receipts available." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alert show];
	[alert release];
	 */
	[self dismissModalViewControllerAnimated:YES];
}

@end
