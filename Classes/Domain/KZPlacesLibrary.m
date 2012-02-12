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
#import "KZUtils.h"
#import "KZReward.h"
#import "LocationHelper.h"
#import "KZApplication.h"
#import "KZOpenHours.h"
#import "KZCity.h"
#import "KZAccount.h"
#import "KZUserInfo.h"

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
+ (NSArray *) getPlaces {
    return [[self shared] places];
}


- (NSArray*)  places {
	return [places allValues];
}

//*/
- (void) requestPlacesWithKeywords:(NSString*)keywords {
	//NSString *path_component = [NSString stringWithFormat:@"places.xml?/%@/%@.xml", [LocationHelper getLongitude], [LocationHelper getLatitude]];
	if ([KZApplication getAppDelegate].dummy_splash_vc != nil) {
		[[KZApplication getAppDelegate].dummy_splash_vc setLoadingMessage:@"Loading"];
	} else {
		[KZApplication showLoadingScreen:@"Loading Places..."];
	}
	NSString *longitude = [LocationHelper getLongitude];
	NSString *latitude = [LocationHelper getLatitude];
	NSString *str_url;
	if (longitude == nil || latitude == nil) {
		longitude = @"";
		latitude = @"";
	}

	//latitude = @"29.952099";
	//longitude = @"31.221454";
	if (keywords == nil) keywords = @""; 
	str_url = [NSString stringWithFormat:@"%@/users/places.xml?lat=%@&long=%@&keywords=%@&auth_token=%@", API_URL, 
						 latitude, longitude, keywords, [KZUserInfo shared].auth_token];
	// add the city id if this is not the home city (city of long and lat)
	if ([KZCity isTheSelectedCityTheHomeCity] != YES && [KZCity getSelectedCityId] != nil) {
		str_url = [NSString stringWithFormat:@"%@&city_id=%@", str_url, [KZCity getSelectedCityId]];
	}
    NSMutableDictionary *_headers = [[NSMutableDictionary alloc] init];
    [_headers setValue:@"application/xml" forKey:@"Accept"];
    KZURLRequest *placesRequest = [[[KZURLRequest alloc] initRequestWithString:str_url andParams:nil delegate:self headers:_headers andLoadingMessage:nil] autorelease];
    [_headers release];
}

//------------------------------------------
// KZURLRequestDelegate methods
//------------------------------------------
#pragma mark KZURLRequestDelegate methods

- (void) KZURLRequest:(KZURLRequest *)theRequest didFailWithError:(NSError*)theError {
	NSLog([theError description]);
	[delegate didFailUpdatePlaces];
}


- (void) parseOpenHoursOfPlace:(KZPlace*)_place fromNode:(CXMLElement*)_node {
	///////////// Open Hours //////////////////////////
	_place.is_open = ([[_node stringFromChildNamed:@"is-open"] isEqual:@"true"] ? YES : NO);
	
	CXMLElement  *hours_node = [_node getChildByName:@"open-hours"];
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
	_place.open_hours = hours;
	[hours release];	
}

- (void) parseImagesOfPlace:(KZPlace*)_place fromNode:(CXMLElement*)_node {	
	
	CXMLElement  *images_node = [_node getChildByName:@"images"];
	NSArray *arr_images_nodes = [images_node children];
	NSString *text_node = @"text";
	_place.images_thumbs = [[[NSMutableArray alloc] init] autorelease];
	_place.images = [[[NSMutableArray alloc] init]  autorelease];

	for (CXMLElement *each_image_node in arr_images_nodes) {
		if ([text_node isEqualToString:[each_image_node name]]) continue;
		NSString *image_thumb_url = (NSString*)[each_image_node stringFromChildNamed:@"image-thumb-url"];
		NSString *image_url = (NSString*)[each_image_node stringFromChildNamed:@"image-url"];
		[_place.images addObject:[image_url retain]];
		[_place.images_thumbs addObject:[image_thumb_url retain]];
	}
}


