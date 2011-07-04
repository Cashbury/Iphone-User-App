//
//  KZSnapController.m
//  Cashbery
//
//  Created by Basayel Said on 6/26/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import "KZSnapController.h"
#import "CXMLElement+Helpers.h"
#import "TouchXML.h"
#import "QRCodeReader.h"

@implementation KZSnapController


static KZSnapController* singleton = nil;

+ (void) snapInPlace:(KZPlace*)_place {
	if (singleton == nil) {
		singleton = [[KZSnapController alloc] init];
	}
	singleton.place = _place;
	[singleton snapQRCode];
}

@synthesize place, zxing_vc; 

- (void) snapQRCode {
	self.zxing_vc = [[ZXingWidgetController alloc] initWithDelegate:self showCancel:NO OneDMode:NO];
	QRCodeReader* qrcodeReader = [[QRCodeReader alloc] init];
	NSSet *readers = [[NSSet alloc ] initWithObjects:qrcodeReader,nil];
	[qrcodeReader release];
	self.zxing_vc.readers = readers;
	
	[readers release];
	self.zxing_vc.soundToPlay = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"beep-beep" ofType:@"aiff"] isDirectory:NO];
	[[KZApplication getAppDelegate].navigationController pushViewController:self.zxing_vc animated:NO];//presentModalViewController:self.zxing_vc animated:YES];
	[self.zxing_vc release];
}

- (void)zxingController:(ZXingWidgetController*)controller didScanResult:(NSString *)result {
    [self handleScannedQRCard:result];
    [[KZApplication getAppDelegate].navigationController popViewControllerAnimated:NO];
}


- (void)zxingControllerDidCancel:(ZXingWidgetController*)controller {
	///////FIXME remove this line
	//[self handleScannedQRCard:@"3a6d77c45f0ed0c9301b"];		// staging
	//[self handleScannedQRCard:@"b8fb786ea24051fe2309"];		// production
	
	[[KZApplication getAppDelegate].navigationController popViewControllerAnimated:NO];
}


