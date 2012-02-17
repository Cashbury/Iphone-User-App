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
#import "FacebookWrapper.h"
#import "KZApplication.h"
#import "GrantViewController.h"
#import "KZSnapController.h"
#import "QuartzCore/QuartzCore.h"
#import "KZSpendRewardCardViewController.h"

@interface KZPlaceViewController (Private)
	- (void) updateStampView;
	- (void) loadScrollViewWithPage:(int)page;
	- (void) changedCurrentReward:(int)_page;
	- (void) showCardOnScrollView:(KZRewardViewController*)_vc andPageNumber:(NSUInteger)page andReward:(KZReward*)_reward;
	- (void) didUpdatePoints;
	- (void) menuAnimationDoneGoBackToPlaces;
@end

@implementation KZPlaceViewController 

@synthesize scrollView, verticalScrollView, viewControllers, place, place_btn, other_btn, lbl_earned_points, btn_snap_enjoy, current_reward, view_gauge_popup, menu, menu_c, menu_eject, btn_close;

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
		current_page_index = 0;
    }
    return self;    
}

- (void)dealloc
{
	self.place = nil;
	self.current_reward = nil;
	self.viewControllers = nil;
	self.verticalScrollView = nil;
	self.scrollView = nil;
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
	[self.place_btn setTitle:place.business.name forState:UIControlStateNormal];
	
	//////////////////////////////////////////////////////
	NSArray *place_rewards = [self.place getRewards];
	int count = [place_rewards count];

	// view controllers are created lazily
    // in the meantime, load the array with placeholders which will be replaced on demand
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
	self.viewControllers = controllers;
	[controllers release];

	// setup vertical scroll view
    //self.verticalScrollView.pagingEnabled = YES;
    self.verticalScrollView.contentSize = CGSizeMake(self.verticalScrollView.frame.size.width, self.verticalScrollView.frame.size.height+1);
    self.verticalScrollView.showsHorizontalScrollIndicator = NO;
    self.verticalScrollView.showsVerticalScrollIndicator = NO;
    self.verticalScrollView.scrollsToTop = YES;
	self.verticalScrollView.scrollEnabled = YES;
	self.verticalScrollView.bounces = YES;
	
	//self.verticalScrollView.directionalLockEnabled = YES;
    self.verticalScrollView.delegate = self;
	//////////////////////////////////////////////////////
	// a page is the width of the scroll view
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * (count+1), self.scrollView.frame.size.height);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.scrollsToTop = YES;
	self.scrollView.scrollEnabled = YES;
	self.scrollView.bounces = YES;
	self.scrollView.directionalLockEnabled = YES;
    self.scrollView.delegate = self;
    //self.pageControl.numberOfPages = (count+1);
    //self.pageControl.currentPage = 0;
    // pages are created on demand
    // load the visible page
    // load the page on either side to avoid flashes when the user starts scrolling
	UIImageView * img_view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cashburies_starter.png"]];
	CGRect f = img_view.frame;
	f.origin.x = 11;
	f.origin.y = 20;
	img_view.frame = f;
	[self.scrollView addSubview:img_view];
	[img_view release];
	
	[self loadScrollViewWithPage:0];
	if ([[self.place getRewards] count] > 1) { 
		[self loadScrollViewWithPage:1];
	}
	[self changedCurrentReward:0];
}


