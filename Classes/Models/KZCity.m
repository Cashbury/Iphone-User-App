//
//  KZCity.m
//  Cashbery
//
//  Created by Basayel Said on 5/11/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import "KZCity.h"
#import "KZApplication.h"


@implementation KZCity

static NSMutableDictionary *cities = nil;	// the hash of all cities supported by the system (city_id => city_name)
static NSString *selected_city_id = nil;	// the city that the user selected to show its places
static NSString *home_city_id = nil;	// the city that the user is in now (long, lat)


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

+ (BOOL) isTheSelectedCityTheHomeCity {
	return ([selected_city_id isEqual:home_city_id]);
}


+ (void) addCityWithId:(NSString *)_city_id andName:(NSString*) _city_name {
	if (cities == nil) {
		cities = [[NSMutableDictionary alloc] init];
	}
	[cities setObject:_city_name forKey:_city_id];
}

+ (void) setSelectedCityId:(NSString *)_selected_city_id {
	[selected_city_id release];
	selected_city_id = [_selected_city_id retain];
}

+ (void) setHomeCityId:(NSString *)_home_city_id {
	[home_city_id release];
	home_city_id = [_home_city_id retain];
}

//----------------------------------------------------------

- (void) getCitiesFromServer:(id<CitiesDelegate>)_delegate {
	[delegate release];
	delegate = [_delegate retain];
	
	NSMutableDictionary *_headers = [[NSMutableDictionary alloc] init];
	[_headers setValue:@"application/xml" forKey:@"Accept"];
	KZURLRequest *req = [[KZURLRequest alloc] initRequestWithString:
						 [NSString stringWithFormat:@"%@/users/list_all_cities.xml?auth_token=%@&long=%@&lat=%@", 
						  API_URL, [KZApplication getAuthenticationToken], 
						  [LocationHelper getLongitude], [LocationHelper getLatitude]] 
														   delegate:self headers:nil];
	[_headers release];
}


- (void) KZURLRequest:(KZURLRequest *)theRequest didFailWithError:(NSError*)theError {
	if (delegate != nil) {
		[delegate gotError:theError];
	}
	
}

// response with all supported cities
- (void) KZURLRequest:(KZURLRequest *)theRequest didSucceedWithData:(NSData*)theData {
	
	CXMLDocument *_document = [[[CXMLDocument alloc] initWithData:theData options:0 error:nil] autorelease];
	NSArray *_nodes = [_document nodesForXPath:@"//city" error:nil];
	
	for (CXMLElement *_node in _nodes) {
		[KZCity addCityWithId:[_node stringFromChildNamed:@"id"] 
					  andName:[_node stringFromChildNamed:@"name"]];
	}
	[_document release];
	
	if (delegate != nil) {
		[delegate gotCities:cities];
	}
}

@end