- (void) handleScannedQRCard:(NSString*) qr_code {
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
    NSString *_filter = @"[a-z0-9A-Z]+";
    NSPredicate *_predicate = [NSPredicate
                               predicateWithFormat:@"SELF MATCHES %@", _filter];
    
    if ([_predicate evaluateWithObject:qr_code] == YES)
    {
		NSMutableDictionary *_headers = [[NSMutableDictionary alloc] init];
		[_headers setValue:@"application/xml" forKey:@"Accept"];
		req = [[[KZURLRequest alloc] initRequestWithString:[NSString stringWithFormat:@"%@/users/users_snaps/qr_code/%@.xml?auth_token=%@&long=%@&lat=%@&place_id=%@", 
																		  API_URL, qr_code, [KZApplication getAuthenticationToken], 
																		  [LocationHelper getLongitude], [LocationHelper getLatitude], self.place.identifier]
															   andParams:nil delegate:self headers:nil andLoadingMessage:@"Loading..."] autorelease];
		[_headers release];
        
    } else {
        UIAlertView *_alert = [[UIAlertView alloc] initWithTitle:@"Invalid Stamp"
                                                         message:@"The stamp you're trying to snap does not appear to be a valid Cashbury stamp."
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
        
        [_alert show];
        [_alert release];
    }	
}


- (void) KZURLRequest:(KZURLRequest *)theRequest didFailWithError:(NSError*)theError {
	UIAlertView *_alert = [[UIAlertView alloc] initWithTitle:@"Invalid Stamp"
													 message:@"The stamp you're trying to snap does not appear to be a valid Cashbury stamp."
													delegate:nil
										   cancelButtonTitle:@"OK"
										   otherButtonTitles:nil];
	
	[_alert show];
	[_alert release];
}

/// Snap Card HTTP Callback
- (void) KZURLRequest:(KZURLRequest *)theRequest didSucceedWithData:(NSData*)theData {
	
	CXMLDocument *_document = [[[CXMLDocument alloc] initWithData:theData options:0 error:nil] autorelease];
	NSLog([_document description]);
	NSArray *_nodes = [_document nodesForXPath:@"//snap" error:nil];
	
	for (CXMLElement *_node in _nodes) {
		KZBusiness *biz = [KZBusiness getBusinessWithIdentifier:[_node stringFromChildNamed:@"business-id"] 
														andName:[_node stringFromChildNamed:@"brand-name"] 
													andImageURL:[_node stringFromChildNamed:@"brand-image"]];
		
		NSString *campaign_id = [_node stringFromChildNamed:@"campaign-id"];
		NSUInteger engagement_points = [[_node stringFromChildNamed:@"engagement-amount"] intValue];
		NSString *account_points = [_node stringFromChildNamed:@"account-amount"];
		NSString *item_name = [_node stringFromChildNamed:@"item-name"];
		NSString *item_image = [_node stringFromChildNamed:@"item-image"];
		NSString *fb_engagement_msg = [_node stringFromChildNamed:@"fb-engagement-msg"];
		
		NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
		[f setNumberStyle:NSNumberFormatterDecimalStyle];
		NSNumber * _balance = [f numberFromString:account_points];
		[f release];
		
		
		if (campaign_id != nil) [KZAccount updateAccountBalance:_balance withCampaignId:campaign_id];
		
		if ([KZApplication shared].place_vc != nil) [[KZApplication shared].place_vc didUpdatePoints];
		
		//if (nil != _scanDelegate) [_scanDelegate scanHandlerCallback];
		
		UINavigationController *nav = [KZApplication getAppDelegate].navigationController;
		EngagementSuccessViewController *eng_vc = [[EngagementSuccessViewController alloc] 
												   initWithBusiness:biz andAddress:((self.place != nil) ? self.place.address : @"")];
		
		//[nav setNavigationBarHidden:YES animated:NO];
		//[nav setToolbarHidden:YES animated:NO];
		[nav pushViewController:eng_vc animated:YES];
		
		
		KZReward *reward = nil;
		KZReward *tmp_reward;
		NSArray *all_rewards = [[KZApplication getRewards] allValues];
		for (int i = [all_rewards count]-1; i >= 0; i--) {
			tmp_reward = [all_rewards objectAtIndex:i];
			if ([tmp_reward.campaign_id isEqual:campaign_id]) {
				if ([account_points intValue] >= tmp_reward.needed_amount ) {
					if (reward == nil) {
						reward = tmp_reward;
					} else {
						if (tmp_reward.needed_amount > reward.needed_amount) {
							reward = tmp_reward;
						}
					}
				}
			}
		}
		
		if (reward != nil) {
			[eng_vc addLineDetail:[NSString stringWithFormat:@"Whoohoo! You just unlocked %@. When you are ready to redeem it, select it, and tap Enjoy.\n\n", 
								   reward.name]];
			
			//[NSString stringWithFormat:@"%@ %@ enjoyed a %@ @ %@ by going out with Cashbury.", [KZApplication getFirstName], [KZApplication getLastName], reward.name, business_name]
			[eng_vc setFacebookMessage:reward.fb_unlock_msg andIcon:reward.reward_image];
			[eng_vc setMainTitle:@"Reward unlocked!"];
		} else {
			[eng_vc setMainTitle:@"we got you!"];
			if (item_name == nil || [item_name isEqual:@""]) {
				//[NSString stringWithFormat:@"%@ %@ has just earned %ld point%@ @ %@ by going out with Cashbury.", [KZApplication getFirstName], [KZApplication getLastName], engagement_points, [KZUtils plural:engagement_points], business_name]
				[eng_vc setFacebookMessage:fb_engagement_msg andIcon:nil];
			} else {
				//[NSString stringWithFormat:@"%@ %@ has just enjoyed %@ and earned %ld point%@ @ %@ by going out with Cashbury.", [KZApplication getFirstName], [KZApplication getLastName], item_name, engagement_points, [KZUtils plural:engagement_points], business_name]
				[eng_vc setFacebookMessage:fb_engagement_msg
								   andIcon:(item_image == nil || [item_image isEqual:@""] ? nil : item_image)];
			}
		}
		[eng_vc addLineDetail:[NSString stringWithFormat:@"You just earned %ld point%@. Nice!\nYour balance now is %@ points.", 
							   engagement_points, [KZUtils plural:engagement_points], _balance]];
		
		[eng_vc release];
	}
}

- (void) cancel {
	[self.zxing_vc cancelled];
}


@end
