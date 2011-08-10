//
//  KZSpendRewardCardViewController.m
//  Cashbery
//
//  Created by Basayel Said on 8/1/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import "KZSpendRewardCardViewController.h"
#import "KZAccount.h"

@implementation KZSpendRewardCardViewController

@synthesize reward, 
			unlocked_reward_vc, 
			lbl_reward_name, 
			lbl_valid_until, 
			lbl_legal_terms, 
			lbl_reward_description, 
			lbl_progress_text, 
			lbl_reward_money_amount, 
			tbl_card_details, 
			cell_top, 
			cell_middle, 
			cell_bottom, 
			btn_show_unlocked;

#pragma mark -
#pragma mark Initialization

- (id) initWithReward:(KZReward*)theReward {
    self = [super initWithNibName:@"KZSpendRewardCardView" bundle:nil];
    if (self != nil) {
		self.reward = theReward;
    }
    return self;    
}



//------------------------------------
// UIViewController methods
//------------------------------------

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.lbl_reward_name.text = self.reward.name;
	//self.lbl_reward_money_amount.text = [NSString stringWithFormat:@"%@%0.0lf", self.reward.reward_currency_symbol, self.reward.reward_money_amount];
	if (self.reward.spend_until != nil) {
		NSDateFormatter *df = [[NSDateFormatter alloc] init];
		[df setDateFormat:@"MMMM, d"];
		self.lbl_valid_until.text = [NSString stringWithFormat:@"valid until %@", [df stringFromDate:self.reward.spend_until]];
		[df release];
	} else {
		self.lbl_valid_until.text = @"to spend any time";
	}
	
	[self didUpdatePoints];
	
	if ([self.reward isUnlocked]) {
		[self.btn_show_unlocked setHidden:NO];
	} else {
		[self.btn_show_unlocked setHidden:NO];///////FIXME
	}
	
	[self.lbl_reward_description setVariableLinesText:self.reward.heading2];
	/*
	[self putText:self.reward.heading1 inResizableLabel:self.lbl_heading1];
	[self putText:self.reward.heading2 inResizableLabel:self.lbl_heading2];
	
	CGRect lbl_cost_score_frame = self.lbl_cost_score.frame;
	lbl_cost_score_frame.origin.y = self.lbl_heading2.frame.origin.y + self.lbl_heading2.frame.size.height + 5.0;
	self.lbl_cost_score.frame = lbl_cost_score_frame;
	//CGRect frame = self.lbl_heading2.frame;
	*/
	//frame.origin.y = self.lbl_heading1.frame.origin.y + self.lbl_heading1.frame.size.height + 5;
	//self.lbl_heading2.frame = frame;
	
	
	
	[self.lbl_legal_terms setVariableLinesText:[NSString stringWithFormat:@"                            %@", self.reward.legal_term]];
	
	
	
	
	/// Table Scroll properties
	self.tbl_card_details.pagingEnabled = NO;
	self.tbl_card_details.scrollsToTop = NO;
	self.tbl_card_details.bounces = NO;
	
}

#pragma mark -
#pragma mark View lifecycle



- (IBAction) showUnlockedScreen {
	
	if (self.unlocked_reward_vc == nil) { 
		self.unlocked_reward_vc = [[KZUnlockedSpendRewardViewController alloc] initWithReward:self.reward];
		[self.unlocked_reward_vc release];
	}
	
	self.unlocked_reward_vc.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.unlocked_reward_vc.view.frame.size.width, self.unlocked_reward_vc.view.frame.size.height);
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view.superview cache:NO];
    [UIView setAnimationDuration:0.5];
    [self.view.superview addSubview:self.unlocked_reward_vc.view];
    [UIView commitAnimations];
	
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
		cell = self.cell_top;
		
	} else if (row == 1) {
		cell = self.cell_middle;
		
	} else {
		cell = self.cell_bottom;
	}
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	UIView *v = [[UIView alloc] init];
	cell.backgroundColor = [UIColor clearColor];
	v.opaque = NO;
	cell.backgroundView = v;
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell;
	NSUInteger row = [indexPath row];
	if (row == 0) {
		
		return self.lbl_reward_description.frame.size.height;
	} else if (row == 1) {
		
		return self.cell_middle.frame.size.height;
	} else {
		float previous_height = self.lbl_reward_description.frame.size.height + self.cell_middle.frame.size.height;
		float height = self.lbl_progress_text.frame.size.height + 5.0;
		if ((height + previous_height) < self.tbl_card_details.frame.size.height) height = self.tbl_card_details.frame.size.height - previous_height;
		
		return height;
	}
}

- (void) didUpdatePoints {
	if (![self.reward isUnlocked]) {	// not ready
		NSMutableString* str = [[NSMutableString alloc] init];
		[str appendFormat:@"Spend %@%0.0lf more to unlock this reward", self.reward.reward_currency_symbol, [self.reward getNeededRemainingMoney] ];
		
		if (self.reward.spend_until != nil) { 
			NSTimeInterval secondsBetween = [self.reward.spend_until timeIntervalSinceDate:[NSDate date]];
			
			int numberOfDays = secondsBetween / 86400;
			
			if (numberOfDays > 0) [str appendFormat:@"\nOffer expires in %d days.", numberOfDays];
		}
		
		[self.lbl_progress_text setVariableLinesText:str];
		
		[str release];
		
	} else {	// ready
		self.lbl_progress_text.text = [NSString stringWithFormat:@"Ready to enjoy"];
	}
}


@end

