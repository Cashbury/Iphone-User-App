//
//  KZApplication.m
//  Kazdoor
//
//  Created by Rami on 11/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "KZApplication.h"

@implementation KZApplication

static KZApplication *shared = nil;

//#define API_URL @"http://192.168.0.19"
#define API_URL    @"http://demo.espace.com.eg:9900"

static NSString *LOCAL_POINTS     = @"points.archive";
static NSString *LOCAL_PLACES     = @"places.archive";
static NSString *user_id		  = nil;
static KazdoorAppDelegate *_delegate = nil;

@synthesize location_helper;

+ (KZApplication*) shared
{
    if (shared == nil)
    {
        shared = [[KZApplication alloc] init];
    }
    
    return shared;
}

+ (NSString *) getUserId{
	[user_id retain];
	[user_id autorelease];
	return user_id;
}

+ (void) setUserId:(NSString *) str_user_id {
	[user_id release];
	user_id = str_user_id;
	[user_id retain];
}

+ (BOOL) isLoggedIn {
	if (nil == user_id) {
		return NO;
	} else {
		return YES;
	}
}

+ (KazdoorAppDelegate *) getAppDelegate {
	[_delegate retain];
	[_delegate autorelease];
	return _delegate;
}

+ (void) setAppDelegate:(KazdoorAppDelegate *) delegate {
	[_delegate release];
	_delegate = delegate;
	[_delegate retain];
}


- (id) init
{
    self = [super init];

    if (self)
    {
        NSArray *_paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *_documentsDirectory = [_paths objectAtIndex:0];
        
        
        NSString *_localPoints = [_documentsDirectory stringByAppendingPathComponent:LOCAL_POINTS];
        NSString *_localPlaces = [_documentsDirectory stringByAppendingPathComponent:LOCAL_PLACES];
        
        pointsArchive = [[KZPointsLibrary alloc] initWithRootPath:_localPoints];
        placesArchive = [[KZPlacesLibrary alloc] initWithRootPath:_localPlaces apiURL:[NSURL URLWithString:API_URL]];
    }
    
    return self;
}

- (KZPlacesLibrary*) placesArchive { return placesArchive; }
- (KZPointsLibrary*) pointsArchive { return pointsArchive; }


@end
