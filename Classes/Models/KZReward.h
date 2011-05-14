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
	
}

- (BOOL) isUnlocked;

- (id) initWithIdentifier:(NSString*)theIdentifier
					name:(NSString*)theName
					description:(NSString*)theDescription
					points:(NSUInteger)thePoints
					campaign_id:(NSString*)_campaign_id
					engagement_id:(NSString*)_engagement_id;

@property (readonly, nonatomic) NSString *identifier;
@property (readonly, nonatomic) NSString *name;
@property (readonly, nonatomic) NSString *description;
@property (retain, nonatomic) NSString *legal_term;
@property (retain, nonatomic) NSString *reward_image;
@property (readonly, nonatomic) NSUInteger points;
@property (readonly, nonatomic) NSString *campaign_id;
@property (readonly, nonatomic) NSString *engagement_id;
@property (nonatomic) BOOL isAutoUnlock;
@property (nonatomic) BOOL unlocked;
@property (nonatomic, retain) KZPlace *place;
@property (nonatomic) NSUInteger claim;
@property (nonatomic) NSUInteger redeemCount;
@end
