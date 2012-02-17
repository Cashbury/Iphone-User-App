//
//  KZRewardViewController.m
//  Cashbury
//
//  Created by Basayel Said on 3/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "KZRewardViewController.h"
#import "KZStampView.h"
#import "KZReward.h"
#import "FacebookWrapper.h"
#import "GrantViewController.h"
#import "KZAccount.h"
#import "QuartzCore/QuartzCore.h"
#import "UILabel+Helpers.h"

@class KZUnlockedRewardViewController;

@interface KZRewardViewController (PrivateMethods)
- (BOOL) userHasEnoughPoints;
- (void) didTapInfoButton:(id)theSender;
- (void) didUpdatePoints;
@end


@implementation KZRewardViewController

@synthesize lbl_brand_name, lbl_reward_name, img_reward_image, 
			lbl_heading1, lbl_heading2, lbl_legal_terms, 
			lbl_needed_points, tbl_table_view, 
			cell2_headings, cell3_stamps, cell4_terms, cell5_bottom, 
			redeem_request, stampView, reward, place, lbl_cost_score, unlocked_reward_vc, btn_unlocked;


- (id) initWithReward:(KZReward*)theReward {
    self = [super initWithNibName:@"KZRewardView" bundle:nil];
    if (self != nil) {
		self.reward = theReward;
        self.place = theReward.place;
		CGRect frame;
		self.stampView = [[KZStampView alloc] initWithFrame:frame numberOfStamps:self.reward.needed_amount numberOfCollectedStamps:[self.reward getEarnedPoints]];
    }
    return self;    
}



- (void) dealloc {
	self.lbl_brand_name = nil;
	self.lbl_reward_name = nil;
	self.img_reward_image = nil;
	self.lbl_heading1 = nil;
	self.lbl_heading2 = nil;
	self.lbl_legal_terms = nil;
	self.lbl_needed_points = nil;
	self.tbl_table_view = nil;
	self.cell2_headings = nil;
	self.cell3_stamps = nil;
	self.cell4_terms = nil;
	self.cell5_bottom = nil;
	self.redeem_request = nil;
	self.stampView = nil;
	self.reward = nil;
	self.place = nil;
	self.lbl_cost_score = nil;
	self.unlocked_reward_vc = nil;
	//[tile release];
	
	[super dealloc];
}

//------------------------------------
// UIViewController methods
//------------------------------------

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.lbl_reward_name.text = self.reward.name;
	if (![self.reward isUnlocked]) {	// not ready
		self.lbl_cost_score.text = [NSString stringWithFormat:@"+%d points needed to enjoy. Score: %d", [self.reward getNeededRemainingPoints], [self.reward getEarnedPoints]];
	} else {	// ready
		self.lbl_cost_score.text = [NSString stringWithFormat:@"Ready to enjoy. Score: %d", [self.reward getEarnedPoints]];
	}
	[self.btn_unlocked setHidden:NO];
	self.lbl_brand_name.text = [NSString stringWithFormat:@"@%@", self.place.business.name];
	
	[self.lbl_heading1 setVariableLinesText:self.reward.heading1];
	[self.lbl_heading2 setVariableLinesText:self.reward.heading2];
	
	CGRect lbl_cost_score_frame = self.lbl_cost_score.frame;
	lbl_cost_score_frame.origin.y = self.lbl_heading2.frame.origin.y + self.lbl_heading2.frame.size.height + 5.0;
	self.lbl_cost_score.frame = lbl_cost_score_frame;
	//CGRect frame = self.lbl_heading2.frame;
	
	//frame.origin.y = self.lbl_heading1.frame.origin.y + self.lbl_heading1.frame.size.height + 5;
	//self.lbl_heading2.frame = frame;
	
	
	
	[self.lbl_legal_terms setVariableLinesText:[NSString stringWithFormat:@"                            %@", self.reward.legal_term]];
	if (self.reward.reward_image != nil && [self.reward.reward_image isEqual:@""] != YES) { 
		// set the logo image
		[self performSelectorInBackground:@selector(loadRewardImage) withObject:nil];
	}
	
	
	
	
	/// Table Scroll properties
	self.tbl_table_view.pagingEnabled = NO;
	self.tbl_table_view.scrollsToTop = NO;
	self.tbl_table_view.bounces = NO;
	
}
/*
	UISwipeGestureRecognizer* swipe_up = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe_table_up:)] autorelease];
	swipe_up.direction = UISwipeGestureRecognizerDirectionUp;
	swipe_up.delegate = self;
	
	UISwipeGestureRecognizer* swipe_down = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe_table_down:)] autorelease];
	swipe_down.direction = UISwipeGestureRecognizerDirectionDown;
	swipe_down.delegate = self;
	
	[self.tbl_table_view addGestureRecognizer:swipe_up];
	[self.tbl_table_view addGestureRecognizer:swipe_down];
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
	return YES;
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
	//NSLog(@"RUN IT SHOULD");
	return YES;
}
- (BOOL) gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
	return YES;
}

- (BOOL) swipe_table_up:(UITapGestureRecognizer *)sender {
	if (self.tbl_table_view.frame.size.height + self.tbl_table_view.contentOffset.y >= self.tbl_table_view.contentSize.height) {	// reached bottom
		//NSLog(@"SCROLL IT");
		//UIScrollView* vertical = (UIScrollView*)self.view.superview.superview;
		//[vertical scrollRectToVisible:CGRectMake(0.0, 100.0, vertical.frame.size.width, vertical.frame.size.height) animated:YES];
	}
	return YES;
}

- (BOOL) swipe_table_down:(UITapGestureRecognizer *)sender {
	if (self.tbl_table_view.contentOffset.y <= 0.0) {
		
	}
	return YES;
}
*/

