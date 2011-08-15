//
//  KZBusiness.m
//  Cashbery
//
//  Created by Basayel Said on 6/21/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import "KZBusiness.h"
#import "KZReward.h"
#import "KZAccount.h"

@implementation KZBusiness

@synthesize identifier, name, image_url, has_user_id_card;

static NSMutableDictionary* _businesses = nil;

- (id) initWithIdentifier:(NSString*)_identifier 
				  andName:(NSString*)_name 
			  andImageURL:(NSString*)_image_url 
{
	if (self = [self init]) {
		self.identifier = _identifier;
		self.name = _name;
		self.image_url = _image_url;
		_places = [[NSMutableDictionary alloc] init];
		currency_symbol = nil;
	}
	return self;
}


- (void) dealloc {
	self.identifier = nil;
	self.name = nil;
	self.image_url = nil;
	[_places release];
	[currency_symbol release];
	[super dealloc];
}

- (void) addPlace:(KZPlace*)_place 
{
	_place.business = self;
	[_places setObject:_place forKey:_place.identifier];
}

- (NSArray*) getPlaces 
{
	return (NSArray*)[_places allValues];
}


- (float) getScore {
	NSArray* arr_places = [self getPlaces];
	NSString* spend_campaign_id = nil;
	float rule = 0.0;
	int i, n;
	for (n = [arr_places count]-1; n >= 0; n--) {
		KZPlace* p = (KZPlace*)[arr_places objectAtIndex:n];
		NSArray* arr_rewards = [p getRewards];
		for (i = [arr_rewards count]-1; i >= 0; i--) {
			KZReward* r = (KZReward*)[arr_rewards objectAtIndex:i];
			if (r.isSpendReward) {
				if (currency_symbol == nil) currency_symbol = [r.reward_currency_symbol copy];
				spend_campaign_id = r.campaign_id;
				rule = r.spend_exchange_rule;
				break;
			}
		}
	}
	if (spend_campaign_id != nil && rule > 0.0) {
		return [[KZAccount getAccountBalanceByCampaignId:spend_campaign_id] floatValue] / rule;
	} else {
		return 0.0;
	}
} 


- (NSString*) getCurrencySymbol {
	if (currency_symbol == nil) {
		[self getScore];
	}
	return [[currency_symbol retain] autorelease];
} 

+ (KZBusiness*) getBusinessWithIdentifier:(NSString*)_identifier 
								  andName:(NSString*)_name 
							  andImageURL:(NSString*)_image_url 
{
	KZBusiness* biz;
	if (_businesses == nil) {
		_businesses = [[NSMutableDictionary alloc] init];
	}
	if (_identifier == nil || [_identifier isEqual:@""] == YES) return nil;
	if ((biz = [_businesses objectForKey:_identifier]) == nil) {
		biz = [[KZBusiness alloc] initWithIdentifier:_identifier andName:_name andImageURL:_image_url];
		[_businesses setObject:biz forKey:_identifier];
		[biz release];
	}
	return biz;
}
				
@end
