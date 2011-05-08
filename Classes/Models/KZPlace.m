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

@synthesize identifier, name, description, businessIdentifier, businessName, address, neighborhood, city, country, zipcode, longitude, latitude, phone, open_hours, is_open;

//------------------------------------
// Init & dealloc
//------------------------------------
#pragma mark -
#pragma mark Init & dealloc methods

- (id) initWithIdentifier:(NSString*) theIdentifier
                     name:(NSString*) theName
              description:(NSString*) theDescription
               businessId:(NSString*) theBusinessIdentifier
                  address:(NSString*) theAddress
             neighborhood:(NSString*) theNeighborhood
                     city:(NSString*) theCity
                  country:(NSString*) theCountry
                  zipcode:(NSString*) theZipCode
                longitude:(double) theLongitude
                 latitude:(double) theLatitude
{
    if (self = [super init])
    {
        identifier = [theIdentifier retain];
        name = [theName retain];
        description = [theDescription retain];
        businessIdentifier = [theBusinessIdentifier retain];
        
        address = [theAddress retain];
        neighborhood = [theNeighborhood retain];
        city = [theCity retain];
        country = [theCountry retain];
        zipcode = [theZipCode retain];
        
        longitude = theLongitude;
        latitude = theLatitude;
        
        rewards = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (id) initWithCoder:(NSCoder*)aDecoder
{
    if(self = [super init])
    {
        identifier = [[aDecoder decodeObjectForKey:IDENTIFIER] retain];
        name = [[aDecoder decodeObjectForKey:NAME] retain];
        description = [[aDecoder decodeObjectForKey:DESCRIPTION] retain];
        businessIdentifier = [[aDecoder decodeObjectForKey:BUSINESS_ID] retain];
        
        address = [[aDecoder decodeObjectForKey:ADDRESS] retain];
        neighborhood = [[aDecoder decodeObjectForKey:NEIGHBORHOOD] retain];
        city = [[aDecoder decodeObjectForKey:CITY] retain];
        country = [[aDecoder decodeObjectForKey:COUNTRY] retain];
        zipcode = [[aDecoder decodeObjectForKey:ZIPCODE] retain];
        
        longitude = [aDecoder decodeDoubleForKey:LONGITUDE];
        latitude = [aDecoder decodeDoubleForKey:LATITUDE];
        
        rewards = [[aDecoder decodeObjectForKey:REWARDS] retain];
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder*)aCoder
{
    [aCoder encodeObject:identifier forKey:IDENTIFIER];
    [aCoder encodeObject:name forKey:NAME];
    [aCoder encodeObject:description forKey:DESCRIPTION];
    [aCoder encodeObject:businessIdentifier forKey:BUSINESS_ID];
    
    [aCoder encodeObject:address forKey:ADDRESS];
    [aCoder encodeObject:neighborhood forKey:NEIGHBORHOOD];
    [aCoder encodeObject:city forKey:CITY];
    [aCoder encodeObject:country forKey:COUNTRY];
    [aCoder encodeObject:zipcode forKey:ZIPCODE];
    
    [aCoder encodeDouble:longitude forKey:LONGITUDE];
    [aCoder encodeDouble:latitude forKey:LATITUDE];
    
    [aCoder encodeObject:rewards forKey:REWARDS];
}

- (void) dealloc
{
    [identifier release];
    [name release];
    [description release];
    [businessIdentifier release];
   // [open_hours release];
    [address retain];
    [neighborhood retain];
    [city retain];
    [country retain];
    [zipcode retain];
    
    [rewards release];
    
    [super dealloc];
}

//------------------------------------
// Public methods
//------------------------------------
#pragma mark -
#pragma mark Public methods

- (void) addReward:(KZReward *)theReward
{
    theReward.place = self;
    [rewards addObject:theReward];
}
/*
- (NSArray *) rewards {
	NSMutableArray *new_rewards = [[NSMutableArray alloc] init];
	NSArray *ids = [[KZApplication getRewards] allKeys];
	for (KZReward* reward in rewards) {
		if (![ids containsObject:reward.identifier]) {
			[rewards removeObject:reward];
		}
	}
	return rewards;
}
*/
- (NSArray*) rewards
{
    return rewards;
}

- (BOOL) hasAutoUnlockReward {
	BOOL has = NO;
	for (KZReward *reward in rewards) {
		if (reward.unlocked) {
			has = YES;
			break;
		}
	}
	return has;
}

@end
