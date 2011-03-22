//
//  KZPlacesLibrary.m
//  Kazdoor
//
//  Created by Rami on 12/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#define PLACES @"places"    // NSCoder Key

#import "KZPlacesLibrary.h"
#import "CXMLElement+Helpers.h"
#import "TouchXML.h"
#import "KZPlace.h"
#import "KZReward.h"
#import "LocationHelper.h"
#import "KZApplication.h"

@interface KZPlacesLibrary (PrivateMethods)
- (void) requestRewardsForPlace:(KZPlace *)thePlace;
- (void) processRewardsRequest:(KZURLRequest *)theRequest data:(NSData *)theData;
- (void) archive;
- (void) unarchive;
@end



@implementation KZPlacesLibrary

@synthesize delegate;

//------------------------------------------
// Init & dealloc
//------------------------------------------
#pragma mark Init & dealloc

- (id) initWithRootPath:(NSString*)thePath apiURL:(NSURL*)theapiURL {
    if (self = [super init])
    {
        NSString *_originalUrl = [theapiURL absoluteString];
        
        if(![_originalUrl hasSuffix:@"/"])
        {
            // make sure the url ends with / as it should point to a context, not a file
            apiURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/", _originalUrl]];
        }
        else
        {
            apiURL = [theapiURL copy];
        }
        
        rootPath = [thePath copy];
        requests = [[NSMutableDictionary alloc] init];
        
        //queue = [[NSOperationQueue alloc] init];
        //[queue setMaxConcurrentOperationCount:2];
        
        //[self unarchive];
    }
    return self;
}

- (id) init {
	self = [super init];
	if (nil != self) {
		places = [[NSMutableDictionary alloc] init];
	}
	return self;
}
- (void) dealloc {
    [rootPath release];
    [apiURL release];
    [places release];
    [requests release];
    
    [super dealloc];
}

//------------------------------------------
// Public methods
//------------------------------------------
#pragma mark Public methods
///*
- (NSArray *) places {
    return [places allValues];
}
//*/
- (void) requestPlaces {
	NSLog(@">>>>>> Request Places visited.");
	//NSString *path_component = [NSString stringWithFormat:@"places.xml?/%@/%@.xml", [LocationHelper getLongitude], [LocationHelper getLatitude]];
	NSString *longitude = [LocationHelper getLongitude];
	NSString *latitude = [LocationHelper getLatitude];
	NSString *str_url;
	if (longitude != nil && latitude != nil) { 
		str_url = [NSString stringWithFormat:@"%@/users/places/%@/%@.xml?auth_token=%@", API_URL, 
						 //@"31.221454", @"29.952099"];
						 latitude, longitude, [KZApplication getAuthenticationToken]];
	} else {
		str_url = [NSString stringWithFormat:@"%@/users/places.xml?auth_token=%@", API_URL, [KZApplication getAuthenticationToken]];
	}
	NSLog(@"%@", str_url);
	//str_url = [NSString stringWithFormat:@"%@places.xml?auth_token=%@", API_URL, [KZApplication getAuthenticationToken]];
    NSURL *_url = [NSURL URLWithString:str_url];
    NSMutableDictionary *_headers = [[NSMutableDictionary alloc] init];
    [_headers setValue:@"application/xml" forKey:@"Accept"];
    placesRequest = [[KZURLRequest alloc] initRequestWithURL:_url delegate:self headers:_headers];
    [_headers release];
}

//------------------------------------------
// KZURLRequestDelegate methods
//------------------------------------------
#pragma mark KZURLRequestDelegate methods

- (void) KZURLRequest:(KZURLRequest *)theRequest didFailWithError:(NSError*)theError {
	
	NSLog(@".........Failed");
    if (theRequest == placesRequest)
    {
        [delegate didFailUpdatePlaces];
    }
}

- (CXMLElement*) getChild:(CXMLElement*)node byName:(NSString*)child_name {
	for (CXMLElement *child in [node children]) {
		if ([child_name isEqualToString:[child name]]) {
			return child;
		}
	}
}

