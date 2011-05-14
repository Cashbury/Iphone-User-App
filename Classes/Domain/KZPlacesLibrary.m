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
#import "KZOpenHours.h"
#import "KZCity.h"
#import "KZAccount.h"

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
- (void) requestPlacesWithKeywords:(NSString*)keywords {
	//NSString *path_component = [NSString stringWithFormat:@"places.xml?/%@/%@.xml", [LocationHelper getLongitude], [LocationHelper getLatitude]];
	NSString *longitude = [LocationHelper getLongitude];
	NSString *latitude = [LocationHelper getLatitude];
	NSString *str_url;
	if (longitude != nil && latitude != nil) {
		longitude = @"";
		latitude = @"";
	}
	if (keywords == nil) keywords = @""; 

	str_url = [NSString stringWithFormat:@"%@/users/places.xml?lat=%@&long=%@&keywords=%@&auth_token=%@", API_URL, 
						 //@"31.221454", @"29.952099"];
						 latitude, longitude, keywords, [KZApplication getAuthenticationToken]];
    NSURL *_url = [NSURL URLWithString:str_url];
    NSMutableDictionary *_headers = [[NSMutableDictionary alloc] init];
    [_headers setValue:@"application/xml" forKey:@"Accept"];
    KZURLRequest *placesRequest = [[KZURLRequest alloc] initRequestWithURL:_url delegate:self headers:_headers];
    [_headers release];
	[placesRequest autorelease];
}

//------------------------------------------
// KZURLRequestDelegate methods
//------------------------------------------
#pragma mark KZURLRequestDelegate methods

- (void) KZURLRequest:(KZURLRequest *)theRequest didFailWithError:(NSError*)theError {
	[delegate didFailUpdatePlaces];
}

- (CXMLElement*) getChild:(CXMLElement*)node byName:(NSString*)child_name {
	for (CXMLElement *child in [node children]) {
		if ([child_name isEqualToString:[child name]]) {
			return child;
		}
	}
}

