//
//  KZReward.m
//  Kazdoor
//
//  Created by Rami on 17/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

// NSCoder keys for KZReward
#import "KZAccount.h"
#import "KZReward.h"


@implementation KZReward

@synthesize reward_id, 
			campaign_id, 
			name, 
			reward_image, 
			heading1, 
			heading2, 
			legal_term, 
			how_to_get_amount, 
			fb_enjoy_msg,
			fb_unlock_msg,
			needed_amount, 
			place;

- (id) initWithReardId:(NSString*) _reward_id
		   campaign_id:(NSString*) _campaign_id
				  name:(NSString*) _name
		  reward_image:(NSString*) _reward_image
			  heading1:(NSString*) _heading1
			  heading2:(NSString*) _heading2
			legal_term:(NSString*) _legal_term
	 how_to_get_amount:(NSString*) _how_to_get_amount
		  fb_enjoy_msg:(NSString*) _fb_enjoy_msg
		 fb_unlock_msg:(NSString*) _fb_unlock_msg
		 needed_amount:(NSUInteger) _needed_amount
{
	if (self = [self init]) {
		reward_id = [_reward_id retain];
		campaign_id = [_campaign_id retain];
		name = [_name retain];
		reward_image = [_reward_image retain];
		heading1 = [_heading1 retain];
		heading2 = [_heading2 retain];
		legal_term = [_legal_term retain];
		how_to_get_amount = [_how_to_get_amount retain];
		fb_enjoy_msg = [_fb_enjoy_msg retain];
		fb_unlock_msg = [_fb_unlock_msg retain];
		needed_amount = _needed_amount;
	}
	return self;
}


- (BOOL) isUnlocked {
	KZAccount *acc = [KZAccount getAccountByCampaignId:campaign_id];
	int earned_points = [[KZAccount getAccountBalanceByCampaignId:campaign_id] intValue];
	if (earned_points >= self.needed_amount) {
		return YES;
	}
	return NO;
}


- (void) dealloc {
	[reward_id release];
	[campaign_id release];
	[name release];
	[reward_image release];
	[heading1 release];
	[heading2 release];
	[legal_term release];
	[how_to_get_amount release];
	[fb_enjoy_msg release];
	[fb_unlock_msg release];
	self.place = nil;
	
	[super dealloc];
}

@end