- (void) KZURLRequest:(KZURLRequest *)theRequest didSucceedWithData:(NSData*)theData {
    if (theRequest == placesRequest)
    {
		/*
		 <?xml version="1.0" encoding="UTF-8"?>
		 <hash>
			<places type="array">
				<place>
					<address1>Roshdy</address1>
					<address2 nil="true"></address2>
					<business-id type="integer">4</business-id>
					<city>Alexandria</city>
					<country>Egypt</country>
					<created-at type="datetime">2011-03-13T16:17:18Z</created-at>
					<description nil="true"></description>
					<distance>0.107172254720329</distance>
					<id type="integer">7</id>
					<lat type="decimal">29.952099</lat>
					<long type="decimal">31.221454</long>
					<name>Alex</name>
					<neighborhood nil="true"></neighborhood>
					<updated-at type="datetime">2011-03-13T16:51:12Z</updated-at>
					<zipcode>21131</zipcode>

					<accounts type="array">
						<account>
							<points>10</points>
							<program-id>1</program-id>
						</account>
					</accounts>
		 
					<rewards type="array"/>
		 
					<auto-unlock-rewards type="array"/>
				</place>
			</places>
		 </hash>
		 
		*/
		NSString *str = [[NSString alloc] initWithData:theData encoding:NSUTF8StringEncoding];
		NSLog(@"##Response XML######## %@", str);
        [str release];
		
        CXMLDocument *_document = [[[CXMLDocument alloc] initWithData:theData options:0 error:nil] autorelease];
		NSArray *_nodes = [_document nodesForXPath:@"//place" error:nil];
        for (CXMLElement *_node in _nodes) {
            NSString *_placeId = [_node stringFromChildNamed:@"id"];
            NSString *_placeName = [_node stringFromChildNamed:@"name"];
            NSString *_placeDescription = [_node stringFromChildNamed:@"description"];
            NSString *_businessId = [_node stringFromChildNamed:@"business-id"];
            
            NSString *_placeAddress = [_node stringFromChildNamed:@"address1"];
            NSString *_placeNeighborhood = [_node stringFromChildNamed:@"neighborhood"];
            NSString *_placeCity = [_node stringFromChildNamed:@"city"];
            NSString *_placeCountry = [_node stringFromChildNamed:@"country"];
            NSString *_placeZipCode = [_node stringFromChildNamed:@"zipcode"];

            double _placeLat = [[_node stringFromChildNamed:@"lat"] doubleValue];
            double _placeLong = [[_node stringFromChildNamed:@"long"] doubleValue];
            
            KZPlace *_place = [[KZPlace alloc] initWithIdentifier:_placeId
                                                             name:_placeName
                                                      description:_placeDescription
                                                       businessId:_businessId
                                                          address:_placeAddress
                                                     neighborhood:_placeNeighborhood
                                                             city:_placeCity
                                                          country:_placeCountry
                                                          zipcode:_placeZipCode
                                                        longitude:_placeLat
                                                         latitude:_placeLong];
            _place.businessName = [_node stringFromChildNamed:@"business-name"];
			[[KZApplication getBusinesses] setObject:_place.businessName forKey:_businessId];
            // Issue a request for the rewards
            //[self requestRewardsForPlace:_place];
			
			//////get accounts/////////////////////////////////
			CXMLElement  *accounts_node = [self getChild:_node byName:@"accounts"];//[[_node nodesForXPath:@"//accounts" error:nil] objectAtIndex:0];
			NSLog(@"Accounts_node %@", [accounts_node name]);
			NSArray *arr_account_nodes = [accounts_node children];// nodesForXPath:@"//account" error:nil];
			NSString *text_node = @"text";
			for (CXMLElement *each_account_node in arr_account_nodes) {
				if ([text_node isEqualToString:[each_account_node name]]) continue;
				NSMutableDictionary *accounts = [KZApplication getAccounts];
				[accounts	setObject:[each_account_node stringFromChildNamed:@"points"] 
							forKey:[each_account_node stringFromChildNamed:@"program-id"]];
			}
			/*
			//////get auto-unlock rewards/////////////////////////////////
			CXMLElement  *urewards_node = [[_node nodesForXPath:@"//auto-unlock-rewards" error:nil] objectAtIndex:0];
			NSArray *arr_ureward_nodes = [urewards_node nodesForXPath:@"//reward" error:nil];
			for (CXMLElement *each_ureward_node in arr_ureward_nodes) {
				KZReward *_ureward = [[KZReward alloc] initWithIdentifier:[each_ureward_node stringFromChildNamed:@"id"]
																	name:[each_ureward_node stringFromChildNamed:@"name"]
																	description:[each_ureward_node stringFromChildNamed:@"description"]
																	points:[[each_ureward_node stringFromChildNamed:@"points"] intValue]
																	program_id:[each_ureward_node stringFromChildNamed:@"program-id"]
																	engagement_id:[each_ureward_node stringFromChildNamed:@"engagement-id"]];
				_ureward.isAutoUnlock = YES;
				[_place addReward:_ureward];
				[_ureward release];
			}
			*/
			//////get rewards/////////////////////////////////
			CXMLElement  *rewards_node = [self getChild:_node byName:@"rewards"];//[[_node nodesForXPath:@"//rewards" error:nil] objectAtIndex:0];
			NSArray *arr_reward_nodes = [rewards_node children];//[rewards_node nodesForXPath:@"//reward" error:nil];
			for (CXMLElement *each_reward_node in arr_reward_nodes) {
				if ([text_node isEqualToString:[each_reward_node name]]) continue;
				KZReward *_reward = [[KZReward alloc] initWithIdentifier:[each_reward_node stringFromChildNamed:@"id"]
																	name:[each_reward_node stringFromChildNamed:@"name"]
																	description:[each_reward_node stringFromChildNamed:@"description"]
																	points:[[each_reward_node stringFromChildNamed:@"points"] intValue]
																	program_id:[each_reward_node stringFromChildNamed:@"program-id"]
																	engagement_id:[each_reward_node stringFromChildNamed:@"engagement-id"]
									 ];
				_reward.isAutoUnlock = NO;
				_reward.unlocked = ([[each_reward_node stringFromChildNamed:@"unlocked"] intValue] == 1 ? YES : NO);
				[_place addReward:_reward];
				[[KZApplication getRewards] setObject:_reward forKey:_reward.identifier];
				[_reward release];
			}
			
            [places setObject:_place forKey:_placeId];
            [_place release];
        }
		[delegate didUpdatePlaces];
		NSLog(@"####@@@### %d\n", [[places allValues] count]);
    }
    else
    {
        [self processRewardsRequest:theRequest data:theData];
    }

}

