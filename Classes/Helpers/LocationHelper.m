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

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	// handle error 
	NSLog(@"##### %@", [error description]);
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cashbury" message:@"Sorry could not get your current location please make sure that you have enable location services from your mobile settings." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alert show];
	[alert release];
}

- (void)dealloc {
	[self.location_manager release];
	[super dealloc];
}







+ (NSString *) getLongitude {
	[_longitude retain];
	[_longitude autorelease];
	return _longitude;
}


+ (NSString *) getLatitude {
	[_latitude retain];
	[_latitude autorelease];
	return _latitude;
}

@end
