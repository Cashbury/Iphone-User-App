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

//#define API_URL @"http://www.spinninghats.com"
//#define API_URL @"http://localcashbery"
#define API_URL    @"http://demo.espace.com.eg:9900"

static NSString *LOCAL_POINTS			= @"points.archive";
static NSString *LOCAL_PLACES			= @"places.archive";
static NSString *user_id				= nil;
static KazdoorAppDelegate *_delegate	= nil;
static NSMutableDictionary *accounts	= nil;
static NSMutableDictionary *places		= nil;
static NSMutableDictionary *rewards		= nil;

@synthesize location_helper;


+ (KZApplication*) shared {
    if (shared == nil)
    {
        shared = [[KZApplication alloc] init];
    }
    
    return shared;
}

+ (NSString *) getUserId {
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

+ (void) handleScannedQRCard:(NSString*) qr_code {
    // TODO, enhance the QR code matching 
	////TODO AHMED MAGDY work on QR Codes and request from server
    //NSString *_filter = @"(http://www.spinninghats.com\?){1,}.*";
    NSString *_filter = @"[a-z0-9A-Z]+";
    NSPredicate *_predicate = [NSPredicate
                               predicateWithFormat:@"SELF MATCHES %@", _filter];
    
    if ([_predicate evaluateWithObject:qr_code] == YES)
    {
        //[pointsArchive addPoints:1 forBusiness:self.place.businessIdentifier];
        UIAlertView *_alert = [[UIAlertView alloc] initWithTitle:@"We got you!"
                                                         message:@"+1 point"
                                                        delegate:nil
                                               cancelButtonTitle:@"Great"
                                               otherButtonTitles:nil];
        [_alert show];
        [_alert release];
    } else {
        UIAlertView *_alert = [[UIAlertView alloc] initWithTitle:@"Invalid Stamp"
                                                         message:@"The stamp you're trying to snap does not appear to be a valid CashBerry stamp."
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
        
        [_alert show];
        [_alert release];
    }	
}

+ (NSMutableDictionary *) getPlaces {
	if (places == nil) {
		places = [[NSMutableDictionary alloc] init];
	}
	return [[places retain] autorelease];
}

+ (NSMutableDictionary *) getAccounts {
	if (accounts == nil) {
		accounts = [[NSMutableDictionary alloc] init];
	}
	return [[accounts retain] autorelease];
}

+ (NSMutableDictionary *) getRewards {
	if (rewards == nil) {
		rewards = [[NSMutableDictionary alloc] init];
	}
	return [[rewards retain] autorelease];
}

- (id) init {
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