//------------------------------------------
// Private methods
//------------------------------------------
#pragma mark Private methods
/*
- (void) requestRewardsForPlace:(KZPlace *)thePlace {
    NSURL *_url = [apiURL URLByAppendingPathComponent:[NSString stringWithFormat:@"businesses/%@/rewards",thePlace.businessIdentifier]];
    NSMutableDictionary *_headers = [[NSMutableDictionary alloc] init];
    [_headers setValue:@"application/xml" forKey:@"Accept"];
    KZURLRequest *_request = [[KZURLRequest alloc] initRequestWithURL:_url delegate:self headers:_headers];
    [requests setObject:_request forKey:thePlace.identifier];
    [_headers release];
}

- (void) processRewardsRequest:(KZURLRequest *)theRequest data:(NSData *)theData {
    NSString *_placeId = [[requests allKeysForObject:theRequest] objectAtIndex:0];
    KZPlace *_place = [places objectForKey:_placeId];
    
    CXMLDocument *_document = [[[CXMLDocument alloc] initWithData:theData options:0 error:nil] autorelease];
    
    NSArray *_nodes = [_document nodesForXPath:@"//reward" error:nil];
    
    for (CXMLElement *_node in _nodes)
    {
        NSString *_rewardId = [_node stringFromChildNamed:@"id"];
        NSString *_rewardName = [_node stringFromChildNamed:@"name"];
        NSString *_rewardDescription = [_node stringFromChildNamed:@"description"];
        NSInteger _rewardPoints = [[_node stringFromChildNamed:@"points"] intValue];
        
        KZReward *_reward = [[KZReward alloc] initWithIdentifier:_rewardId
                                                         name:_rewardName
                                                  description:_rewardDescription
                                                   points:_rewardPoints];
        
        [_place addReward:_reward];
        [_reward release];
    }
    
    [requests removeObjectForKey:_placeId];
    
    if ([requests count] == 0)
    {
        [self archive];
        
        [delegate didUpdatePlaces];
    }
}

- (void) archive {
    NSMutableData *_data = [[NSMutableData alloc] init];
    NSKeyedArchiver *_archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:_data];
    
    [_archiver encodeObject:places forKey:PLACES];
    [_archiver finishEncoding];
    
    [_data writeToFile:rootPath atomically:YES];
    
    [_archiver release];
    [_data release];
}

- (void) unarchive {
    if([[NSFileManager defaultManager] fileExistsAtPath:rootPath])
    {
        NSData *_data = [[NSData alloc] initWithContentsOfFile:rootPath];
        
        // will return nil instead of throwing an exception if there is an error reading the archive
        NSKeyedUnarchiver *_unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:_data];
        
        places = [[_unarchiver decodeObjectForKey:PLACES] retain];
        [_unarchiver finishDecoding];
        
        [_unarchiver release];
        [_data release];    
    }
    
    if(places == nil)
    {
        // defensive, this shouldn't happen, but if it does make sure the app is in a state to work
        places = [NSMutableDictionary new];
    }
}
*/
@end
