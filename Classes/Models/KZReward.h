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

- (id) initWithIdentifier:(NSString*)theIdentifier
					name:(NSString*)theName
					description:(NSString*)theDescription
					points:(NSUInteger)thePoints
					program_id:(NSString*)_program_id
					engagement_id:(NSString*)_engagement_id;

@property (readonly, nonatomic) NSString *identifier;
@property (readonly, nonatomic) NSString *name;
@property (readonly, nonatomic) NSString *description;
@property (readonly, nonatomic) NSUInteger points;
@property (readonly, nonatomic) NSString *program_id;
@property (readonly, nonatomic) NSString *engagement_id;
@property (nonatomic) BOOL isAutoUnlock;
@property (nonatomic) BOOL unlocked;
@property (nonatomic, retain) KZPlace *place;
@property (nonatomic) NSUInteger claim;
@property (nonatomic) NSUInteger redeemCount;
@end
