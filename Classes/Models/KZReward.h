//
//  KZReward.h
//  Kazdoor
//
//  Created by Rami on 17/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KZPlace.h"


@interface KZReward : NSObject
{
	KZPlace* place;
}
- (id) initWithRewardId:(NSString*) _reward_id
		   campaign_id:(NSString*) _campaign_id
				  name:(NSString*) _name
		  reward_image:(NSString*) _reward_image
			  heading1:(NSString*) _heading1
			  heading2:(NSString*) _heading2
			legal_term:(NSString*) _legal_term
	 how_to_get_amount:(NSString*) _how_to_get_amount
		  fb_enjoy_msg:(NSString*) _fb_enjoy_msg
		 fb_unlock_msg:(NSString*) _fb_unlock_msg
		 needed_amount:(NSUInteger) _needed_amount;

@property (nonatomic, readonly) NSString* reward_id;
@property (nonatomic, readonly) NSString* campaign_id;
@property (nonatomic, readonly) NSString* name;
@property (nonatomic, readonly) NSString* reward_image;
@property (nonatomic, readonly) NSString* heading1;
@property (nonatomic, readonly) NSString* heading2;
@property (nonatomic, readonly) NSString* legal_term;
@property (nonatomic, readonly) NSString* how_to_get_amount;
@property (nonatomic, readonly) NSString* fb_enjoy_msg;
@property (nonatomic, readonly) NSString* fb_unlock_msg;
@property (nonatomic, readonly) NSUInteger needed_amount;
@property (nonatomic, assign) KZPlace *place;
@property (nonatomic, retain) NSString* currency_symbol;
@property (nonatomic, retain) NSDate* offer_available_until;
@property (nonatomic) float spend_exchange_rule;
@property (nonatomic) BOOL isSpendReward;
@property (nonatomic, retain) NSDate* spend_until;
@property (nonatomic) float reward_money_amount;
@property (nonatomic, retain) NSString* reward_currency_symbol;


- (BOOL) isUnlocked;
- (float) getNeededMoney;
- (float) getNeededRemainingMoney;
- (NSUInteger) getNeededPoints;
- (NSUInteger) getNeededRemainingPoints;
- (NSUInteger) getEarnedPoints;
- (float) getEarnedMoney;

@end
