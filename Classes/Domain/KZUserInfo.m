//
//  KZUserInfo.m
//  Cashbery
//
//  Created by Basayel Said on 7/20/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import "KZUserInfo.h"


@implementation KZUserInfo

static KZUserInfo* shared = nil;

@synthesize auth_token,
			user_id,
			email,
			password,
			facebook_username,
			first_name,
			last_name,
			cashier_business,
			is_logged_in,
			current_profile,
			currency_code,
			flag_url,
            facebookID;

+ (KZUserInfo*) shared {
	if (shared == nil) {
		shared = [[KZUserInfo alloc] init];
		[shared wakeup];
	}
	return shared;
}

- (BOOL) isLoggedIn {
	if (nil == self.user_id || nil == self.auth_token) {
		return NO;
	} else {
		return YES;
	}
}




- (void) persistData {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:self.email forKey:@"login_email"];
	[prefs setObject:self.password forKey:@"login_password"];
	if (self.first_name != nil) [prefs setObject:self.first_name forKey:@"login_first_name"];
	if (self.last_name != nil) [prefs setObject:self.last_name forKey:@"login_last_name"];
	if (self.facebook_username != nil) [prefs setObject:self.facebook_username forKey:@"login_facebook_username"];
	
	if (self.current_profile == nil) self.current_profile = @"life";
	[prefs setObject:self.current_profile forKey:@"current_profile"];
	[prefs setObject:self.currency_code forKey:@"currency_code"];
	[prefs setObject:self.flag_url forKey:@"flag_url"];
	
	[prefs setBool:self.is_logged_in forKey:@"login_is_logged_in"];
    [prefs setObject:self.facebookID forKey:@"facebook_id"];
    
	[prefs synchronize];
}

- (void) wakeup {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	self.email = [prefs stringForKey:@"login_email"];
	self.password = [prefs stringForKey:@"login_password"];
	self.first_name = [prefs stringForKey:@"login_first_name"];
	self.last_name = [prefs stringForKey:@"login_last_name"];
	self.is_logged_in = [prefs boolForKey:@"login_is_logged_in"];
	self.facebook_username = [prefs stringForKey:@"login_facebook_username"];
	self.current_profile = [prefs stringForKey:@"current_profile"];
	self.currency_code = [prefs stringForKey:@"currency_code"];
	self.flag_url = [prefs stringForKey:@"flag_url"];
    self.facebookID = [prefs stringForKey:@"facebook_id"];
	if (self.current_profile == nil) self.current_profile = @"life";
}

- (void) clearPersistedData {
	self.email = @"";
	self.password = @"";
	self.first_name = @"";
	self.last_name = @"";
	self.facebook_username = @"";
	self.is_logged_in = NO;
	self.current_profile = @"life";
    self.facebookID = @"";
	self.currency_code = nil;
	self.flag_url = nil;
	
	[self persistData];
	
}

- (BOOL) isCredentialsPersistsed {
	return self.is_logged_in;
}

- (NSString*) getFullName {
	return [NSString stringWithFormat:@"%@ %@", self.first_name, self.last_name];
}

- (NSString*) getShortName
{
    NSString *_last = [self.last_name substringToIndex:1];
	return [NSString stringWithFormat:@"%@ %@.", self.first_name, _last];
}

@end
