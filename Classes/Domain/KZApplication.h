//
//  KZApplication.h
//  Kazdoor
//
//  Created by Rami on 11/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KazdoorAppDelegate.h"
#import "LocationHelper.h"
#import "KZURLRequest.h"
#import "KZPlace.h"
#import "KZApplication.h"
#import "KZPlaceViewDelegate.h"

//////////FIXME change this before deployment
//#define API_URL @"http://192.168.0.136:3000"	// Basayel
//////////#define API_URL @"http://localcashbery"
//#define API_URL @"http://192.168.0.19"
//#define API_URL @"http://demo.espace.com.eg:9900"
#define API_URL @"http://www.cashbury.com"

@protocol ScanHandlerDelegate

- (void) scanHandlerCallback;

@end


@interface KZApplication : NSObject <KZURLRequestDelegate>
{
	LocationHelper *location_helper;
}

@property (nonatomic, retain) LocationHelper *location_helper;
@property (nonatomic, retain) id<KZPlaceViewDelegate> place_vc;

+ (KZApplication*) shared;

+ (KazdoorAppDelegate *) getAppDelegate;

+ (void) setAppDelegate:(KazdoorAppDelegate *) delegate;

+ (NSString *) getFirstName;

+ (NSString *) getLastName;

+ (void) setFirstName:(NSString *) _val;

+ (void) setLastName:(NSString *) _val;

+ (NSString *) getUserId;

+ (void) setUserId:(NSString *) str_user_id;

+ (NSString *) getAuthenticationToken;

+ (void) setAuthenticationToken:(NSString *) str_authentication_token;

+ (BOOL) isLoggedIn;

+ (void) handleScannedQRCard:(NSString*)qr_code withPlace:(KZPlace*)place withDelegate:(id<ScanHandlerDelegate>)delegate;


+ (void) showLoadingScreen:(NSString*)message;

+ (void) hideLoading;

+ (void) persistEmail:(NSString*)email andPassword:(NSString*)password andFirstName:(NSString*)_first_name andLastName:(NSString*)_last_name;

+ (void) persistLogout;

+ (BOOL) isLoggedInPersisted;



@end