- (void) reloadView {
	
	int count = [[self.place getRewards] count];
	self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * (count+1), self.scrollView.frame.size.height);

	for (KZRewardViewController* _vc in self.viewControllers) {
		if (_vc.unlocked_reward_vc != nil) [_vc.unlocked_reward_vc.view removeFromSuperview];
		[_vc.view removeFromSuperview];
	}
	[self.viewControllers removeAllObjects];
	
	[self loadScrollViewWithPage:0];
	if ([[self.place getRewards] count] > 1) {
		[self loadScrollViewWithPage:1];
	}
	[self changedCurrentReward:0];
	CGRect f = self.scrollView.frame;
	f.origin.x = 0;
	[self.scrollView scrollRectToVisible:f animated:YES];
	[self.scrollView setNeedsDisplay];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    is_menu_open = NO;
	CGRect frame = self.menu.frame;
	frame.origin.y = -145;
	self.menu.frame = frame;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
	[self reloadView];
}
	/*
- (void) viewDidAppear:(BOOL)animated {
	/// Startup animation

	CGRect new_frame = self.scrollView.frame;
	CGRect f = CGRectMake(-160.0, 0.0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
	[self.scrollView scrollRectToVisible:f animated:YES];
	[self.scrollView scrollRectToVisible:new_frame animated:YES];
	 
}
*/
- (void)loadScrollViewWithPage:(int)page {
	if (self.viewControllers == nil) return;
	NSArray* _rewards = [self.place getRewards];
	int count = [_rewards count];
	if (page >= count) return;
	if (count <= 0) return; 
    if (page < 0) return;
    // replace the placeholder if necessary
	UIViewController* controller;
	KZReward* _reward = nil;
	if ([self.viewControllers count] <= page) {	// not created yet
		for (NSUInteger i = [self.viewControllers count]; i <= page; i++) {
			_reward = [_rewards objectAtIndex:i];
			if (_reward.isSpendReward) {
				NSLog(@"1- %@", _reward.name);
				controller = [[KZSpendRewardCardViewController alloc] 
							  initWithReward:_reward];
			} else {
				NSLog(@"2- %@", _reward.name);
				controller = [[KZRewardViewController alloc] 
						  initWithReward:_reward];
			}
			[self.viewControllers addObject:controller];
			[self showCardOnScrollView:controller andPageNumber:i andReward:_reward];
			[controller release];
		}
	} else {	// created
		_reward = [_rewards objectAtIndex:page];
		controller = [self.viewControllers objectAtIndex:page];
        if ([controller class] ==[KZSpendRewardCardViewController class]) {
			[controller didUpdatePoints];
		} else {
			[self updateStampView];
		}
		[self showCardOnScrollView:controller andPageNumber:page andReward:_reward];
	}
	
    
}

- (void) showCardOnScrollView:(KZRewardViewController*)_vc andPageNumber:(NSUInteger)page andReward:(KZReward*)_reward {
	// add the controller's view to the scroll view
    if (nil == _vc.view.superview) {
        CGRect frame = self.scrollView.frame;
        frame.origin.x = frame.size.width * (page+1);
        frame.origin.y = 10;
        _vc.view.frame = frame;
        [self.scrollView addSubview:_vc.view];
    }
	// Show the unlocked yellow screen
	if ([_reward isUnlocked]) {
		if (_vc.unlocked_reward_vc == nil) {
			if ([_vc class] == [KZSpendRewardCardViewController class]) {
				_vc.unlocked_reward_vc = [[[KZUnlockedRewardViewController alloc] initWithReward:_reward] autorelease];
			} else {
				_vc.unlocked_reward_vc = [[[KZUnlockedRewardViewController alloc] initWithReward:_reward] autorelease];
			}
		}
		_vc.unlocked_reward_vc.place_vc = self;
		CGRect frame = _vc.unlocked_reward_vc.view.frame;
		frame.origin.x = _vc.view.frame.origin.x;
		frame.origin.y = _vc.view.frame.origin.y;
		_vc.unlocked_reward_vc.view.frame = frame;
		[self.scrollView addSubview:_vc.unlocked_reward_vc.view];
	}
}



//------------------------------------
// Private methods
//------------------------------------

- (IBAction) didTapInfoButton:(id)theSender {
	[self openCloseMenu];
	[self performSelector:@selector(menuAnimationDone) withObject:nil afterDelay:0.5];
}

