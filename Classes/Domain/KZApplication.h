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
#import "KZPlaceViewDelegate.h"

//////////FIXME URL change this before deployment
//#define API_URL @"http://192.168.0.136:3000"	// Basayel
//#define API_URL @"http://localcashbery"
//#define API_URL @"http://192.168.0.19"
//#define API_URL @"http://demo.espace.com.eg:9900"

#define API_URL @"http://cashnode.cashbury.com"
//#define API_URL @"http://www.cashbury.com"

@protocol ScanHandlerDelegate

- (void) scanHandlerCallback;

@end


@interface KZApplication : NSObject
{
	LocationHelper *location_helper;
}

@property (nonatomic, retain) LocationHelper *location_helper;
@property (nonatomic, retain) id<KZPlaceViewDelegate> place_vc;

+ (KZApplication*) shared;

+ (KazdoorAppDelegate *) getAppDelegate;

+ (void) setAppDelegate:(KazdoorAppDelegate *) delegate;


+ (void) showLoadingScreen:(NSString*)message;

+ (void) hideLoading;


@end
