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
static id<ScanHandlerDelegate> _scanDelegate = nil;
static KZRewardViewController* reward_vc = nil;
static LoadingViewController *loading_vc = nil;
static UIScrollView* _scrollView		= nil;


@synthesize location_helper;

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
	/*
	 //////AHMED
	 <hash>
		<snap>
			<business-id type="integer">1</business-id>
			<business-name>StarBucks</business-name>
			<campaign-id type="integer">1</campaign-id>
			<program-id type="integer">1</program-id>
			<engagement-amount type="decimal">1.0</engagement-amount>
			<account-amount type="decimal">20.0</account-amount>
		</snap>
	 </hash>
	 */
	current_place = place;
	_scanDelegate = delegate;
    NSString *_filter = @"[a-z0-9A-Z]+";
    NSPredicate *_predicate = [NSPredicate
                               predicateWithFormat:@"SELF MATCHES %@", _filter];
    
    if ([_predicate evaluateWithObject:qr_code] == YES)
    {
		NSMutableDictionary *_headers = [[NSMutableDictionary alloc] init];
		[_headers setValue:@"application/xml" forKey:@"Accept"];
		KZURLRequest *req = [[KZURLRequest alloc] initRequestWithString:
							 [NSString stringWithFormat:@"%@/users/users_snaps/qr_code/%@.xml?auth_token=%@&long=%@&lat=%@&place_id=%@", 
							  API_URL, qr_code, [KZApplication getAuthenticationToken], 
							  [LocationHelper getLongitude], [LocationHelper getLatitude], current_place.identifier] 
							delegate:shared headers:nil];
		[_headers release];
		
        
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

+ (void) setPlaceScrollView:(UIScrollView *)scroll_view {
	[_scrollView release];
	_scrollView = scroll_view;
	[_scrollView retain];
}

+ (UIScrollView *) getPlaceScrollView {
	return [[_scrollView retain] autorelease];
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
        
        placesArchive = [[KZPlacesLibrary alloc] init];//]WithRootPath:_localPlaces apiURL:[NSURL URLWithString:API_URL]];
    }
    
    return self;
}

- (KZPlacesLibrary*) placesArchive { return placesArchive; }

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
		NSString *campaign_id = [_node stringFromChildNamed:@"campaign-id"];
		NSUInteger engagement_points = [[_node stringFromChildNamed:@"engagements-points"] intValue];
		NSString *account_points = [_node stringFromChildNamed:@"amount"];
		
		NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
		[f setNumberStyle:NSNumberFormatterDecimalStyle];
		NSNumber * _balance = [f numberFromString:account_points];
		[f release];

		
		if (campaign_id != nil) [KZAccount updateAccountBalance:_balance withCampaignId:campaign_id];
		
		[[KZApplication getRewardVC] didUpdatePoints];
		
		//if (nil != _scanDelegate) [_scanDelegate scanHandlerCallback];
		
		UINavigationController *nav = [KZApplication getAppDelegate].navigationController;
		EngagementSuccessViewController *eng_vc = [[EngagementSuccessViewController alloc] initWithNibName:@"EngagementSuccessView" bundle:nil];
		
		//[nav setNavigationBarHidden:YES animated:NO];
		//[nav setToolbarHidden:YES animated:NO];
		[nav pushViewController:eng_vc animated:YES];
		
		
		KZReward *reward = nil;
		KZReward *tmp_reward;
		NSArray *all_rewards = [[KZApplication getRewards] allValues];
		for (int i = [all_rewards count]-1; i >= 0; i--) {
			tmp_reward = [all_rewards objectAtIndex:i];
			if ([tmp_reward.campaign_id isEqual:campaign_id]) {
				if ([account_points intValue] >= tmp_reward.points ) {
					if (reward == nil) {
						reward = tmp_reward;
					} else {
						if (tmp_reward.points > reward.points) {
							reward = tmp_reward;
						}
					}
				}
			}
		}
		eng_vc.lblBusinessName.text = business_name;
		eng_vc.lblBranchAddress.text = (current_place != nil) ? current_place.address : @"";
		
		NSMutableString *form_string = [[NSMutableString alloc] initWithString:@""];
		NSMutableString *fb_string = [[NSMutableString alloc] initWithString:@""];
		if (reward != nil) {
			[form_string appendFormat:@"Whoohoo! You just unlocked %@. When you are ready to redeem it, select it, and tap Enjoy.\n\n", reward.name];
			[fb_string appendFormat:@"Whoohoo! I have just unlocked %@ from %@.\n\n", reward.name, business_name];
			eng_vc.lblTitle.text = @"Reward unlocked!";
		} else {
			eng_vc.lblTitle.text = @"we got you!";
		}
		[form_string appendFormat:@"You just earned %ld point%@. Nice!\nYour balance now is %@ points.", 
			engagement_points, [KZUtils plural:engagement_points], account_points];
		[fb_string appendFormat:@"I have just earned %ld point%@. from %@.", 
			engagement_points, [KZUtils plural:engagement_points], business_name];
		eng_vc.txtDetails.text = form_string;
		eng_vc.share_string = fb_string;
		[form_string release];
		[fb_string release];
		
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


@end
