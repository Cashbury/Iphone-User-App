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

@synthesize identifier, name, description, address, cross_street, distance, distance_unit, neighborhood, city, country, zipcode, longitude, latitude, phone, open_hours, images, images_thumbs, is_open, business;

//------------------------------------
// Init & dealloc
//------------------------------------
#pragma mark -
#pragma mark Init & dealloc methods

- (id) initWithIdentifier:(NSString*) _identifier
                     name:(NSString*) _name
              description:(NSString*) _description
                  address:(NSString*) _address
			 cross_street:(NSString*) _cross_street
				 distance:(float) _distance
			distance_unit:(NSString*)_distance_unit
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
		description = [_description retain];
		address = [_address retain];
		
		cross_street = [_cross_street retain];
		distance = _distance;
		distance_unit = [_distance_unit retain];
		
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
	
	[cross_street release];
	[distance_unit release];
	
	[neighborhood release];
	[city release];
	[country release];
	[zipcode release];
	[phone release];
	[open_hours release];
	self.images = nil;
	self.images_thumbs = nil;
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

- (NSUInteger) numberOfUnlockReward 
{
	NSUInteger count = 0;
	for (KZReward *reward in rewards) {
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
