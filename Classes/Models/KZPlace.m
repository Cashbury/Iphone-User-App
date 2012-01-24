//
//  KZPlace.m
//  Kazdoor
//
//  Created by Rami on 17/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

// NSCoder keys for KZPlace

#define IDENTIFIER      @"identifier"
#define NAME            @"name"
#define DESCRIPTION     @"description"
#define BUSINESS_ID     @"business-id"
#define ADDRESS         @"address"
#define NEIGHBORHOOD    @"neighborhood"
#define CITY            @"city"
#define COUNTRY         @"country"
#define ZIPCODE         @"zipcode"
#define LONGITUDE       @"longitude"
#define LATITUDE        @"latitude"
#define REWARDS         @"rewards"


#import "KZPlace.h"
#import "KZReward.h"
#import "KZApplication.h"


@implementation KZPlace

@synthesize identifier, name, about, address, cross_street, distance, neighborhood, city, country, zipcode, longitude, latitude, phone, open_hours, images, images_thumbs, is_open, business;

//------------------------------------
// Init & dealloc
//------------------------------------
#pragma mark -
#pragma mark Init & dealloc methods

- (id) initWithIdentifier:(NSString*) _identifier
                     name:(NSString*) _name
                    about:(NSString*) _description
                  address:(NSString*) _address
			 cross_street:(NSString*) _cross_street
				 distance:(double) _distance
             neighborhood:(NSString*) _neighborhood
                     city:(NSString*) _city
                  country:(NSString*) _country
                  zipcode:(NSString*) _zipCode
                longitude:(double) _longitude
                 latitude:(double) _latitude
					phone:(NSString*)_phone
{
    if (self = [super init])
    {
		identifier = [_identifier retain];
		name = [_name retain];
		about = [_description retain];
		address = [_address retain];
		
		cross_street = [_cross_street retain];
		distance = _distance;
		
		neighborhood = [_neighborhood retain];
		city = [_city retain];
		country = [_country retain];
		zipcode = [_zipCode retain];
		longitude = _longitude;
		latitude = _latitude;
		phone = [_phone retain];
		rewards = [[NSMutableArray alloc] init];
    }
    
    return self;
}


- (void) dealloc
{
    [identifier release];
	[name release];
	[about release];
	[address release];
	[cross_street release];
	[neighborhood release];
	[city release];
	[country release];
	[zipcode release];
	[phone release];
	[rewards release];
	
	self.images = nil;
	self.images_thumbs = nil;
    self.business = nil;
	self.open_hours = nil;
	
    [super dealloc];
}

//------------------------------------
// Public methods
//------------------------------------
#pragma mark -
#pragma mark Public methods

- (void) addReward:(KZReward*)theReward
{
    theReward.place = self;
    [rewards addObject:theReward];
}

- (NSArray*) getRewards
{
	NSMutableArray* arr_rewards = [[[NSMutableArray alloc] init] autorelease];
	NSMutableArray* arr_to_be_removed = [[[NSMutableArray alloc] init] autorelease];
	NSUInteger count = [rewards count];
	NSUInteger i = 0;
	
	KZReward* r;
	KZReward* s; 
	for (i = 0; i < count; i++) {
		r = (KZReward*)[rewards objectAtIndex:i];
		if (r.isSpendReward) {	// spend based reward
			if ([r isUnlocked]) {
				if ([r.offer_available_until timeIntervalSinceDate:[NSDate date]] < 0) {
					[arr_to_be_removed addObject:[NSString stringWithFormat:@"%d", i]];	// unlocked and expired
				} else {	// if unlocked search for all the smaller spend rewards that are also unlocked
					NSUInteger j;
					for (j = 0; j < count; j++) {
						s = (KZReward*)[rewards objectAtIndex:j];
						if (s.isSpendReward && [s isUnlocked] && s.reward_money_amount < r.reward_money_amount) {
							[arr_to_be_removed addObject:[NSString stringWithFormat:@"%d", j]];
						}
					}
				}
			} else if (r.spend_until != nil && [r.spend_until timeIntervalSinceDate:[NSDate date]] < 0) {
				[arr_to_be_removed addObject:[NSString stringWithFormat:@"%d", i]];	// locked and spending expired
			}
		}
	}
	
	// remove what to be removed
	for (i = 0; i < count; i++) {
		if (NO == [arr_to_be_removed containsObject:[NSString stringWithFormat:@"%d", i]]) {
			[arr_rewards addObject:[rewards objectAtIndex:i]];
		}
	}
    return (NSArray*)arr_rewards;
}

- (NSUInteger) numberOfUnlockReward 
{
	NSUInteger count = 0;
	NSArray* arr = [self getRewards];
	for (KZReward *reward in arr) {
		if ([reward isUnlocked]) {
			count++;
		}
	}
	return count;
}


- (BOOL) hasAutoUnlockReward 
{
	return [self numberOfUnlockReward] > 0;
}



@end
