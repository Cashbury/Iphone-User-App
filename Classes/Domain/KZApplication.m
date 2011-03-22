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

@implementation KZApplication

static KZApplication *shared = nil;

static NSString *LOCAL_POINTS			= @"points.archive";
static NSString *LOCAL_PLACES			= @"places.archive";
static NSString *full_name				= nil;
static NSString *user_id				= nil;
static NSString *authentication_token	= nil;
static KazdoorAppDelegate *_delegate	= nil;
static NSMutableDictionary *accounts	= nil;
static KZPlace *current_place = nil;
static NSMutableDictionary *rewards = nil;
static NSMutableDictionary *businesses = nil;
static id<ScanHandlerDelegate> _scanDelegate = nil;

static KZRewardViewController* reward_vc = nil;
static LoadingViewController *loading_vc = nil;

@synthesize location_helper;

+ (KZApplication*) shared {
    if (shared == nil)
    {
        shared = [[KZApplication alloc] init];
    }
    
    return shared;
}

+ (NSString *) getFullName {
	return [[full_name retain] autorelease];
}

+ (void) setFullName:(NSString *) str_full_name{
	[full_name release];
	full_name = str_full_name;
	[full_name retain];
}


+ (KZRewardViewController *) getRewardVC {
	return [[reward_vc retain] autorelease];
}

+ (void) setRewardVC:(KZRewardViewController *) _reward_vc {
	[reward_vc release];
	reward_vc = _reward_vc;
	[reward_vc retain];
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


+ (void) handleScannedQRCard:(NSString*) qr_code withPlace:(KZPlace*)place withDelegate:(id<ScanHandlerDelegate>)delegate; {
	current_place = place;
	_scanDelegate = delegate;
    // TODO, enhance the QR code matching 
	////TODO AHMED MAGDY work on QR Codes and request from server
    //NSString *_filter = @"(http://www.spinninghats.com\?){1,}.*";
    NSString *_filter = @"[a-z0-9A-Z]+";
    NSPredicate *_predicate = [NSPredicate
                               predicateWithFormat:@"SELF MATCHES %@", _filter];
    
    if ([_predicate evaluateWithObject:qr_code] == YES)
    {
		NSMutableDictionary *_headers = [[NSMutableDictionary alloc] init];
		[_headers setValue:@"application/xml" forKey:@"Accept"];
		KZURLRequest *req = [[KZURLRequest alloc] initRequestWithString:
							 [NSString stringWithFormat:@"%@/users/users_snaps/qr_code/%@.xml?auth_token=%@&long=%@&lat=%@", 
							  API_URL, qr_code, [KZApplication getAuthenticationToken], 
							  [LocationHelper getLongitude], [LocationHelper getLatitude]] 
							delegate:shared headers:nil];
		[_headers release];
		
        //[pointsArchive addPoints:1 forBusiness:self.place.businessIdentifier];
        
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

+ (NSMutableDictionary *) getAccounts {
	if (accounts == nil) {
		accounts = [[NSMutableDictionary alloc] init];
	}
	return [[accounts retain] autorelease];
}

+ (NSUInteger) getPointsForProgram:(NSString *)_program_id {
	NSMutableDictionary *accounts = [KZApplication getAccounts];
	return [((NSString*)[accounts objectForKey:_program_id]) intValue];
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
        placesArchive = [[KZPlacesLibrary alloc] init];//]WithRootPath:_localPlaces apiURL:[NSURL URLWithString:API_URL]];
    }
    
    return self;
}

- (KZPlacesLibrary*) placesArchive { return placesArchive; }

- (KZPointsLibrary*) pointsArchive { return pointsArchive; }

- (void) KZURLRequest:(KZURLRequest *)theRequest didFailWithError:(NSError*)theError {
	UIAlertView *_alert = [[UIAlertView alloc] initWithTitle:@"Invalid Stamp"
													 message:@"The stamp you're trying to snap does not appear to be a valid CashBerry stamp."
													delegate:nil
										   cancelButtonTitle:@"OK"
										   otherButtonTitles:nil];
	
	[_alert show];
	[_alert release];
}

/// Snap Card HTTP Callback
- (void) KZURLRequest:(KZURLRequest *)theRequest didSucceedWithData:(NSData*)theData {
		
        CXMLDocument *_document = [[[CXMLDocument alloc] initWithData:theData options:0 error:nil] autorelease];
        NSArray *_nodes = [_document nodesForXPath:@"//snap" error:nil];

		for (CXMLElement *_node in _nodes) {
			NSString *business_id = [_node stringFromChildNamed:@"business-id"];
			NSString *business_name = [_node stringFromChildNamed:@"business-name"];
			NSString *program_id = [_node stringFromChildNamed:@"program-id"];
			NSUInteger engagement_points = [[_node stringFromChildNamed:@"engagements-points"] intValue];
			NSString *account_points = [_node stringFromChildNamed:@"account-points"];
			
			NSMutableDictionary *accounts = [KZApplication getAccounts];
			[accounts setValue:account_points forKey:program_id];

			[[KZApplication getRewardVC] didUpdatePoints];
			
			//if (nil != _scanDelegate) [_scanDelegate scanHandlerCallback];
			
			UINavigationController *nav = [KZApplication getAppDelegate].navigationController;
			
			NSLog(@"DATA: %@", business_name);
			EngagementSuccessViewController *eng_vc = [[EngagementSuccessViewController alloc] initWithNibName:@"EngagementSuccessView" bundle:nil];
			
			[nav setNavigationBarHidden:YES animated:NO];
			[nav setToolbarHidden:YES animated:NO];
			[nav pushViewController:eng_vc animated:YES];
			
			
			
			eng_vc.lblBusinessName.text = business_name;
			eng_vc.lblBranchAddress.text = (current_place != nil) ? current_place.address : @"";
			
			NSString *plural = @"";
			if (engagement_points > 1) {
				plural = @"s";
			}
			eng_vc.lblPoints.text = [NSString stringWithFormat:@"You just earned %d point%@. Nice!", engagement_points, plural];
			eng_vc.share_string = [NSString stringWithFormat:@"I have just earned %d point%@. from %@.", engagement_points, plural, business_name];
			// set time and date
			NSDate* date = [NSDate date];
			NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
			[formatter setDateFormat:@"hh:mm:ss a MM.dd.yyyy"];
			NSString* str = [formatter stringFromDate:date];
			eng_vc.lblTime.text = str;
			
			
			[eng_vc release];
			/*
			// Alert
			UIAlertView *_alert = [[UIAlertView alloc] initWithTitle:@"Congratulations"
															 message:[NSString stringWithFormat:@"You have earned %@ points", engagement_points]
															delegate:nil
												   cancelButtonTitle:@"OK"
												   otherButtonTitles:nil];
			
			[_alert show];
			[_alert release];
			 */
        }
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