- (void) menuAnimationDone
{
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
	/*
	[UIView  beginAnimations: @"Showinfo"context: nil];
	[UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.75];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
	//[self.navigationController popViewControllerAnimated:YES];	
	[UIView commitAnimations];
	*/
	[self dismissModalViewControllerAnimated:YES];
	
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
	if (current_page_index < 1) return;

    [self updateStampView];
    
	if ([self.current_reward isUnlocked]) {
		[self.btn_snap_enjoy setImage:[UIImage imageNamed:@"button-enjoy.png"] forState:UIControlStateNormal];
	} else {
		[self.btn_snap_enjoy setImage:[UIImage imageNamed:@"button-snap.png"] forState:UIControlStateNormal];   
	}
}

- (void) updateStampView
{
    if ([self.viewControllers count] <= (current_page_index-1)) return;
    UIViewController* vc = [self.viewControllers objectAtIndex:(current_page_index-1)];
	if ([vc class] == [KZSpendRewardCardViewController class]) {
		KZSpendRewardCardViewController *_controller = (KZSpendRewardCardViewController *) vc;
		[_controller didUpdatePoints];
		
	} else {
		KZRewardViewController *_controller = (KZRewardViewController *) vc;
		_controller.stampView.numberOfCollectedStamps = [self.current_reward getEarnedPoints];
	}
}

- (BOOL) userHasEnoughPoints
{
	return [self.current_reward isUnlocked];
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
								API_URL, self.current_reward.reward_id, [KZUserInfo shared].auth_token] 
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
	//NSLog(@"X: %lf Y: %lf", self.scrollView.contentOffset.x, self.scrollView.contentOffset.y);
	/*
	if ([self.viewControllers count] > current_page_index-1) { 
		KZRewardViewController *_controller = (KZRewardViewController *) [self.viewControllers objectAtIndex:(current_page_index-1)];
		if (_controller != nil) [_controller.tbl_table_view setScrollEnabled:YES];
	}
	*/
	if (_scrollView == self.verticalScrollView) {
		if (self.verticalScrollView.contentOffset.y > 1.0) {
			[self.scrollView setScrollEnabled:NO];
		} else {
			[self.scrollView setScrollEnabled:YES]; 
		}
	} else if (_scrollView == self.scrollView) {
		
		CGFloat pageWidth = self.scrollView.frame.size.width;
		int page = floor((self.scrollView.contentOffset.x - pageWidth / 2.0) / pageWidth) + 1;
		current_page_index = page;
		if (page < 1) return;
		[self changedCurrentReward:current_page_index-1];
		//[self loadScrollViewWithPage:self.pageControl.currentPage];
		[self loadScrollViewWithPage:current_page_index-1];
		[self loadScrollViewWithPage:current_page_index];
	}
}
/*
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
*/
- (IBAction) showGaugePopup:(id)sender {
	[self.view_gauge_popup setHidden:NO];
}

- (IBAction) closeGaugePopup:(id)sender {
	[self.view_gauge_popup setHidden:YES];
}

- (IBAction) showHowtoSnap:(id)sender
{
    // no op
}

- (IBAction) showHowtoEarnPoints:(id)sender
{
    // no op
}

- (IBAction) openCloseMenu {
	
	CGRect frame = self.menu.frame;
	if (is_menu_open == NO) {
		// open the menu (ejected)
		[self.menu_c setImage:[UIImage imageNamed:@"C-nav-icon-ejected.png"]];
		[self.menu_eject setImage:[UIImage imageNamed:@"Ejected-Nav.png"]];
		is_menu_open = YES;
		frame.origin.y += frame.size.height;
	} else {
		// close the menu (not ejected)
		[self.menu_c setImage:[UIImage imageNamed:@"C-nav-icon.png"]];
		[self.menu_eject setImage:[UIImage imageNamed:@"Eject-Nav.png"]];
		is_menu_open = NO;
		frame.origin.y -= frame.size.height;
	}
	
	// make animation
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	self.menu.frame = frame;
	[UIView commitAnimations];
	
}

@end
