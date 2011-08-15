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
static KazdoorAppDelegate *_delegate	= nil;
//static KZPlace *current_place			= nil;
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


@end
