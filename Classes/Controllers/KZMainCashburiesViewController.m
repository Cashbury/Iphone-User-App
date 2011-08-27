//
//  KZMainCashburiesViewController.m
//  Kazdoor
//
//  Created by Rami on 13/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "KZMainCashburiesViewController.h"
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
#import "QuartzCore/QuartzCore.h"
#import "KZSpendRewardCardViewController.h"
#import "KZPlacesLibrary.h"
#import "CBWalletSettingsViewController.h"

@interface KZMainCashburiesViewController (Private)
- (void) updateStampView;
@end

@implementation KZMainCashburiesViewController 

@synthesize scrollView, verticalScrollView, viewControllers, place_btn, other_btn, lbl_earned_points, btn_snap_enjoy, current_reward, view_gauge_popup, btn_close;

//------------------------------------
// Init & dealloc
//------------------------------------

- (void)dealloc
{
	[arr_rewards release];
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
	
	// these 3 lines
    UIButton *_settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _settingsButton.frame = CGRectMake(0, 0, 320, 44);
    [_settingsButton addTarget:self action:@selector(didTapSettingsButton:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = _settingsButton;
	[self.navigationItem setLeftBarButtonItem:[[[UIBarButtonItem alloc] initWithCustomView:[[UIView new] autorelease]] autorelease]];
	//////////////////////////////////////////////////////

	

	
	///////TODO Uncomment this to enable cards again
	/*
	arr_rewards = nil;
	NSMutableArray *controllers = [[NSMutableArray alloc] init];
	self.viewControllers = controllers;
	[controllers release];
	
	[KZApplication shared].place_vc = self;
	
	
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
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width +1, self.scrollView.frame.size.height);
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
	self.btn_close.layer.masksToBounds = YES;
	self.btn_close.layer.cornerRadius = 5.0;
	self.btn_close.layer.borderColor = [UIColor grayColor].CGColor;
	self.btn_close.layer.borderWidth = 1.0;
	*/
}


- (void) reloadView {
	if (arr_rewards != nil) [arr_rewards release];
	arr_rewards = [KZPlacesLibrary getOuterRewards];
	[arr_rewards retain];
	int count = [arr_rewards count];
	[self.viewControllers removeAllObjects];
	
	self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * (count+1), self.scrollView.frame.size.height);
	[self.scrollView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
	
	for (KZRewardViewController* _vc in self.viewControllers) {
		if (_vc.unlocked_reward_vc != nil) [_vc.unlocked_reward_vc.view removeFromSuperview];
		[_vc.view removeFromSuperview];
	}
	//////////////
	UIImageView * img_view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cashburies_starter.png"]];
	CGRect f = img_view.frame;
	f.origin.x = 11;
	f.origin.y = 20;
	img_view.frame = f;
	[self.scrollView addSubview:img_view];
	[img_view release];
	
	[self loadScrollViewWithPage:0];
	if (count > 1) { 
		[self loadScrollViewWithPage:1];
	}
	[self changedCurrentReward:0];
	////////////////
	

	
	[self loadScrollViewWithPage:0];
	if (count > 1) {
		[self loadScrollViewWithPage:1];
	}
	[self changedCurrentReward:0];
	f = self.scrollView.frame;
	f.origin.x = 0;
	[self.scrollView scrollRectToVisible:f animated:YES];
	[self.scrollView setNeedsDisplay];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	///////TODO Uncomment this to enable cards again
	//[self reloadView];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
	[self.navigationController setToolbarHidden:YES];
	[[KZApplication getAppDelegate].tool_bar_vc showToolBar:self.navigationController];
	
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
	int count = [arr_rewards count];
	if (page >= count) return;
	if (count <= 0) return; 
    if (page < 0) return;
    // replace the placeholder if necessary
	UIViewController* controller;
	KZReward* _reward = nil;
	if ([self.viewControllers count] <= page) {	// not created yet
		for (NSUInteger i = [self.viewControllers count]; i <= page; i++) {
			_reward = [arr_rewards objectAtIndex:i];
			if (_reward.isSpendReward) {
				controller = [[KZSpendRewardCardViewController alloc] 
							  initWithReward:_reward];
			} else {
				controller = [[KZRewardViewController alloc] 
							  initWithReward:_reward];
			}
			[self.viewControllers addObject:controller];
			[self showCardOnScrollView:controller andPageNumber:i andReward:_reward];
			[controller release];
		}
	} else {	// created
		_reward = [arr_rewards objectAtIndex:page];
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
				_vc.unlocked_reward_vc = [[[KZUnlockedSpendRewardViewController alloc] initWithReward:_reward] autorelease];
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


- (IBAction) goBack:(id)theSender {
	[[KZApplication getAppDelegate].navigationController popViewControllerAnimated:YES];
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
	if (_page >= [arr_rewards count]) return;
	self.current_reward = [arr_rewards objectAtIndex:_page];
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

@end
