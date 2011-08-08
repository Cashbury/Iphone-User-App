//
//  LocationHelper.m
//  Cashbury
//
//  Created by Basayel Said on 3/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LocationHelper.h"


@implementation LocationHelper

static NSString * _longitude = nil;
static NSString * _latitude = nil;
static BOOL gave_error_once = YES;	////////FIXME change it to NO

@synthesize location_manager;

- (id)init {
	self = [super init];
	
	if(self != nil) {
		self.location_manager = [[CLLocationManager alloc] init];
		self.location_manager.delegate = self;
		[self.location_manager startUpdatingLocation];
	}
	
	return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	CLLocationCoordinate2D coords = [newLocation coordinate];
	[_longitude release];
	[_latitude release];
	_longitude = [[NSString alloc] initWithFormat:@"%lf", coords.longitude];
	_latitude = [[NSString alloc] initWithFormat:@"%lf", coords.latitude];
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	if (gave_error_once) return; 
	// handle error 
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cashbury" message:@"Sorry could not get your current location please make sure that you have enable location services from your mobile settings." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alert show];
	[alert release];
	gave_error_once = YES;
}

- (void)dealloc {
	[self.location_manager release];
	[super dealloc];
}







+ (NSString *) getLongitude {
	[_longitude retain];
	[_longitude autorelease];
	if (_longitude == nil) return @""; 
	return _longitude;
}


+ (NSString *) getLatitude {
	[_latitude retain];
	[_latitude autorelease];
	if (_latitude == nil) return @"";
	return _latitude;
}

@end
