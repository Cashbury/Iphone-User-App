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
#import "HowToViewController.h"
#import "KZSnapController.h"

@interface KZPlaceViewController (Private)
- (void) updateStampView;
@end

@implementation KZPlaceViewController

@synthesize pageControl, scrollView, viewControllers, place, place_btn, other_btn, lbl_earned_points, btn_snap_enjoy, current_reward, view_gauge_popup, menu, menu_c, menu_eject;

//------------------------------------
// Init & dealloc
//------------------------------------

- (id) initWithPlace:(KZPlace*)thePlace
{
    self = [super initWithNibName:@"KZPlaceView" bundle:nil];
    if (self != nil)
    {
        self.place = thePlace;
		is_menu_open = NO;
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
    
	// order the buttons on the toolbar
	UIFont *myFont = [UIFont boldSystemFontOfSize:22.0];	
	CGSize size = [place.business.name sizeWithFont:myFont forWidth:190.0 lineBreakMode:UILineBreakModeTailTruncation];
	[self.place_btn setTitle:place.business.name forState:UIControlStateNormal];
	CGRect place_frame = self.place_btn.frame;
	place_frame.size.width = size.width;
	self.place_btn.frame = place_frame;
	
	//////////////////////////////////////////////////////
	NSArray *place_rewards = [self.place getRewards];
	int count = [place_rewards count];

	// view controllers are created lazily
    // in the meantime, load the array with placeholders which will be replaced on demand
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
	self.viewControllers = controllers;
	[controllers release];

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
	if ([[self.place getRewards] count] > 1) { 
		[self loadScrollViewWithPage:1];
	} else {
		self.pageControl.hidden = YES;
	}
	[self changedCurrentReward:0];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    is_menu_open = NO;
	CGRect frame = self.menu.frame;
	frame.origin.y = 406;
	self.menu.frame = frame;

	
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}


- (void)loadScrollViewWithPage:(int)page {
	if (self.viewControllers == nil) return; 
	int count = [[self.place getRewards] count];
	if (page >= count) return;
	if (count <= 0) return; 
    if (page < 0) return;
    // replace the placeholder if necessary
	KZRewardViewController *controller;
	KZReward* _reward = [[self.place getRewards] objectAtIndex:page];
	if ([self.viewControllers count] <= page) {	// not created yet
		controller = [[KZRewardViewController alloc] 
					  initWithReward:_reward];
        
        [self.viewControllers insertObject:controller atIndex:page];
        [controller release];		
	} else {	// created
		controller = [self.viewControllers objectAtIndex:page];
        
        [self updateStampView];
	}
	
    // add the controller's view to the scroll view
    if (nil == controller.view.superview) {
		
        CGRect frame = self.scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        [self.scrollView addSubview:controller.view];
    }
	// Show the unlocked yellow screen
	if ([_reward isUnlocked]) {
		controller.unlocked_reward_vc = [[[KZUnlockedRewardViewController alloc] initWithReward:_reward] autorelease];
		CGRect frame = controller.unlocked_reward_vc.view.frame;
		frame.origin.x = controller.view.frame.origin.x;
		frame.origin.y = controller.view.frame.origin.y;
		controller.unlocked_reward_vc.view.frame = frame;
		[self.scrollView addSubview:controller.unlocked_reward_vc.view];
	}
}


//------------------------------------
// Private methods
//------------------------------------

- (IBAction) didTapInfoButton:(id)theSender {
	[self openCloseMenu];
	[self performSelector:@selector(menuAnimationDone) withObject:nil afterDelay:0.5];
}

- (void) menuAnimationDone {
	KZPlaceInfoViewController *_infoController = [[KZPlaceInfoViewController alloc] initWithNibName: @"KZPlaceInfoView" bundle: nil place: self.place];
	_infoController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:_infoController animated:YES];
	[_infoController release];
}

- (IBAction) goBack:(id)theSender {
	if (is_menu_open) {
		[self openCloseMenu];
		[self performSelector:@selector(menuAnimationDoneGoBackToPlaces) withObject:nil afterDelay:0.5];
	} else {
		[self menuAnimationDoneGoBackToPlaces];
	}
}

- (void) menuAnimationDoneGoBackToPlaces {
	[UIView  beginAnimations: @"Showinfo"context: nil];
	[UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.75];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
	[self.navigationController popViewControllerAnimated:YES];	
	[UIView commitAnimations];
}

- (void) didPublish {
	NSLog(@"did publish to Facebook");
}

//------------------------------------
// Private methods
//------------------------------------
#pragma mark -
#pragma mark Private methods

- (void) changedCurrentReward:(int)_page {
	NSArray *rewards = [self.place getRewards];
	if (_page >= [rewards count]) return;
	self.current_reward = [rewards objectAtIndex:_page];
	[self didUpdatePoints];
}

- (void) didUpdatePoints {
	NSUInteger earnedPoints = [[KZAccount getAccountBalanceByCampaignId:self.current_reward.campaign_id] intValue];
    NSUInteger _neededPoints = self.current_reward.needed_amount;
	
	self.lbl_earned_points.text = [NSString stringWithFormat:@"%d", earnedPoints];
    [self updateStampView];
    
    [self.viewControllers objectAtIndex:self.pageControl.currentPage];
    
	if (earnedPoints >= _neededPoints) {
		[self.btn_snap_enjoy setImage:[UIImage imageNamed:@"button-enjoy.png"] forState:UIControlStateNormal];
	} else {
		[self.btn_snap_enjoy setImage:[UIImage imageNamed:@"button-snap.png"] forState:UIControlStateNormal];   
	}
    
}

