//
//  KZApplication.h
//  Kazdoor
//
//  Created by Rami on 11/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KZPlacesLibrary.h"
#import "KZPointsLibrary.h"
#import "KazdoorAppDelegate.h"
#import "LocationHelper.h"
#import "KZURLRequest.h"
#import "KZPlace.h"
#import "KZApplication.h"

//#define API_URL @"http://www.spinninghats.com"
//#define API_URL @"http://192.168.0.136:3000"
//#define API_URL @"http://localhost"
//#define API_URL @"http://localcashbery"
#define API_URL @"http://demo.espace.com.eg:9900"

@protocol ScanHandlerDelegate

- (void) scanHandlerCallback;

@end


@interface KZApplication : NSObject <KZURLRequestDelegate>
{
    KZPlacesLibrary *placesArchive;
    KZPointsLibrary *pointsArchive;
	LocationHelper *location_helper;
}

@property (nonatomic, retain) LocationHelper *location_helper;

+ (KZApplication*) shared;

+ (KazdoorAppDelegate *) getAppDelegate;

+ (void) setAppDelegate:(KazdoorAppDelegate *) delegate;

+ (NSString *) getFullName;

+ (void) setFullName:(NSString *) str_full_name;

+ (NSString *) getUserId;

+ (void) setUserId:(NSString *) str_user_id;

+ (NSString *) getAuthenticationToken;

+ (void) setAuthenticationToken:(NSString *) str_authentication_token;

+ (BOOL) isLoggedIn;


+ (void) handleScannedQRCard:(NSString*)qr_code withPlace:(KZPlace*)place withDelegate:(id<ScanHandlerDelegate>)delegate;

+ (NSMutableDictionary *) getAccounts;

+ (NSUInteger) getPointsForProgram:(NSString *)_program_id;

- (KZPlacesLibrary*) placesArchive;

- (KZPointsLibrary*) pointsArchive;



@end
