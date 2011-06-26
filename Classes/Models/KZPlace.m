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

@synthesize identifier, name, description, address, neighborhood, city, country, zipcode, longitude, latitude, phone, open_hours, is_open, business;

//------------------------------------
// Init & dealloc
//------------------------------------
#pragma mark -
#pragma mark Init & dealloc methods

- (id) initWithIdentifier:(NSString*) _identifier
                     name:(NSString*) _name
              description:(NSString*) _description
                  address:(NSString*) _address
             neighborhood:(NSString*) _neighborhood
                     city:(NSString*) _city
                  country:(NSString*) _country
                  zipcode:(NSString*) _zipCode
                longitude:(double) _longitude
                 latitude:(double) _latitude
					phone:(NSString *)_phone
{
    if (self = [super init])
    {
		identifier = [_identifier retain];
		name = [_name retain];
		description = [_description retain];
				
		address = [_address retain];
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
	[description release];
	[address release];
	[neighborhood release];
	[city release];
	[country release];
	[zipcode release];
	[phone release];
	[open_hours release];
	[rewards release];
    self.business = nil;
	
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
    return (NSArray*)rewards;
}

- (BOOL) hasAutoUnlockReward 
{
	BOOL has = NO;
	for (KZReward *reward in rewards) {
		if ([reward isUnlocked]) {
			has = YES;
			break;
		}
	}
	return has;
}

@end
