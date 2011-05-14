//
//  KZCity.h
//  Cashbery
//
//  Created by Basayel Said on 5/11/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CXMLElement+Helpers.h"
#import "TouchXML.h"
#import "KZURLRequest.h"

@protocol CitiesDelegate <NSObject>

- (void) gotCities:(NSMutableDictionary *)_cities;

- (void) gotError:(NSString*)_error;

@end


@interface KZCity : NSObject <KZURLRequestDelegate> {
	id<CitiesDelegate> delegate;
}

+ (NSString *) getSelectedCityName;
+ (NSString *) getSelectedCityId;
+ (NSString *) getHomeCityId;
+ (NSString *) getCityNameById:(NSString*)_city_id;
+ (BOOL) isTheSelectedCityTheHomeCity;
+ (void) addCityWithId:(NSString *)_city_id andName:(NSString*) _city_name;
+ (void) setSelectedCityId:(NSString *)_selected_city_id;
+ (void) setHomeCityId:(NSString *)_home_city_id;

- (void) getCitiesFromServer:(id<CitiesDelegate>)_delegate;
- (void) KZURLRequest:(KZURLRequest *)theRequest didFailWithError:(NSError *)theError;
- (void) KZURLRequest:(KZURLRequest *)theRequest didSucceedWithData:(NSData *)theData;


@end
