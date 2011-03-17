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

@interface KZApplication : NSObject
{
    KZPlacesLibrary *placesArchive;
    KZPointsLibrary *pointsArchive;
	LocationHelper *location_helper;
}

@property (nonatomic, retain) LocationHelper *location_helper;

+ (KZApplication*) shared;

+ (KazdoorAppDelegate *) getAppDelegate;

+ (void) setAppDelegate:(KazdoorAppDelegate *) delegate;

+ (NSString *) getUserId;

+ (void) setUserId:(NSString *) str_user_id;

+ (BOOL) isLoggedIn;

+ (void) handleScannedQRCard:(NSString*) qr_code;

+ (NSMutableDictionary *) getPlaces;

+ (NSMutableDictionary *) getAccounts;

+ (NSMutableDictionary *) getRewards;

- (KZPlacesLibrary*) placesArchive;

- (KZPointsLibrary*) pointsArchive;



@end
