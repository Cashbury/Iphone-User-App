//
//  KZPlaceViewController.m
//  Kazdoor
//
//  Created by Rami on 13/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "KZPlaceViewController.h"
#import "KZStampView.h"
#import "KZReward.h"
#import "KZAccount.h"
#import "NSMutableArray+Helper.h"
#import "KZRewardViewController.h"
#import "KZPlaceInfoViewController.h"
#import "FacebookWrapper.h"
#import "KZApplication.h"
#import "GrantViewController.h"
#import "UnlockRewardViewController.h"

@class KZRewardViewController;

@implementation KZPlaceViewController

@synthesize pageControl, scrollView, viewControllers, place, place_btn, other_btn, lbl_earned_points, btn_snap_enjoy, current_reward;

//------------------------------------
// Init & dealloc
//------------------------------------

- (id) initWithPlace:(KZPlace*)thePlace
{
    self = [super initWithNibName:@"KZPlaceView" bundle:nil];
    if (self != nil)
    {
        self.place = thePlace;
    }
    return self;    
}

- (void)dealloc
{
	self.place = nil;
    [super dealloc];
}

//------------------------------------
// UIViewController methods
//------------------------------------

- (void)viewDidLoad
{
    [super viewDidLoad];
	[KZApplication shared].place_vc = self;
	[self.navigationController setNavigationBarHidden:YES];
    
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
	
	//////////////////////////////////////////////////////
	NSArray *place_rewards = [self.place rewards];
	int count = [place_rewards count];

	// view controllers are created lazily
    // in the meantime, load the array with placeholders which will be replaced on demand
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
	self.viewControllers = controllers;
	[controllers release];
	/*
	for (int i = 0; i < count; i++) {
		KZRewardViewController *vc = [[KZRewardViewController alloc] 
									initWithReward:[place_rewards objectAtIndex:i] andDelegate:self];
		[self.viewControllers addObject:vc];
		[vc release];
	}
	 */
    // a page is the width of the scroll view
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * count, 278);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.scrollsToTop = YES;
	self.scrollView.scrollEnabled = YES;
	self.scrollView.bounces = YES;
	self.scrollView.directionalLockEnabled = YES;
    self.scrollView.delegate = self;
    self.pageControl.numberOfPages = count;
    self.pageControl.currentPage = 0;
    // pages are created on demand
    // load the visible page
    // load the page on either side to avoid flashes when the user starts scrolling
	[self loadScrollViewWithPage:0];
	if ([[self.place rewards] count] > 1) { 
		[self loadScrollViewWithPage:1];
	} else {
		self.pageControl.hidden = YES;
	}
	[self changedCurrentReward:0];
	//////////////////////////////////////////////////////
	/**
    if (self.place != nil)
    {
        self.title = place.name;
        
		//UIBarButtonItem *_infoButton = [[UIBarButtonItem alloc] initWithTitle:@"Info" style:UIBarButtonItemStyleBordered target:self action:@selector(didTapInfoButton:)];
		//self.navigationItem.rightBarButtonItem = _infoButton;
		//[_infoButton release];
		
		//UIBarButtonItem *_backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
		//self.navigationItem.backBarButtonItem = _backButton;
		//[_backButton release];
		
    }
	*/
}


- (void)loadScrollViewWithPage:(int)page {
	if (self.viewControllers == nil) return; 
	int count = [[self.place rewards] count];
	if (page >= count) return;
	if (count <= 0) return; 
    if (page < 0) return;
    // replace the placeholder if necessary
	KZRewardViewController *controller;
	if ([self.viewControllers count] <= page) {	// not created yet
		controller = [[KZRewardViewController alloc] 
					  initWithReward:[[self.place rewards] objectAtIndex:page] andDelegate:self];
        [self.viewControllers addObject:controller];
        [controller release];		
	} else {	// created
		controller = [self.viewControllers objectAtIndex:page];
	}
	
    // add the controller's view to the scroll view
    if (nil == controller.view.superview) {
		
        CGRect frame = self.scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        [self.scrollView addSubview:controller.view];
    }
}
/*
- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
}


- (void)viewDidUnload
{
    [super viewDidUnload];
}
 */