- (void) viewWillAppear:(BOOL)animated {
	NSLog(@"Reward will appear: %@", self.reward.name);
}

/*
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	[scrollView.dragging direction]
	if (scrollView.frame.size.height + scrollView.contentOffset.y >= scrollView.contentSize.height) {	// reached bottom
		[scrollView setScrollEnabled:NO];
		//[scrollView setScrollEnabled:NO];

	} else if (scrollView.contentOffset.y <= 0.0) {
		[scrollView setScrollEnabled:NO];
	}
}

 
- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
	if (scrollView.frame.size.height + scrollView.contentOffset.y >= scrollView.contentSize.height) {	// reached bottom
		UIScrollView* vertical = (UIScrollView*)self.view.superview.superview;
		//[scrollView setUserInteractionEnabled:YES];
		
		//[vertical setUserInteractionEnabled:YES];
		//[scrollView setScrollEnabled:NO];
		
	} else if (scrollView.contentOffset.y <= 0.0) {
		[scrollView setScrollEnabled:NO];
	}
	//UIScrollView* vertical = (UIScrollView*)self.view.superview.superview;
	//[vertical scrollRectToVisible:CGRectMake(0.0, scrollView.contentOffset.y, vertical.frame.size.width, vertical.frame.size.height) animated:YES];	
}
/*
- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	if (scrollView.frame.size.height + scrollView.contentOffset.y > scrollView.contentSize.height) {
		[scrollView setScrollEnabled:NO];
	} else if (scrollView.contentOffset.y <= 0.0) {
		//[scrollView setScrollEnabled:NO];
	}
}
*/



- (void)viewDidUnload
{
    [super viewDidUnload];
	
}


- (IBAction) showUnlockedScreen {
	if (self.unlocked_reward_vc == nil) { 
		self.unlocked_reward_vc = [[KZUnlockedRewardViewController alloc] initWithReward:self.reward];
		[self.unlocked_reward_vc release];
	}
	
	self.unlocked_reward_vc.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.unlocked_reward_vc.view.frame.size.width, self.unlocked_reward_vc.view.frame.size.height);
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view.superview cache:NO];
    [UIView setAnimationDuration:0.5];
    [self.view.superview addSubview:self.unlocked_reward_vc.view];
    [UIView commitAnimations];
}


- (void) loadRewardImage {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	if (self.img_reward_image != nil) {
		UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.reward.reward_image]]];
		CGRect image_frame = self.img_reward_image.frame;
		image_frame.size = img.size;
		self.img_reward_image.frame = image_frame;
		[self.img_reward_image setImage:img];
		self.img_reward_image.layer.masksToBounds = YES;
		self.img_reward_image.layer.cornerRadius = 5.0;
	}
	[pool release];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 3;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell;
	NSUInteger row = [indexPath row];
	if (row == 0) {
		cell = self.cell2_headings;
		
	} else if (row == 1) {
		cell = self.cell3_stamps;
		[cell addSubview:self.stampView];
		
	} else {
		cell = self.cell4_terms;
	}
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	UIView *v = [[UIView alloc] init];
	//v.backgroundColor = [UIColor colorWithPatternImage:tile];
	cell.backgroundColor = [UIColor clearColor];
	v.opaque = NO;
	cell.backgroundView = v;
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell;
	NSUInteger row = [indexPath row];
	if (row == 0) {
		
		return self.lbl_heading1.frame.size.height + 20.0;
	} else if (row == 1) {
		
		return self.stampView.frame.size.height + 20.0;
	} else {
		float previous_height = self.lbl_heading1.frame.size.height + self.stampView.frame.size.height + 40.0;
		
		float height = self.lbl_heading2.frame.size.height + self.lbl_cost_score.frame.size.height + 5.0;
		if ((height + previous_height) < self.tbl_table_view.frame.size.height) height = self.tbl_table_view.frame.size.height - previous_height;
		return height;
	}
}




@end