- (void) parseAccountsFromNode:(CXMLElement*)_node {
	//////get accounts/////////////////////////////////
	CXMLElement  *accounts_node = [_node getChildByName:@"accounts"];//[[_node nodesForXPath:@"//accounts" error:nil] objectAtIndex:0];
	NSArray *arr_account_nodes = [accounts_node children];// nodesForXPath:@"//account" error:nil];
	NSString *text_node = @"text";
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
	
}

- (void) parseRewardsOfPlace:(KZPlace*)_place fromNode:(CXMLElement*)_node {
	//////get rewards/////////////////////////////////
	NSString *text_node = @"text";
	CXMLElement  *rewards_node = [_node getChildByName:@"rewards"];//[[_node nodesForXPath:@"//rewards" error:nil] objectAtIndex:0];
	NSArray *arr_reward_nodes = [rewards_node children];//[rewards_node nodesForXPath:@"//reward" error:nil];
	for (CXMLElement *each_reward_node in arr_reward_nodes) {
		if ([text_node isEqualToString:[each_reward_node name]]) continue;
		NSString *identifier = [each_reward_node stringFromChildNamed:@"reward-id"];
		if (identifier == nil) continue;
		KZReward *_reward = [[KZReward alloc] initWithRewardId:identifier
												  campaign_id:[each_reward_node stringFromChildNamed:@"campaign-id"] 
														 name:[each_reward_node stringFromChildNamed:@"name"] 
												 reward_image:[each_reward_node stringFromChildNamed:@"reward-image"] 
													 heading1:[each_reward_node stringFromChildNamed:@"heading1"] 
													 heading2:[each_reward_node stringFromChildNamed:@"heading2"] 
												   legal_term:[each_reward_node stringFromChildNamed:@"legal-term"] 
											how_to_get_amount:[each_reward_node stringFromChildNamed:@"how-to-get-amount"] 
												 fb_enjoy_msg:[each_reward_node stringFromChildNamed:@"fb-enjoy-msg"]
												fb_unlock_msg:[each_reward_node stringFromChildNamed:@"fb-unlock-msg"]
												needed_amount:[[each_reward_node stringFromChildNamed:@"needed-amount"] intValue]];
		if ([KZUtils isStringValid:[each_reward_node stringFromChildNamed:@"offer-available-until"]]) {
			NSDateFormatter *df = [[NSDateFormatter alloc] init];
			[df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
			_reward.offer_available_until = [df dateFromString:[each_reward_node stringFromChildNamed:@"offer-available-until"]];
			[df release];
		}
		if ([KZUtils isStringValid:[each_reward_node stringFromChildNamed:@"spend-exchange-rule"]]) _reward.spend_exchange_rule = [[each_reward_node stringFromChildNamed:@"spend-exchange-rule"] floatValue];
		BOOL add_reward = YES;
		if ([KZUtils isStringValid:[each_reward_node stringFromChildNamed:@"spend-until"]]) {
			NSDateFormatter *df = [[NSDateFormatter alloc] init];
			[df setDateFormat:@"yyyy-MM-dd"];
			_reward.spend_until = [df dateFromString:[each_reward_node stringFromChildNamed:@"spend-until"]];
			[df release];
			NSTimeInterval secondsBetween = [_reward.spend_until timeIntervalSinceDate:[NSDate date]];
			if (secondsBetween <= 0) add_reward = NO;
		}
		if ([KZUtils isStringValid:[each_reward_node stringFromChildNamed:@"reward-money-amount"]]) _reward.reward_money_amount = [[each_reward_node stringFromChildNamed:@"reward-money-amount"] floatValue];
		if ([KZUtils isStringValid:[each_reward_node stringFromChildNamed:@"reward-currency-symbol"]]) _reward.reward_currency_symbol = [each_reward_node stringFromChildNamed:@"reward-currency-symbol"];
		if ([KZUtils isStringValid:[each_reward_node stringFromChildNamed:@"is-spend"]]) {
			_reward.isSpendReward = [[each_reward_node stringFromChildNamed:@"is-spend"] isEqual:@"true"];
		} else {
			_reward.isSpendReward = NO;
		}
		if (add_reward) {
			[_place addReward:_reward];
			[[KZApplication getRewards] setObject:_reward forKey:_reward.reward_id];
		}
		[_reward release];
	}
}

- (NSString*) parseCityFromDocument:(CXMLDocument*)_document {
	NSString *city_id = [[_document nodeForXPath:@"//city-id" error:nil] stringValue];
	NSString *city_name = [[_document nodeForXPath:@"//city-name" error:nil] stringValue];
	NSString *flag_url = [[_document nodeForXPath:@"//flag-url" error:nil] stringValue];
	
	if (city_id != nil && [city_id isEqual:@""] != YES && city_name != nil && [city_name isEqual:@""] != YES) {
		BOOL is_home_city = [[[_document nodeForXPath:@"//is-my-city" error:nil] stringValue] isEqual:@"true"];
		[KZCity addCityWithId:city_id andName:city_name andFlagUrl:flag_url];
		[KZCity setSelectedCityId:city_id];
		if (is_home_city) {
			[KZCity setHomeCityId:city_id];
		}
	}
	return city_id;
}

- (void) KZURLRequest:(KZURLRequest *)theRequest didSucceedWithData:(NSData*)theData {
	[places removeAllObjects];
	[[KZApplication getRewards] removeAllObjects];
	[KZAccount clearAccounts];
	[[KZApplication getBusinesses] removeAllObjects];
	NSLog(@"--------------------------------------||||||");
	//NSString *str = [[NSString alloc] initWithData:theData encoding:NSUTF8StringEncoding];
	//NSLog(str);
	///[str release];
	//NSString *str = @"<?xml version=\"1.0\" encoding=\"UTF-8\"?><hash><is-my-city type=\"boolean\">true</is-my-city><city-id type=\"integer\">1</city-id><city-name>Alexandria</city-name><places type=\"array\"><place><address-id nil=\"true\"/><business-id type=\"integer\">1</business-id><created-at type=\"datetime\">2011-04-19T13:43:47Z</created-at><description>branch</description><id type=\"integer\">1</id><is-user-defined nil=\"true\"/><lat type=\"decimal\">29.1212</lat><long type=\"decimal\">39.222</long><name>Gleem's Branch</name><place-type-id nil=\"true\"/><time-zone>Cairo</time-zone><updated-at type=\"datetime\">2011-04-26T17:30:05Z</updated-at><brand-name>Brand1</brand-name><brand-image>http://www.mouseability.co.uk/images/bmw_logo.jpg</brand-image><is-open type=\"boolean\">false</is-open><open-hours type=\"array\"><open-hour><created-at type=\"datetime\">2011-04-26T17:08:37Z</created-at><day-no type=\"integer\">2</day-no><from type=\"datetime\">2011-04-26T17:08:37Z</from><id type=\"integer\">2</id><place-id type=\"integer\">1</place-id><to type=\"datetime\">2011-04-26T17:08:37Z</to><updated-at type=\"datetime\">2011-04-26T17:08:37Z</updated-at></open-hour></open-hours><accounts type=\"array\"><account><amount>5.000</amount><campaign-id>1</campaign-id><is-money nil=\"true\"/><measurement-type>Coffee Points</measurement-type></account><account><amount>9.000</amount><campaign-id>2</campaign-id><is-money nil=\"true\"/><measurement-type>Sandwitch Points</measurement-type></account><account><amount>10.000</amount><campaign-id>3</campaign-id><is-money nil=\"true\"/><measurement-type>Sandwitch Points</measurement-type></account></accounts><rewards type=\"array\"><reward><campaign-id>1</campaign-id><cost nil=\"true\"/><created-at type=\"datetime\">2011-04-19T13:52:20Z</created-at><description>Buy 10 cups of coffee, get one free</description><expiry-date nil=\"true\"/><foreign-identifier nil=\"true\"/><heading1>Buy 10 cups of coffee, get one free</heading1><heading2>sdfsdfsf</heading2><id type=\"integer\">1</id><is-active nil=\"true\"/><legal-term>A Legal Term</legal-term><max-claim>10</max-claim><max-claim-per-user>10</max-claim-per-user><name>A free Cup of coffee</name><needed-amount>10</needed-amount><numberOfRedeems>1</numberOfRedeems><offer-price>0.000</offer-price><redeemCount>1</redeemCount><reward-id>1</reward-id><sales-price nil=\"true\"/><start-date nil=\"true\"/><unlocked>1</unlocked><updated-at type=\"datetime\">2011-05-11T00:39:39Z</updated-at><reward-image>http://www.uniquely-portland-oregon.com/images/portland-coffee-cup.gif</reward-image><how-to-get-amount>A free cup of coffee gets you 1.0 amount</how-to-get-amount></reward><reward><campaign-id>1</campaign-id><cost nil=\"true\"/><created-at type=\"datetime\">2011-05-09T23:49:14Z</created-at><description nil=\"true\"/><expiry-date nil=\"true\"/><foreign-identifier nil=\"true\"/><heading1>Heading 1 Here</heading1><heading2>Heading 2 also</heading2><id type=\"integer\">3</id><is-active nil=\"true\"/><legal-term>some legal terms goes here</legal-term><max-claim>56</max-claim><max-claim-per-user>56</max-claim-per-user><name>sdfsf</name><needed-amount>5</needed-amount><numberOfRedeems>0</numberOfRedeems><offer-price>0.000</offer-price><redeemCount>0</redeemCount><reward-id>3</reward-id><sales-price nil=\"true\"/><start-date nil=\"true\"/><unlocked>0</unlocked><updated-at type=\"datetime\">2011-05-09T23:49:14Z</updated-at><reward-image>http://www.uniquely-portland-oregon.com/images/portland-coffee-cup.gif</reward-image><how-to-get-amount>A free cup of coffee gets you 1.0 amount</how-to-get-amount></reward><reward><campaign-id>1</campaign-id><cost nil=\"true\"/><created-at type=\"datetime\">2011-04-19T13:52:20Z</created-at><description>Buy 10 cups of coffee, get one free</description><expiry-date nil=\"true\"/><foreign-identifier nil=\"true\"/><heading1>Buy 10 cups of coffee, get one free</heading1><heading2>sdfsdfsf</heading2><id type=\"integer\">1</id><is-active nil=\"true\"/><legal-term>A Legal Term</legal-term><max-claim>10</max-claim><max-claim-per-user>10</max-claim-per-user><name>Cocoa Coffee</name><needed-amount>9</needed-amount><numberOfRedeems>1</numberOfRedeems><offer-price>0.000</offer-price><redeemCount>1</redeemCount><reward-id>5</reward-id><sales-price nil=\"true\"/><start-date nil=\"true\"/><unlocked>1</unlocked><updated-at type=\"datetime\">2011-05-11T00:39:39Z</updated-at><reward-image>http://www.uniquely-portland-oregon.com/images/portland-coffee-cup.gif</reward-image><how-to-get-amount>A free cup of cocoa gets you 1 points</how-to-get-amount></reward><reward><campaign-id>2</campaign-id><cost nil=\"true\"/><created-at type=\"datetime\">2011-04-19T13:52:20Z</created-at><description>Buy 10 cups of coffee, get one free</description><expiry-date nil=\"true\"/><foreign-identifier nil=\"true\"/><heading1>Buy 10 cups of coffee, get one free</heading1><heading2>sdfsdfsf</heading2><id type=\"integer\">1</id><is-active nil=\"true\"/><legal-term>A Legal Term</legal-term><max-claim>10</max-claim><max-claim-per-user>10</max-claim-per-user><name>Cocoa Coffee 1</name><needed-amount>15</needed-amount><numberOfRedeems>1</numberOfRedeems><offer-price>0.000</offer-price><redeemCount>1</redeemCount><reward-id>6</reward-id><sales-price nil=\"true\"/><start-date nil=\"true\"/><unlocked>1</unlocked><updated-at type=\"datetime\">2011-05-11T00:39:39Z</updated-at><reward-image nil=\"true\"/><how-to-get-amount>A free cup of cocoa gets you 1 points</how-to-get-amount></reward><reward><campaign-id>2</campaign-id><cost nil=\"true\"/><created-at type=\"datetime\">2011-04-19T13:52:20Z</created-at><description>Buy 10 cups of coffee, get one free</description><expiry-date nil=\"true\"/><foreign-identifier nil=\"true\"/><heading1>Buy 10 cups of coffee, get one free</heading1><heading2>sdfsdfsf</heading2><id type=\"integer\">1</id><is-active nil=\"true\"/><legal-term>A Legal Term</legal-term><max-claim>10</max-claim><max-claim-per-user>10</max-claim-per-user><name>Cocoa Coffee 2</name><needed-amount>4</needed-amount><numberOfRedeems>1</numberOfRedeems><offer-price>0.000</offer-price><redeemCount>1</redeemCount><reward-id>7</reward-id><sales-price nil=\"true\"/><start-date nil=\"true\"/><unlocked>1</unlocked><updated-at type=\"datetime\">2011-05-11T00:39:39Z</updated-at><reward-image nil=\"true\"/><how-to-get-amount>A free cup of cocoa gets you 1 points</how-to-get-amount></reward><reward><campaign-id>3</campaign-id><cost nil=\"true\"/><created-at type=\"datetime\">2011-04-19T13:52:20Z</created-at><description>Buy 10 cups of coffee, get one free</description><expiry-date nil=\"true\"/><foreign-identifier nil=\"true\"/><heading1>Buy 10 cups of coffee, get one free</heading1><heading2>sdfsdfsf</heading2><id type=\"integer\">1</id><is-active nil=\"true\"/><legal-term>A Legal Term</legal-term><max-claim>10</max-claim><max-claim-per-user>10</max-claim-per-user><name>Cocoa Coffee 3</name><needed-amount>20</needed-amount><numberOfRedeems>1</numberOfRedeems><offer-price>0.000</offer-price><redeemCount>1</redeemCount><reward-id>8</reward-id><sales-price nil=\"true\"/><start-date nil=\"true\"/><unlocked>1</unlocked><updated-at type=\"datetime\">2011-05-11T00:39:39Z</updated-at><reward-image nil=\"true\"/><how-to-get-amount>A free cup of cocoa gets you 1 points</how-to-get-amount></reward><reward><campaign-id>3</campaign-id><cost nil=\"true\"/><created-at type=\"datetime\">2011-04-19T13:52:20Z</created-at><description>Buy 10 cups of coffee, get one free</description><expiry-date nil=\"true\"/><foreign-identifier nil=\"true\"/><heading1>Buy 10 cups of coffee, get one free</heading1><heading2>sdfsdfsf</heading2><id type=\"integer\">1</id><is-active nil=\"true\"/><legal-term>A Legal Term</legal-term><max-claim>10</max-claim><max-claim-per-user>10</max-claim-per-user><name>Cocoa Coffee 4</name><needed-amount>999</needed-amount><numberOfRedeems>1</numberOfRedeems><offer-price>0.000</offer-price><redeemCount>1</redeemCount><reward-id>9</reward-id><sales-price nil=\"true\"/><start-date nil=\"true\"/><unlocked>1</unlocked><updated-at type=\"datetime\">2011-05-11T00:39:39Z</updated-at><reward-image nil=\"true\"/><how-to-get-amount>A free cup of cocoa gets you 1 points</how-to-get-amount></reward></rewards></place></places></hash>";
	//CXMLDocument *_document = [[[CXMLDocument alloc] initWithXMLString:str options:0 error:nil] autorelease];
	//[str release];
	CXMLDocument *_document = [[[CXMLDocument alloc] initWithData:theData options:0 error:nil] autorelease];
	//NSLog([_document description]);
	NSString* city_id = [self parseCityFromDocument:_document];

	NSArray *_nodes = [_document nodesForXPath:@"//place" error:nil];
	for (CXMLElement *_node in _nodes) {
        
        // Escape the Image URL
        NSString *_imageURLString = [[_node stringFromChildNamed:@"brand-image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
		KZBusiness* biz = [KZBusiness getBusinessWithIdentifier:[_node stringFromChildNamed:@"business-id"] 
														andName:[_node stringFromChildNamed:@"brand-name"] 
													andImageURL:[NSURL URLWithString:_imageURLString]];
		biz.has_user_id_card = ([[_node stringFromChildNamed:@"business-has-user-id-card"] isEqual:@"true"] ? YES : NO);
		
		//distance:[[_node stringFromChildNamed:@"distance"] floatValue]
		//distance_unit:[_node stringFromChildNamed:@"distance-unit"]
		double place_long = [[_node stringFromChildNamed:@"long"] doubleValue];
		double place_lat = [[_node stringFromChildNamed:@"lat"] doubleValue];
		double distance = 0.0;
		if ([KZUtils isStringValid:[_node stringFromChildNamed:@"long"]] && 
			[KZUtils isStringValid:[_node stringFromChildNamed:@"lat"]] && 
			[KZUtils isStringValid:[LocationHelper getLatitude]] && 
			[KZUtils isStringValid:[LocationHelper getLongitude]]) 
		{
			CLLocation *my_location = [[CLLocation alloc] initWithLatitude:[[LocationHelper getLatitude] doubleValue] longitude:[[LocationHelper getLongitude] doubleValue]];
			CLLocation *place_location = [[CLLocation alloc] initWithLatitude:place_lat longitude:place_long];
			distance = [my_location getDistanceFrom:place_location];
		}
		KZPlace *_place = [[KZPlace alloc] initWithIdentifier:[_node stringFromChildNamed:@"id"] 
														 name:[_node stringFromChildNamed:@"name"] 
                                                        about:[_node stringFromChildNamed:@"about"]  
													  address:[_node stringFromChildNamed:@"address1"] 
												 cross_street:[_node stringFromChildNamed:@"cross-street"]
													 distance:distance
												 neighborhood:[_node stringFromChildNamed:@"neighborhood"] 
														 city:city_id 
													  country:[_node stringFromChildNamed:@"country"] 
													  zipcode:[_node stringFromChildNamed:@"zipcode"] 
													longitude:place_long
													 latitude:place_lat
														phone:[_node stringFromChildNamed:@"phone"]];
		
		[self parseImagesOfPlace:_place fromNode:_node];
		[self parseOpenHoursOfPlace:_place fromNode:_node];
		[self parseAccountsFromNode:_node];
		[self parseRewardsOfPlace:_place fromNode:_node];
		
		[biz addPlace:_place];
		[places setObject:_place forKey:_place.identifier];

		[_place release];
								//NSLog(@"&&&&&&&&&&& %@ - %@ ", _place.identifier, _place.business.image_url);
	}
	[delegate didUpdatePlaces];
}



static KZPlacesLibrary *_shared = nil;
+ (KZPlacesLibrary*) shared {
	if (_shared == nil) {
		_shared = [[KZPlacesLibrary alloc] init];
	}
	return _shared;
}


/**
 Returns a list of rewards retrieved from all places to be shown on the outer cashburies screen.
 */
+ (NSArray*) getOuterRewards {
	NSArray* _places = [self getPlaces];
	NSMutableDictionary* rewards = [[[NSMutableDictionary alloc] init] autorelease];
	for (KZPlace* place in _places) {
		NSArray* _rewards = [place getRewards];
		for (KZReward* reward in _rewards) {
			if ([reward isUnlocked]) {
				[rewards setObject:reward forKey:reward.reward_id];
			}
		}
	}
	return (NSArray*)[rewards allValues];
}

+ (NSArray*) getNearByBusinessesWithIDCards {
	NSMutableDictionary* nearby = [[NSMutableDictionary alloc] init];
	NSArray* arr_places = [self getPlaces];
	NSUInteger i;
	NSUInteger count = [arr_places count];
	for (i = 0; i < count; i++) {
		KZPlace* place = (KZPlace*)[arr_places objectAtIndex:i];
		if (place.business.has_user_id_card) {
			[nearby setObject:place.business forKey:place.business.identifier];
		}
	}
	NSArray* arr = [nearby allValues];
	[nearby release];
	return arr;
}

@end
