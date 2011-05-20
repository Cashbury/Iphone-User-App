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


#define IDENTIFIER      @"identifier"
#define NAME            @"name"
#define DESCRIPTION     @"description"
#define POINTS          @"points"
#define PLACE           @"place"
#define CAMPAIGN_ID      @"campaign-id"
#define ENGAGEMENT_ID   @"engagement-id"


@implementation KZReward

@synthesize reward_id,  campaign_id,  name,  reward_image,  heading1,  heading2,  legal_term,  needed_amount, how_to_get_amount, place;


- (BOOL) isUnlocked {
	KZAccount *acc = [KZAccount getAccountByCampaignId:campaign_id];
	int earned_points = [[KZAccount getAccountBalanceByCampaignId:campaign_id] intValue];
	if (earned_points >= self.needed_amount) {
		return YES;
	}
	return NO;
}


@end
