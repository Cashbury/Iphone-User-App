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

- (id) initWithRootPath:(NSString*)thePath apiURL:(NSURL*)theapiURL
{
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
        
        [self unarchive];
    }
    return self;
}

- (void) dealloc
{
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

- (NSArray*) places
{
    return [places allValues];
}

- (void) requestPlaces
{

	//NSString *path_component = [NSString stringWithFormat:@"places.xml?/%@/%@.xml", [LocationHelper getLongitude], [LocationHelper getLatitude]];
	NSString *longitude = [LocationHelper getLongitude];
	NSString *latitude = [LocationHelper getLatitude];
	NSString *str_url;
	if (longitude != nil && latitude != nil) { 
	str_url = [NSString stringWithFormat:@"%@%@/%@/%@.xml", 
						 [apiURL absoluteString], @"places", 
						 //@"31.221454", @"29.952099"];
						 latitude, longitude];
	} else {
		str_url = [NSString stringWithFormat:@"%@places.xml", [apiURL absoluteString]];
	}
	//str_url = [NSString stringWithFormat:@"%@places.xml", [apiURL absoluteString]];
    NSURL *_url = [NSURL URLWithString:str_url];
    
    NSMutableDictionary *_headers = [[NSMutableDictionary alloc] init];
    
    [_headers setValue:@"application/xml" forKey:@"Accept"];
    
    placesRequest = [[KZURLRequest alloc] initRequestWithURL:_url
                                                             delegate:self
                                                              headers:_headers];
    
    [_headers release];
}

//------------------------------------------
// KZURLRequestDelegate methods
//------------------------------------------
#pragma mark KZURLRequestDelegate methods

- (void) KZURLRequest:(KZURLRequest *)theRequest didFailWithError:(NSError*)theError
{
    if (theRequest == placesRequest)
    {
        [delegate didFailUpdatePlaces];
    }
}

- (void) KZURLRequest:(KZURLRequest *)theRequest didSucceedWithData:(NSData*)theData
{
    if (theRequest == placesRequest)
    {
        CXMLDocument *_document = [[[CXMLDocument alloc] initWithData:theData options:0 error:nil] autorelease];
        
        NSArray *_nodes = [_document nodesForXPath:@"//place" error:nil];
        
        for (CXMLElement *_node in _nodes)
        {
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
            
            // Issue a request for the rewards
            [self requestRewardsForPlace:_place];

            [places setObject:_place forKey:_placeId];
            
            [_place release];
        }
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

- (void) requestRewardsForPlace:(KZPlace *)thePlace
{
    NSURL *_url = [apiURL URLByAppendingPathComponent:[NSString stringWithFormat:@"businesses/%@/rewards",thePlace.businessIdentifier]];
    
    NSMutableDictionary *_headers = [[NSMutableDictionary alloc] init];
    
    [_headers setValue:@"application/xml" forKey:@"Accept"];
    
    KZURLRequest *_request = [[KZURLRequest alloc] initRequestWithURL:_url
                                                    delegate:self
                                                     headers:_headers];
    
    [requests setObject:_request forKey:thePlace.identifier];
    
    [_headers release];
}

- (void) processRewardsRequest:(KZURLRequest *)theRequest data:(NSData *)theData
{
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

- (void) archive
{
    NSMutableData *_data = [[NSMutableData alloc] init];
    NSKeyedArchiver *_archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:_data];
    
    [_archiver encodeObject:places forKey:PLACES];
    [_archiver finishEncoding];
    
    [_data writeToFile:rootPath atomically:YES];
    
    [_archiver release];
    [_data release];
}

- (void) unarchive
{
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

@end