- (void) KZURLRequest:(KZURLRequest *)theRequest didSucceedWithData:(NSData*)theData {
		/*
		 <?xml version=\"1.0\" encoding=\"UTF-8\"?>
		 <hash>
			<places type=\"array\">
				<place>
					<address-id nil=\"true\"/>
					<business-id type=\"integer\">1</business-id>
					<created-at type=\"datetime\">2011-04-19T13:43:47Z</created-at>
					<description>branch</description>
					<id type=\"integer\">1</id>
					<is-user-defined nil=\"true\"/>
					<lat type=\"decimal\">29.1212</lat>
					<long type=\"decimal\">39.222</long>
					<name>Gleem's Branch</name>
					<place-type-id nil=\"true\"/>
					<time-zone>Cairo</time-zone>
					<updated-at type=\"datetime\">2011-04-26T17:30:05Z</updated-at>
					<brand-name>Brand1</brand-name>
					<is-open type=\"boolean\">false</is-open>
					<open-hours type=\"array\">
						<open-hour>
							<created-at type=\"datetime\">2011-04-26T17:08:37Z</created-at>
							<day-no type=\"integer\">2</day-no>
							<from type=\"datetime\">2011-04-26T17:08:37Z</from>
							<id type=\"integer\">2</id>
							<place-id type=\"integer\">1</place-id>
							<to type=\"datetime\">2011-04-26T17:08:37Z</to>
							<updated-at type=\"datetime\">2011-04-26T17:08:37Z</updated-at>
						</open-hour>
					</open-hours>
					<accounts type=\"array\"/>
					<rewards type=\"array\"/>
				</place>
			</places>
		 </hash>
		*/
	[places removeAllObjects];
	[[KZApplication getRewards] removeAllObjects];
	[KZAccount clearAccounts];
	[[KZApplication getBusinesses] removeAllObjects];
	
	//////FIXME comment these 3 lines and uncomment the one next to them
	NSString *str = @"<?xml version=\"1.0\" encoding=\"UTF-8\"?><hash><is-my-city type=\"boolean\">true</is-my-city><city-id type=\"integer\">1</city-id><city-name>Alexandria</city-name><places type=\"array\"><place><address-id type=\"integer\">5</address-id><business-id type=\"integer\">1</business-id><country-name>Egypt</country-name><created-at type=\"datetime\">2011-04-19T13:43:47Z</created-at><description>branch</description><distance>0</distance><id type=\"integer\">1</id><is-user-defined nil=\"true\"/><lat type=\"decimal\">31.211333</lat><long type=\"decimal\">29.933538</long><name>Gleem's Branch</name><neighborhood>Gamal Abd El-Naser</neighborhood><place-type-id nil=\"true\"/><street-address>Miami</street-address><time-zone>International Date Line West</time-zone><updated-at type=\"datetime\">2011-05-11T00:26:52Z</updated-at><user-id nil=\"true\"/><zipcode>21111</zipcode><brand-name>Brand1</brand-name><brand-image>http://s3.amazonaws.com/cashbury-dev/brands/5/thumb/Lake_mapourika_NZ.jpeg</brand-image><is-open type=\"boolean\">false</is-open><open-hours type=\"array\"><open-hour><from>05:08 PM</from><to>05:08 PM</to><place-id type=\"integer\">1</place-id><day>Tuesday</day></open-hour></open-hours><accounts type=\"array\"><account><amount>20.000</amount><campaign-id>1</campaign-id><measurement-type-id>1</measurement-type-id></account></accounts><rewards type=\"array\"><reward><campaign-id>1</campaign-id><cost nil=\"true\"/><created-at type=\"datetime\">2011-04-19T13:52:20Z</created-at><description>Buy 10 cups of coffee, get one free</description><expiry-date nil=\"true\"/><foreign-identifier nil=\"true\"/><heading1>Buy 10 cups of coffee, get one free</heading1><heading2>sdfsdfsf</heading2><id type=\"integer\">1</id><is-active nil=\"true\"/><legal-term>A Legal Term</legal-term><max-claim>10</max-claim><max-claim-per-user>10</max-claim-per-user><name>A free Cup of coffee</name><needed-amount>10</needed-amount><numberOfRedeems>1</numberOfRedeems><offer-price>0.000</offer-price><redeemCount>1</redeemCount><reward-id>1</reward-id><sales-price nil=\"true\"/><unlocked>0</unlocked><updated-at type=\"datetime\">2011-05-11T00:39:39Z</updated-at><reward-image nil=\"true\"/><how-to-get-amount>A free cup of coffee gets you 1.0 amount</how-to-get-amount></reward><reward><campaign-id>1</campaign-id><cost nil=\"true\"/><created-at type=\"datetime\">2011-05-09T23:49:14Z</created-at><description nil=\"true\"/><expiry-date nil=\"true\"/><foreign-identifier nil=\"true\"/><heading1>sfsf</heading1><heading2>sfsf</heading2><id type=\"integer\">3</id><is-active nil=\"true\"/><legal-term>sdfsfsf</legal-term><max-claim>56</max-claim><max-claim-per-user>56</max-claim-per-user><name>sdfsf</name><needed-amount>15</needed-amount><numberOfRedeems>0</numberOfRedeems><offer-price>0.000</offer-price><redeemCount>0</redeemCount><reward-id>3</reward-id><sales-price nil=\"true\"/><unlocked>0</unlocked><updated-at type=\"datetime\">2011-05-09T23:49:14Z</updated-at><reward-image>http://s3.amazonaws.com/cashbury-dev/rewards/36/thumb/Lake_mapourika_NZ.jpeg</reward-image><how-to-get-amount>A free cup of coffee gets you 1.0 amount</how-to-get-amount></reward></rewards></place></places></hash>";
	NSLog(str);
	CXMLDocument *_document = [[[CXMLDocument alloc] initWithXMLString:str options:0 error:nil] autorelease];
	[str release];
	//CXMLDocument *_document = [[[CXMLDocument alloc] initWithData:theData options:0 error:nil] autorelease];
	
	NSString *city_id = [[_document nodeForXPath:@"//city-id" error:nil] stringValue];
	NSString *city_name = [[_document nodeForXPath:@"//city-name" error:nil] stringValue];
	
	if (city_id != nil && [city_id isEqual:@""] != YES && city_name != nil && [city_name isEqual:@""] != YES) {
		BOOL is_home_city = [[[_document nodeForXPath:@"//is-my-city" error:nil] stringValue] isEqual:@"true"];
		[KZCity addCityWithId:city_id andName:city_name];
		[KZCity setSelectedCityId:city_id];
		if (is_home_city) {
			[KZCity setHomeCityId:city_id];
		}
		NSLog(@"# Put City Name in Screen Title: %@", city_name);
	}


	NSArray *_nodes = [_document nodesForXPath:@"//place" error:nil];
	for (CXMLElement *_node in _nodes) {
		NSString *_placeId = [_node stringFromChildNamed:@"id"];
		NSString *_placeName = [_node stringFromChildNamed:@"name"];
		NSLog(@"Place name: : %@\n\n", _placeName);
		NSString *_placeDescription = [_node stringFromChildNamed:@"description"];
		NSString *_businessId = [_node stringFromChildNamed:@"business-id"];
		if ([_businessId isEqual:@""]) _businessId = nil; 
			
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
		_place.businessName = [_node stringFromChildNamed:@"brand-name"];
		//////FIXME [_node stringFromChildNamed:@"business-name"];
		_place.phone = [_node stringFromChildNamed:@"phone"]; ////FIXME uncomment this
		if (_businessId != nil) [[KZApplication getBusinesses] setObject:_place.businessName forKey:_businessId];
		// Issue a request for the rewards
		//[self requestRewardsForPlace:_place];
		_place.brand_image = [_node stringFromChildNamed:@"brand-image"];
		
		///////////// Open Hours //////////////////////////
		_place.is_open = ([[_node stringFromChildNamed:@"is-open"] isEqual:@"true"] ? YES : NO);

		CXMLElement  *hours_node = [self getChild:_node byName:@"open-hours"];
		NSArray *arr_hours_nodes = [hours_node children];
		NSString *text_node = @"text";
		NSMutableArray *hours = [[NSMutableArray alloc] init];
		KZOpenHours *hour;
		for (CXMLElement *each_hours_node in arr_hours_nodes) {
			if ([text_node isEqualToString:[each_hours_node name]]) continue;
			NSString *day = [each_hours_node stringFromChildNamed:@"day"];
			if (day == nil) continue;
				
			hour = [[KZOpenHours alloc] initWithDay:day andFromTime:[each_hours_node stringFromChildNamed:@"from"] andToTime:[each_hours_node stringFromChildNamed:@"to"]];
			[hours addObject:hour];
			[hour release];
		}
		_place.open_hours = [[[NSArray alloc] initWithArray:hours] autorelease];
		[hours release];
		//////get accounts/////////////////////////////////
		CXMLElement  *accounts_node = [self getChild:_node byName:@"accounts"];//[[_node nodesForXPath:@"//accounts" error:nil] objectAtIndex:0];
		NSArray *arr_account_nodes = [accounts_node children];// nodesForXPath:@"//account" error:nil];
		//NSString *text_node = @"text";
		for (CXMLElement *each_account_node in arr_account_nodes) {
			if ([text_node isEqualToString:[each_account_node name]]) continue;
			NSString *_campaign_id = [each_account_node stringFromChildNamed:@"campaign-id"];
			if (_campaign_id == nil) continue;
			NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
			[f setNumberStyle:NSNumberFormatterDecimalStyle];
			NSNumber * _balance = [f numberFromString:[each_account_node stringFromChildNamed:@"amount"]];
			[f release];
			
			[KZAccount setAccountWithCampaignId:_campaign_id andAmount:_balance andMeasurementType:[each_account_node stringFromChildNamed:@"measurement-type"] 
									 andisMoney:[each_account_node stringFromChildNamed:@"is-money"]];
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
																	campaign_id:[each_ureward_node stringFromChildNamed:@"campaign-id"]
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
				//if ([[each_reward_node stringFromChildNamed:@"engagement-id"] intValue] < 1) continue;
				NSString *identifier = [each_reward_node stringFromChildNamed:@"id"];
				if (identifier == nil) continue;
				KZReward *_reward = [[KZReward alloc] initWithIdentifier:identifier
																	name:[each_reward_node stringFromChildNamed:@"name"]
																	description:[each_reward_node stringFromChildNamed:@"description"]
																	points:[[each_reward_node stringFromChildNamed:@"needed-amount"] intValue]
																	campaign_id:[each_reward_node stringFromChildNamed:@"campaign-id"]
																	engagement_id:[each_reward_node stringFromChildNamed:@"engagement-id"]
									 ];
				_reward.isAutoUnlock = NO;
				_reward.reward_image = [each_reward_node stringFromChildNamed:@"reward-image"];
				_reward.claim = [[each_reward_node stringFromChildNamed:@"claim"] intValue];
				_reward.redeemCount = [[each_reward_node stringFromChildNamed:@"redeemCount"] intValue];
				_reward.legal_term = [each_reward_node stringFromChildNamed:@"legal-term"];
				[_place addReward:_reward];
				[[KZApplication getRewards] setObject:_reward forKey:_reward.identifier];
				[_reward release];
			}
			
            [places setObject:_place forKey:_placeId];
            [_place release];
        }
		[delegate didUpdatePlaces];
	
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