- (void) updateStampView
{
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2.0) / pageWidth) + 1;
    
    KZRewardViewController *_controller = (KZRewardViewController *) [self.viewControllers objectAtIndex:page];
    
    NSUInteger earnedPoints = [[KZAccount getAccountBalanceByCampaignId:self.current_reward.campaign_id] intValue];
    _controller.stampView.numberOfCollectedStamps = earnedPoints;
}

- (BOOL) userHasEnoughPoints
{
	NSUInteger earnedPoints = [[KZAccount getAccountBalanceByCampaignId:self.current_reward.campaign_id] intValue];
    NSUInteger _neededPoints = (self.current_reward) ? self.current_reward.needed_amount : 0;
    return (earnedPoints >= _neededPoints);
}

/*
 
 
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
 
 
 - (IBAction) didTapSnapButton:(id)theSender
 {
 if ([self userHasEnoughPoints]) {
 UIAlertView *_alert = [[UIAlertView alloc] initWithTitle:@"Are you ready?"
 message:@"Are you ready to Enjoy this reward?\nYou can enjoy this reward only once. You must be in the store to enjoy.\nIf you are ready, then touch Enjoy Now, otherwise, press cancel."
 delegate:self
 cancelButtonTitle:@"Cancel"
 otherButtonTitles:@"Enjoy Now",nil];
 [_alert show];
 [_alert release];
 } else {
 [KZSnapController snapInPlace:self.place];
 }
 }
 

- (void) redeem_reward {
	NSMutableDictionary *_headers = [[NSMutableDictionary alloc] init];
	[_headers setValue:@"application/xml" forKey:@"Accept"];
	KZURLRequest *req = [[[KZURLRequest alloc] initRequestWithString:
								[NSString stringWithFormat:@"%@/users/rewards/%@/claim.xml?auth_token=%@", 
								API_URL, self.current_reward.reward_id, [KZApplication getAuthenticationToken]] 
							andParams:nil delegate:self headers:_headers andLoadingMessage:@"Loading..."] autorelease];
	[_headers release];
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
	[nav.topViewController presentModalViewController:vc animated:YES];
	
	vc.lblBusinessName.text = business_name;
	if (place != nil) vc.lblBranchAddress.text = place.address;
	vc.lblName.text = [NSString stringWithFormat:@"By %@ %@", [KZApplication getFirstName], [KZApplication getLastName]];
	vc.share_string = _reward.fb_enjoy_msg;//[NSString stringWithFormat:@"Just enjoyed %@ from %@", _reward.name, business_name];
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
		NSString *account_points = [_node stringFromChildNamed:@"account-amount"];

		// not used yet
		if ([[_node stringFromChildNamed:@"hide-reward"] isEqual:@"true"]) {
			[[KZApplication getRewards] removeObjectForKey:reward_id];
		}
		
		NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
		[f setNumberStyle:NSNumberFormatterDecimalStyle];
		NSNumber * _balance = [f numberFromString:account_points];
		[f release];
		
		[KZAccount updateAccountBalance:_balance withCampaignId:campaign_id];
		
		[self didUpdatePoints];
		[self grantReward:reward_id byBusinessId:business_id];
		
	}
}
//*/

#pragma mark -
#pragma mark UIScrollViewDelegate stuff

- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView {
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

- (IBAction) showGaugePopup:(id)sender {
	[self.view_gauge_popup setHidden:NO];
}

- (IBAction) closeGaugePopup:(id)sender {
	[self.view_gauge_popup setHidden:YES];
}

- (IBAction) showHowtoSnap:(id)sender {
	HowToViewController *vc = [[HowToViewController alloc] initWithReward:self.current_reward];
	[self presentModalViewController:vc animated:YES];
	[vc showHowToSnap];
	[vc release];
}

- (IBAction) showHowtoEarnPoints:(id)sender {
	HowToViewController *vc = [[HowToViewController alloc] initWithReward:self.current_reward];
	[self presentModalViewController:vc animated:YES];
	[vc showHowToEarnPoints];
	[vc release];	
}

- (IBAction) openCloseMenu {
	
	CGRect frame = self.menu.frame;
	if (is_menu_open == NO) {
		// open the menu (ejected)
		[self.menu_c setImage:[UIImage imageNamed:@"C-nav-icon-ejected.png"]];
		[self.menu_eject setImage:[UIImage imageNamed:@"Ejected-Nav.png"]];
		is_menu_open = YES;
		frame.origin.y -= frame.size.height;
	} else {
		// close the menu (not ejected)
		[self.menu_c setImage:[UIImage imageNamed:@"C-nav-icon.png"]];
		[self.menu_eject setImage:[UIImage imageNamed:@"Eject-Nav.png"]];
		is_menu_open = NO;
		frame.origin.y += frame.size.height;
	}
	
	// make animation
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	self.menu.frame = frame;
	[UIView commitAnimations];
	
}


@end
