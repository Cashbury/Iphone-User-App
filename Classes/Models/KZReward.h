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

@property (nonatomic, retain) NSString* reward_id;
@property (nonatomic, retain) NSString* campaign_id;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* reward_image;
@property (nonatomic, retain) NSString* heading1;
@property (nonatomic, retain) NSString* heading2;
@property (nonatomic, retain) NSString* legal_term;
@property (nonatomic, retain) NSString* how_to_get_amount;
@property (nonatomic) NSUInteger needed_amount;
@property (nonatomic, assign) KZPlace *place;

- (BOOL) isUnlocked;


@end
