//
//  KZPlace.h
//  Kazdoor
//
//  Created by Rami on 17/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KZBusiness.h"

@class KZBusiness;
@class KZReward;

@interface KZPlace : NSObject
{
    NSMutableArray *rewards;
	NSArray *open_hours;
}

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
					phone:(NSString *)_phone;


@property (readonly, nonatomic) NSString* identifier;
@property (readonly, nonatomic) NSString* name;
@property (readonly, nonatomic) NSString* description;
@property (readonly, nonatomic) NSString* address;
@property (readonly, nonatomic) NSString* neighborhood;
@property (readonly, nonatomic) NSString* city;
@property (readonly, nonatomic) NSString* country;
@property (readonly, nonatomic) NSString* zipcode;
@property (readonly, nonatomic) double longitude;
@property (readonly, nonatomic) double latitude;
@property (readonly, nonatomic) NSString* phone;

@property (assign, nonatomic) KZBusiness* business;

@property (retain, nonatomic) NSArray* open_hours;
@property (nonatomic) BOOL is_open;

- (void) addReward:(KZReward*)theReward;

- (BOOL) hasAutoUnlockReward;

- (NSArray *) getRewards;

@end
