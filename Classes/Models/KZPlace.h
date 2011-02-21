//
//  KZPlace.h
//  Kazdoor
//
//  Created by Rami on 17/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KZReward;

@interface KZPlace : NSObject
{
    NSMutableArray *rewards;
}

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
                 latitude:(double) theLatitude;

@property (readonly, nonatomic) NSString *identifier;
@property (readonly, nonatomic) NSString *name;
@property (readonly, nonatomic) NSString *description;
@property (readonly, nonatomic) NSString *businessIdentifier;

//Address info
@property (readonly, nonatomic) NSString *address;
@property (readonly, nonatomic) NSString *neighborhood;
@property (readonly, nonatomic) NSString *city;
@property (readonly, nonatomic) NSString *country;
@property (readonly, nonatomic) NSString *zipcode;

@property (readonly, nonatomic) double longitude;
@property (readonly, nonatomic) double latitude;

- (void) addReward:(KZReward *)theReward;

- (NSArray *) rewards;

@end