//------------------------------------
//------------------------------------
/*
#pragma mark -

- (void)didUpdatePointsForBusinessIdentifier:(NSString *)theBusinessIdentifier points:(NSUInteger)thePoints {
    if (theBusinessIdentifier == self.place.businessIdentifier)
    {
        earnedPoints = thePoints;
        int count = [self.viewControllers count];
		for (int i = 0 ; i < count ; i++) {
			if ((NSNull *)[self.viewControllers objectAtIndex:i] != [NSNull null]) {
				[((KZRewardViewController*)[self.viewControllers objectAtIndex:i]) didUpdatePoints];
			}
		}
    }
}
*/
//------------------------------------
// Private methods
//------------------------------------

- (IBAction) didTapInfoButton:(id)theSender {
	KZPlaceInfoViewController *_infoController = [[KZPlaceInfoViewController alloc] initWithNibName: @"KZPlaceInfoView" bundle: nil place: self.place];
	_infoController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:_infoController animated:YES];
	[_infoController release];
}

- (IBAction) goBack:(id)theSender {
	[self.navigationController popViewControllerAnimated:YES];
}

- (void) didPublish {
	NSLog(@"did publish to Facebook");
}

- (void) updateCurrentReward:(KZReward*)_reward {
	/////TODO update reward
}





//------------------------------------
// ZXingDelegateMethods
//------------------------------------

- (void)zxingController:(ZXingWidgetController*)controller didScanResult:(NSString *)result
{
    [KZApplication handleScannedQRCard:result withPlace:self.current_reward.place withDelegate:nil];
	[self dismissModalViewControllerAnimated:YES];
	//[[KZApplication getAppDelegate].navigationController setNavigationBarHidden:NO animated:NO];
	//[[KZApplication getAppDelegate].navigationController setToolbarHidden:NO animated:NO];
}

- (void)zxingControllerDidCancel:(ZXingWidgetController*)controller
{
	//[KZApplication handleScannedQRCard:@"ad77fce258d9b2d67e77" withPlace:self.place withDelegate:nil];
	[self dismissModalViewControllerAnimated:YES];
	//[[KZApplication getAppDelegate].navigationController setNavigationBarHidden:NO animated:NO];
	//[[KZApplication getAppDelegate].navigationController setToolbarHidden:NO animated:NO];
}


//------------------------------------
// UIAlertViewDelegate methods
//------------------------------------
#pragma mark -
#pragma mark UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
		[self redeem_reward];
    }
}


/*
 - (void)didUpdatePointsForBusinessIdentifier:(NSString *)theBusinessIdentifier points:(NSUInteger)thePoints
 {
 if (theBusinessIdentifier == self.place.businessIdentifier)
 {
 earnedPoints = thePoints;
 
 if (current_reward)
 {
 [self didUpdatePoints];
 
 if ([self userHasEnoughPoints])
 {
 UIAlertView *_alert = [[UIAlertView alloc] initWithTitle:@"Reward Unlocked"
 message:@"When ready to enjoy your reward, simply select it and click Enjoy"
 delegate:nil
 cancelButtonTitle:@"Woohoo"
 otherButtonTitles:nil];
 [_alert show];
 [_alert release];
 }
 }
 }
 }
 
 //------------------------------------
 // Actions
 //------------------------------------
 #pragma mark -
 #pragma mark Actions
 
 - (IBAction)showLegalTerms:(id)theSender {
 LegalTermsViewController *vc = [[LegalTermsViewController alloc] initWithNibName:@"LegalTermsView" bundle:nil];
 vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
 [self.place_view_controller presentModalViewController:vc animated:YES];
 if ([self.reward.legal_term isEqual:@""]) {
 vc.textView.text = @"There are No Legal Terms for this offer.";
 } else {
 vc.textView.text = self.reward.legal_term;
 }
 [vc release];
 }
 */

