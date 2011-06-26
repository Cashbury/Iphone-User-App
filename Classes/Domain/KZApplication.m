//
//  KZApplication.m
//  Kazdoor
//
//  Created by Rami on 11/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "KZApplication.h"
#import "CXMLElement.h"
#import "KZRewardViewController.h"
#import "EngagementSuccessViewController.h"
#import "KZPlace.h"
#import "LoadingViewController.h"
#import "KZUtils.h"
#import "KZAccount.h"

@implementation KZApplication

static KZApplication *shared			= nil;
static NSString *LOCAL_POINTS			= @"points.archive";
static NSString *LOCAL_PLACES			= @"places.archive";
static NSString *first_name				= nil;
static NSString *last_name				= nil;
static NSString *user_id				= nil;
static NSString *authentication_token	= nil;
static KazdoorAppDelegate *_delegate	= nil;
static KZPlace *current_place			= nil;
static NSMutableDictionary *rewards		= nil;
static NSMutableDictionary *businesses	= nil;
static LoadingViewController *loading_vc = nil;


@synthesize location_helper, place_vc;

+ (KZApplication*) shared {
    if (shared == nil)
    {
        shared = [[KZApplication alloc] init];
    }
    
    return shared;
}

+ (NSString *) getFirstName {
	return [[first_name retain] autorelease];
}

+ (NSString *) getLastName {
	return [[last_name retain] autorelease];
}

+ (void) setFirstName:(NSString *) _val{
	[first_name release];
	first_name = _val;
	[first_name retain];
}

+ (void) setLastName:(NSString *) _val{
	[last_name release];
	last_name = _val;
	[last_name retain];
}

+ (NSString *) getUserId {
	return [[user_id retain] autorelease];
}

+ (void) setUserId:(NSString *) str_user_id {
	[user_id release];
	user_id = str_user_id;
	[user_id retain];
}

+ (NSString *) getAuthenticationToken {
	[authentication_token retain];
	[authentication_token autorelease];
	return authentication_token;
}

+ (void) setAuthenticationToken:(NSString *) str_authentication_token {
	[authentication_token release];
	authentication_token = str_authentication_token;
	[authentication_token retain];
}

+ (BOOL) isLoggedIn {
	if (nil == user_id || nil == authentication_token) {
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

+ (NSMutableDictionary *) getRewards {
	if (rewards == nil) rewards = [[NSMutableDictionary alloc] init];
	return [[rewards retain] autorelease];
}

+ (NSMutableDictionary *) getBusinesses {
	if (businesses == nil) businesses = [[NSMutableDictionary alloc] init];
	return [[businesses retain] autorelease];
}

+ (void) showLoadingScreen:(NSString*)message {
	if (loading_vc == nil) {
		loading_vc = [[LoadingViewController alloc] initWithNibName:@"LoadingView" bundle:nil];
	}
	
	[[KZApplication getAppDelegate].window addSubview:loading_vc.view];
	CGPoint origin;
	origin.x = [KZApplication getAppDelegate].window.frame.size.width/2;
	origin.y = [KZApplication getAppDelegate].window.frame.size.height/2;
	[loading_vc.view setCenter:origin];
	if (message != nil) loading_vc.lblMessage.text = message;
}

+ (void) hideLoading {
	if (loading_vc == nil) return;
	[loading_vc.view removeFromSuperview];
}

+ (void) persistEmail:(NSString*)email andPassword:(NSString*)password andFirstName:(NSString*)_first_name andLastName:(NSString*)_last_name {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:email forKey:@"login_email"];
	[prefs setObject:password forKey:@"login_password"];
	if (_first_name != nil) [prefs setObject:_first_name forKey:@"login_first_name"];
	if (_last_name != nil) [prefs setObject:_last_name forKey:@"login_last_name"];
	[prefs setBool:YES forKey:@"login_is_logged_in"];
	[prefs synchronize];
}

+ (void) persistLogout {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:@"" forKey:@"login_email"];
	[prefs setObject:@"" forKey:@"login_password"];
	[prefs setObject:@"" forKey:@"login_name"];
	[prefs setBool:NO forKey:@"login_is_logged_in"];
	[prefs synchronize];
}

+ (BOOL) isLoggedInPersisted {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	return [prefs boolForKey:@"login_is_logged_in"];
}

//------------------------------------------------------------------------

- (id) init {
    self = [super init];
	
    if (self)
    {
        NSArray *_paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *_documentsDirectory = [_paths objectAtIndex:0];
        
        NSString *_localPoints = [_documentsDirectory stringByAppendingPathComponent:LOCAL_POINTS];
        NSString *_localPlaces = [_documentsDirectory stringByAppendingPathComponent:LOCAL_PLACES];
    }
    
    return self;
}

@end
