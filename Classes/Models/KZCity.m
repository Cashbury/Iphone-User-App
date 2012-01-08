//
//  KZCity.m
//  Cashbury
//
//  Created by Basayel Said on 5/11/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import "KZCity.h"
#import "KZApplication.h"
#import "KZUserInfo.h"

//------------------------------------------
// Notifications
//------------------------------------------
#pragma mark - Notifications

NSString * const KZCityDidChangeSelectedCityNotification     = @"KZCityDidChangeSelectedCityNotification";

@implementation KZCity

static NSMutableDictionary *cities = nil;	// the hash of all cities supported by the system (city_id => city_name)
static NSMutableDictionary *flags = nil;	// the hash of all flags supported by the system (city_id => city_flag)
static NSString *selected_city_id = nil;	// the city that the user selected to show its places
static NSString *home_city_id = nil;	// the city that the user is in now (long, lat)

@synthesize delegate;

+ (NSString *) getSelectedCityName {
	return [KZCity getCityNameById:selected_city_id];
}

+ (NSString *) getSelectedCityId {
	return [[selected_city_id retain] autorelease];
}

+ (NSString *) getHomeCityId {
	return [[home_city_id retain] autorelease];
}

+ (NSString *) getCityNameById:(NSString*)_city_id {
	if (_city_id == nil) {
		return @"Unknown City";
	} else {
		return [[[cities objectForKey:_city_id] retain] autorelease];
	}
}

+ (NSURL *) getCityFlagUrlByCityId:(NSString*)_city_id {
	if (_city_id == nil) {
		return nil;
	} else {
		NSLog(@"%@", [flags description]);
		return [NSURL URLWithString:[flags objectForKey:_city_id]];
	}
}

+ (BOOL) isTheSelectedCityTheHomeCity {
	if (home_city_id == nil || [home_city_id isEqual:@""]) return NO;
	if (selected_city_id == nil || [selected_city_id isEqual:@""]) return NO;
	return ([selected_city_id isEqual:home_city_id]);
}

+ (BOOL) isSelectedCity:(NSString*)_city_id {
	return [selected_city_id isEqual:_city_id];
}

+ (BOOL) isHomeCity:(NSString*)_city_id {
	return [home_city_id isEqual:_city_id];
}

+ (void) addCityWithId:(NSString *)_city_id andName:(NSString*) _city_name andFlagUrl:(NSString*) _flag_url {
	if (cities == nil) {
		cities = [[NSMutableDictionary alloc] init];
		flags = [[NSMutableDictionary alloc] init];
	}
	[cities setObject:_city_name forKey:_city_id];
	if (_flag_url != nil) [flags setObject:_flag_url forKey:_city_id];
}

+ (void) clearCities {
	if (cities != nil) {
		[cities removeAllObjects];
		[flags removeAllObjects];
	}
}

+ (void) setSelectedCityId:(NSString *)_selected_city_id {
	[selected_city_id release];
	selected_city_id = [_selected_city_id retain];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KZCityDidChangeSelectedCityNotification object:selected_city_id];
}

+ (void) setHomeCityId:(NSString *)_home_city_id {
	[home_city_id release];
	home_city_id = [_home_city_id retain];
}

//----------------------------------------------------------

- (void) getCitiesFromServer:(id<CitiesDelegate>)_delegate {
	self.delegate = _delegate;
	NSMutableDictionary *_headers = [[NSMutableDictionary alloc] init];
	[_headers setValue:@"application/xml" forKey:@"Accept"];
	//list_all_cities.xml
	NSLog([NSString stringWithFormat:@"%@/users/list_all_cities.xml?auth_token=%@",
		   API_URL, [KZUserInfo shared].auth_token]);
	req = [[KZURLRequest alloc] initRequestWithString:[NSString stringWithFormat:@"%@/users/list_all_cities.xml?auth_token=%@", 
													   API_URL, [KZUserInfo shared].auth_token]
											andParams:nil delegate:self headers:_headers andLoadingMessage:@"Loading..."];
	[_headers release];
}


- (void) KZURLRequest:(KZURLRequest *)theRequest didFailWithError:(NSError*)theError {
	if (self.delegate != nil) {
		[self.delegate gotError:theError];
	}
	[req release];
}

// response with all supported cities
- (void) KZURLRequest:(KZURLRequest *)theRequest didSucceedWithData:(NSData*)theData {
	/*
	 <?xml version="1.0" encoding="UTF-8"?>
	 <cities type="array">
		<city>
			<id type="integer">1</id>
			<name>Alexandria</name>
			<flag_url>http://localhost:3000/images/countries/eg.png</flag_url>
		</city>
	 </cities>
	 */
	// FIXME uncomment the line next to the next one
	//CXMLDocument *_document = [[CXMLDocument alloc] initWithXMLString:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><cities type=\"array\"><city><id type=\"integer\">1</id><name>Alexandria</name></city><city><id type=\"integer\">2</id><name>San Francisco</name></city></cities>" options:0 error:nil];
	//NSLog([_document description]);
	CXMLDocument *_document = [[CXMLDocument alloc] initWithData:theData options:0 error:nil];
	NSArray *_nodes = [_document nodesForXPath:@"//city" error:nil];
	[KZCity clearCities];
	for (CXMLElement *_node in _nodes) {
		[KZCity addCityWithId:[_node stringFromChildNamed:@"id"] 
					  andName:[_node stringFromChildNamed:@"name"]
					  andFlagUrl:[_node stringFromChildNamed:@"flag_url"]];
	}
	[_document release];
	if (self.delegate != nil) {
		[self.delegate gotCities:cities andFlags:flags];
	}
	[req release];
}

@end