- (IBAction) didTapSnapButton:(id)theSender
{
    if ([self userHasEnoughPoints]) {
		UIAlertView *_alert = [[UIAlertView alloc] initWithTitle:@"Are you ready?"
															message:@"You can redeem your award only once. Click when ready."
														delegate:self
												cancelButtonTitle:@"Cancel"
												otherButtonTitles:@"Enjoy Now",nil];
		[_alert show];
		[_alert release];
    } else {
		//[[KZApplication getAppDelegate].navigationController setNavigationBarHidden:YES animated:NO];
		//[[KZApplication getAppDelegate].navigationController setToolbarHidden:YES animated:NO];
		
		ZXingWidgetController *widController = [[ZXingWidgetController alloc] initWithDelegate:self showCancel:YES OneDMode:NO];
		QRCodeReader* qrcodeReader = [[QRCodeReader alloc] init];
		NSSet *readers = [[NSSet alloc ] initWithObjects:qrcodeReader,nil];
		[qrcodeReader release];
		widController.readers = readers;
		[readers release];
		widController.soundToPlay = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"beep-beep" ofType:@"aiff"] isDirectory:NO];
		[self presentModalViewController:widController animated:NO];
		[widController release];
		
    }
}

//------------------------------------
// Private methods
//------------------------------------
#pragma mark -
#pragma mark Private methods

- (void) redeem_reward {
	NSMutableDictionary *_headers = [[NSMutableDictionary alloc] init];
	[_headers setValue:@"application/xml" forKey:@"Accept"];
	KZURLRequest *req = [[KZURLRequest alloc] initRequestWithString:
						 [NSString stringWithFormat:@"%@/users/rewards/%@/claim.xml?auth_token=%@", API_URL, self.current_reward.reward_id,  
						  [KZApplication getAuthenticationToken]] delegate:self headers:nil];
	[req autorelease];
	[_headers release];
}

- (BOOL) userHasEnoughPoints
{
	NSUInteger earnedPoints = [[KZAccount getAccountBalanceByCampaignId:self.current_reward.campaign_id] intValue];
    NSUInteger _neededPoints = (self.current_reward) ? self.current_reward.needed_amount : 0;
    return (earnedPoints >= _neededPoints);
}

- (void) changedCurrentReward:(int)_page {
	NSArray *rewards = [self.place rewards];
	if (_page >= [rewards count]) return;
	self.current_reward = [rewards objectAtIndex:_page];
	[self didUpdatePoints];
}

- (void) didUpdatePoints {
	NSUInteger earnedPoints = [[KZAccount getAccountBalanceByCampaignId:self.current_reward.campaign_id] intValue];
    NSUInteger _neededPoints = self.current_reward.needed_amount;

	self.lbl_earned_points.text = [NSString stringWithFormat:@"%d", earnedPoints];
	if (earnedPoints >= _neededPoints) {
		[self.btn_snap_enjoy setImage:[UIImage imageNamed:@"button-enjoy.png"] forState:UIControlStateNormal];
	} else {
		[self.btn_snap_enjoy setImage:[UIImage imageNamed:@"button-snap.png"] forState:UIControlStateNormal];   
	}
    
}


- (void) checkRewards {
	if ([self userHasEnoughPoints]) {
		UnlockRewardViewController *vc = [[UnlockRewardViewController alloc] initWithNibName:@"UnlockRewardView" bundle:nil];
		
		UINavigationController *nav = [KZApplication getAppDelegate].navigationController;
		//[nav setNavigationBarHidden:YES animated:NO];
		//[nav setToolbarHidden:YES animated:NO];
		[nav presentModalViewController:vc animated:YES];
		
		vc.lblBusinessName.text = place.businessName;
		vc.lblBranchAddress.text = place.address;
		vc.txtReward.text = [NSString stringWithFormat:@"Whoohoo! You just unlocked %@. When you are ready to redeem it, select it, and tap Enjoy.", self.current_reward.name];
		vc.share_string = [NSString stringWithFormat:@"Whoohoo! I have just unlocked %@ from %@.", self.current_reward.name, place.businessName];
		
		// set time and date
		NSDate* date = [NSDate date];
		NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:@"HH:mm:ss a MM.dd.yyyy"];
		NSString* str = [formatter stringFromDate:date];
		vc.lblTime.text = str;
		[formatter release];
		
		[vc release];
		/**
		 UIAlertView *_alert = [[UIAlertView alloc] initWithTitle:@"Reward Unlocked"
		 message:@"When ready to enjoy your reward, simply select it and click Enjoy"
		 delegate:nil
		 cancelButtonTitle:@"Woohoo"
		 otherButtonTitles:nil];
		 [_alert show];
		 [_alert release];
		 */
	}
}



