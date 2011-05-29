//
//  KZAccount.m
//  Cashbury
//
//  Created by Basayel Said on 5/11/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import "KZAccount.h"


@implementation KZAccount

static NSMutableDictionary *campaigns_accounts = nil;

@synthesize campaign_id, amount, measurement_type, is_money;


+ (KZAccount*) getAccountByCampaignId:(NSString*)_campaign_id {
	return (KZAccount*)[[[campaigns_accounts objectForKey:_campaign_id] retain] autorelease];
}

+ (KZAccount*) setAccountWithCampaignId:(NSString*)_campaign_id
							  andAmount:(NSNumber*)_amount
				   andMeasurementType:(NSString*)_measurement_type
							 andisMoney:(BOOL)_is_money {
	KZAccount *account = [[KZAccount alloc] init];
	account.campaign_id = _campaign_id;
	account.amount = _amount;
	account.measurement_type = _measurement_type;
	account.is_money = _is_money;
	if (campaigns_accounts == nil) {
		campaigns_accounts = [[NSMutableDictionary alloc] init];
	}
	[campaigns_accounts setObject:account forKey:_campaign_id];
	[account release];
}

+ (NSNumber*) getAccountBalanceByCampaignId:(NSString*)_campaign_id {
	KZAccount *account = (KZAccount*)[[campaigns_accounts objectForKey:_campaign_id] retain];
	NSNumber *balance = [[account.amount retain] autorelease];
	return balance;
}

+ (void) updateAccountBalance:(NSNumber*)_balance withCampaignId:(NSString*)_campaign_id {
	KZAccount *account = (KZAccount*)[[campaigns_accounts objectForKey:_campaign_id] retain];
	account.amount = _balance;
}

+ (void) clearAccounts {
	[campaigns_accounts removeAllObjects];
}

@end
