    //
//  KZMainCashburiesViewController.m
//  Cashbery
//
//  Created by Basayel Said on 7/14/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import "KZMainCashburiesViewController.h"
#import "KZApplication.h"
#import "CBWalletSettingsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "KZPlacesLibrary.h"

@implementation KZMainCashburiesViewController

NSUInteger current_page_index = 0;
@synthesize verticalScrollView, scrollView, current_reward, viewControllers, rewards;
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

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.rewards = [KZPlacesLibrary getOuterRewards];
	
	// these 3 lines
    UIButton *_settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _settingsButton.frame = CGRectMake(0, 0, 80, 44);
    [_settingsButton addTarget:self action:@selector(didTapSettingsButton:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = _settingsButton;
	[self.navigationItem setLeftBarButtonItem:[[[UIBarButtonItem alloc] initWithCustomView:[[UIView new] autorelease]] autorelease]];
	
	NSUInteger count = [self.rewards count];
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
 //   self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * 2, self.scrollView.frame.size.height);
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
	CGRect f1 = img_view.frame;
	f1.origin.x = 11;
	f1.origin.y = 17;
	img_view.frame = f1;
	[self.scrollView addSubview:img_view];
	[img_view release];
	
	
	[self loadScrollViewWithPage:0];
	if ([self.rewards count] > 1) { 
		[self loadScrollViewWithPage:1];
	}
	[self changedCurrentReward:0];
	
}

- (void) reloadView {
	for (KZRewardViewController* _vc in self.viewControllers) {
		if (_vc.unlocked_reward_vc != nil) [_vc.unlocked_reward_vc.view removeFromSuperview];
		[_vc.view removeFromSuperview];
	}
	
	[self loadScrollViewWithPage:0];
	if ([self.rewards count] > 1) {
		[self loadScrollViewWithPage:1];
	}
	[self changedCurrentReward:0];
	CGRect f = self.scrollView.frame;
	f.origin.x = 0;
	[self.scrollView scrollRectToVisible:f animated:YES];
	[self.scrollView setNeedsDisplay];
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	[self.navigationController setToolbarHidden:YES];
	//[[KZApplication getAppDelegate].tool_bar_vc hideToolBar];
	[[KZApplication getAppDelegate].tool_bar_vc showToolBar:self.navigationController];
}




///////////////////////////////////----------------------------------------------







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
	int count = [self.rewards count];
	if (page >= count) return;
	if (count <= 0) return; 
    if (page < 0) return;
    // replace the placeholder if necessary
	KZRewardViewController *controller;
	KZReward* _reward = nil;
	if ([self.viewControllers count] <= page) {	// not created yet
		for (NSUInteger i = [self.viewControllers count]; i <= page; i++) {
			_reward = [self.rewards objectAtIndex:i];
			controller = [[KZRewardViewController alloc] 
						  initWithReward:_reward];
			[self.viewControllers addObject:controller];
			[self showCardOnScrollView:controller andPageNumber:i andReward:_reward];
			[controller release];
		}
	} else {	// created
		_reward = [self.rewards objectAtIndex:page];
		controller = [self.viewControllers objectAtIndex:page];
        [self updateStampView];
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
	// Show the unlocked screen
	if ([_reward isUnlocked]) {
		_vc.unlocked_reward_vc = [[[KZUnlockedRewardViewController alloc] initWithReward:_reward] autorelease];
		_vc.unlocked_reward_vc.place_vc = self;
		CGRect frame = _vc.unlocked_reward_vc.view.frame;
		frame.origin.x = _vc.view.frame.origin.x;
		frame.origin.y = _vc.view.frame.origin.y;
		_vc.unlocked_reward_vc.view.frame = frame;
		[self.scrollView addSubview:_vc.unlocked_reward_vc.view];
	}
}
   
- (void) changedCurrentReward:(int)_page {
	NSArray *rewards = [KZPlacesLibrary getOuterRewards];
	if (_page >= [rewards count]) return;
	self.current_reward = [rewards objectAtIndex:_page];
	[self didUpdatePoints];
}

- (void) didUpdatePoints {
	if (current_page_index < 1) return;
	
    [self updateStampView];
}

- (void) updateStampView {
	if ([self.viewControllers count] <= (current_page_index-1)) return;
    KZRewardViewController *_controller = (KZRewardViewController *) [self.viewControllers objectAtIndex:(current_page_index-1)];
    _controller.stampView.numberOfCollectedStamps = [self.current_reward getEarnedPoints];
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
		NSLog(@"%d  %d", [self.viewControllers count], current_page_index);
		if (page < 1) return;
		[self changedCurrentReward:current_page_index-1];
		[self loadScrollViewWithPage:current_page_index-1];
		[self loadScrollViewWithPage:current_page_index];
	}
}











///////////////////////////////////----------------------------------------------



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
	self.current_reward = nil;
	self.viewControllers = nil;
	self.verticalScrollView = nil;
	self.scrollView = nil;
    [super dealloc];
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
