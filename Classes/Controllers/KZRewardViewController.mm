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
#import "KZPlaceInfoViewController.h"
#import "FacebookWrapper.h"
#import "GrantViewController.h"
#import "LegalTermsViewController.h"
#import "KZAccount.h"
#import "UIView+Utils.h"

@class KZUnlockedRewardViewController;

@interface KZRewardViewController (PrivateMethods)
- (BOOL) userHasEnoughPoints;
- (void) didTapInfoButton:(id)theSender;
- (void) didUpdatePoints;
@end


@implementation KZRewardViewController

@synthesize lbl_brand_name, lbl_reward_name, img_reward_image, 
			lbl_heading1, lbl_heading2, lbl_legal_terms, 
			lbl_needed_points, tbl_table_view, cell1_snap_to_win, 
			cell2_headings, cell3_stamps, cell4_terms, cell5_bottom, 
			redeem_request, stampView, reward, place, lbl_cost_score, unlocked_reward_vc, btn_unlocked;


- (id) initWithReward:(KZReward*)theReward {
    self = [super initWithNibName:@"KZRewardView" bundle:nil];
    if (self != nil) {
		self.reward = theReward;
        self.place = theReward.place;
        earnedPoints = [[KZAccount getAccountBalanceByCampaignId:reward.campaign_id] intValue];
		tile = [[UIImage imageNamed:@"gray_card_content.png"] retain];
		CGRect frame;
		self.stampView = [[KZStampView alloc] initWithFrame:frame numberOfStamps:self.reward.needed_amount numberOfCollectedStamps:earnedPoints];
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
	self.cell1_snap_to_win = nil;
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
	[tile release];
	
	[super dealloc];
}

//------------------------------------
// UIViewController methods
//------------------------------------

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.lbl_reward_name.text = self.reward.name;
	//self.lbl_needed_points.text = [NSString stringWithFormat:@"%d", self.reward.needed_amount];
	self.lbl_cost_score.text = [NSString stringWithFormat:@"Cost: %d / Score: %d", self.reward.needed_amount, earnedPoints];
	if (self.reward.needed_amount > earnedPoints) {
		[self.btn_unlocked setHidden:YES];
	} else {
		[self.btn_unlocked setHidden:NO];
	}
	self.lbl_brand_name.text = [NSString stringWithFormat:@"@%@", self.place.business.name];
	self.lbl_heading1.text = self.reward.heading1;
	self.lbl_heading2.text = self.reward.heading2;
	self.lbl_legal_terms.text = self.reward.legal_term;
	[self.img_reward_image roundCornersUsingRadius:5 borderWidth:0 borderColor:nil];
	if (self.reward.reward_image != nil && [self.reward.reward_image isEqual:@""] != YES) { 
		// set the logo image
		[self performSelectorInBackground:@selector(loadRewardImage) withObject:nil];
	}
}

- (void)viewDidUnload
{
	[req release];
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
		
		return self.cell2_headings.frame.size.height;
	} else if (row == 1) {
		
		return self.stampView.frame.size.height;
	} else {
		NSUInteger previous_height = self.cell2_headings.frame.size.height + self.stampView.frame.size.height;
		NSUInteger height = self.cell4_terms.frame.size.height;
		if (height + previous_height < 268) height = 268 - previous_height;
		return height;
	}
}




@end