- (void) KZURLRequest:(KZURLRequest *)theRequest didFailWithError:(NSError*)theError {
	UIAlertView *_alert = [[UIAlertView alloc] initWithTitle:@"Sorry"
													 message:@"An error has occured while you were claiming your reward. Please contact us."
													delegate:nil
										   cancelButtonTitle:@"OK"
										   otherButtonTitles:nil];
	[_alert show];
	[_alert release];
}

- (void) grantReward:(NSString*)_reward_id byBusinessId:(NSString*)business_id {
	
	NSString* business_name = [[KZApplication getBusinesses] objectForKey:business_id];
	KZReward* _reward = [[KZApplication getRewards] objectForKey:_reward_id];
	GrantViewController *vc = [[GrantViewController alloc] initWithNibName:@"GrantView" bundle:nil];
	
	UINavigationController *nav = [KZApplication getAppDelegate].navigationController;
	//[nav setNavigationBarHidden:YES animated:NO];
	//[nav setToolbarHidden:YES animated:NO];
	[nav pushViewController:vc animated:YES];
	
	vc.lblBusinessName.text = business_name;
	if (place != nil) vc.lblBranchAddress.text = place.address;
	vc.lblName.text = [NSString stringWithFormat:@"By %@ %@", [KZApplication getFirstName], [KZApplication getLastName]];
	vc.share_string = [NSString stringWithFormat:@"Just enjoyed %@ from %@", _reward.name, business_name];
	vc.lblReward.text = _reward.name;
	// set time and date
	NSDate* date = [NSDate date];
	NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"hh:mm:ss a MM.dd.yyyy"];
	NSString* str = [formatter stringFromDate:date];
	vc.lblTime.text = [NSString stringWithFormat:@"Requested at %@", str];
	[formatter release];
	[vc release];
}

/// redeem reward HTTP Callback
- (void) KZURLRequest:(KZURLRequest *)theRequest didSucceedWithData:(NSData*)theData {
	
	CXMLDocument *_document = [[[CXMLDocument alloc] initWithData:theData options:0 error:nil] autorelease];
	NSArray *_nodes = [_document nodesForXPath:@"//redeem" error:nil];
	
	for (CXMLElement *_node in _nodes) {
		NSString *business_id = [_node stringFromChildNamed:@"business-id"];
		NSString *campaign_id = [_node stringFromChildNamed:@"campaign-id"];
		NSString *reward_id = [_node stringFromChildNamed:@"reward-id"];
		NSString *account_points = [_node stringFromChildNamed:@"amount"];
		
		// not used yet
		if ([[_node stringFromChildNamed:@"hide-reward"] isEqual:@"true"]) {
			[[KZApplication getRewards] removeObjectForKey:reward_id];
		}
		
		NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
		[f setNumberStyle:NSNumberFormatterDecimalStyle];
		NSNumber * _balance = [f numberFromString:[_node stringFromChildNamed:@"amount"]];
		[f release];
		
		[KZAccount updateAccountBalance:_balance withCampaignId:campaign_id];
		
		[self didUpdatePoints];
		[self grantReward:reward_id byBusinessId:business_id];
		
	}
}


#pragma mark -
#pragma mark UIScrollViewDelegate stuff

- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView 
{
	CGFloat pageWidth = self.scrollView.frame.size.width;
	int page = floor((self.scrollView.contentOffset.x - pageWidth / 2.0) / pageWidth) + 1;
	self.pageControl.currentPage = page;
	[self changedCurrentReward:page];
	//[self loadScrollViewWithPage:self.pageControl.currentPage];
	[self loadScrollViewWithPage:self.pageControl.currentPage+1];
}

#pragma mark -
#pragma mark PageControl stuff
- (IBAction)changePage:(id)sender 
{
	CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
	[self changedCurrentReward:self.pageControl.currentPage];
	//[self loadScrollViewWithPage:self.pageControl.currentPage];
	[self loadScrollViewWithPage:self.pageControl.currentPage+1];
	[self.scrollView scrollRectToVisible:frame animated:YES];
}



@end
