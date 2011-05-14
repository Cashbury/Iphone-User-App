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

@synthesize identifier, name, description, points, place, isAutoUnlock, campaign_id, engagement_id, unlocked, claim, redeemCount, legal_term, reward_image;

- (id) initWithIdentifier:
				(NSString*)theIdentifier 
				name:(NSString*)theName 
				description:(NSString*)theDescription 
				points:(NSUInteger)thePoints
				campaign_id:(NSString*)_campaign_id
				engagement_id:(NSString*)_engagement_id
{
    if (self = [super init])
    {
        identifier = [theIdentifier retain];
        name = [theName retain];
        description = [theDescription retain];
        points = thePoints;
		campaign_id = [_campaign_id retain];
		if (nil == _engagement_id || [_engagement_id isEqualToString:@""]) {
			engagement_id = nil;
		} else {
			engagement_id = [_engagement_id retain];
		}
    }
    
    return self;
}

- (id) initWithCoder:(NSCoder*)aDecoder
{
    if(self = [super init])
    {
        identifier = [[aDecoder decodeObjectForKey:IDENTIFIER] retain];
        name = [[aDecoder decodeObjectForKey:NAME] retain];
        points = [aDecoder decodeIntegerForKey:POINTS];
        place = [[aDecoder decodeObjectForKey:PLACE] retain];
        description = [[aDecoder decodeObjectForKey:DESCRIPTION] retain];
		campaign_id = [[aDecoder decodeObjectForKey:CAMPAIGN_ID] retain];
		engagement_id = [[aDecoder decodeObjectForKey:ENGAGEMENT_ID] retain];
    }
    return self;
}

- (BOOL) isUnlocked {
	//////AHMED
	KZAccount *acc = [KZAccount getAccountByCampaignId:campaign_id];
	int earned_points = [[KZAccount getAccountBalanceByCampaignId:campaign_id] intValue];
	if (earned_points >= points) {
		return YES;
	}
	return NO;
}

- (void) encodeWithCoder:(NSCoder*)aCoder
{
    [aCoder encodeObject:identifier forKey:IDENTIFIER];
    [aCoder encodeObject:name forKey:NAME];
    [aCoder encodeObject:description forKey:DESCRIPTION];
    [aCoder encodeObject:place forKey:PLACE];
    [aCoder encodeInteger:points forKey:POINTS];
	[aCoder encodeObject:campaign_id forKey:CAMPAIGN_ID];
	[aCoder encodeObject:engagement_id forKey:ENGAGEMENT_ID];
}

- (void) dealloc
{
    [identifier release];
    [place release];
    [name release];
    [description release];
    [campaign_id release];
	[engagement_id release];
    [super dealloc];
}

@end
