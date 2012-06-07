//
//  KZEngagementHandler.m
//  Cashbery
//
//  Created by Basayel Said on 7/28/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#define CASHBURY_SCAN_QRCODE_IDENTIFICATION @"C$::"

#import "KZEngagementHandler.h"
#import "KZUserInfo.h"
#import "KZApplication.h"
#import "KZAccount.h"
#import "EngagementSuccessViewController.h"
#import "KZUtils.h"
#import "KZReward.h"
#import "KZSnapController.h"
#import "CXMLElement+Helpers.h"
#import "TouchXML.h"
#import "PayementEntryViewController.h"

@interface KZEngagementHandler (Private)
- (void) dismissZXing;
@end

@implementation KZEngagementHandler

@synthesize place, delegate;

static KZEngagementHandler* singleton = nil;

+ (KZEngagementHandler *) shared
{
    if (singleton == nil)
    {
		singleton = [[KZEngagementHandler alloc] init];
	}
    
    return singleton;
}
+ (ZXingWidgetController*) snap
{
	return [KZSnapController snapWithDelegate:[KZEngagementHandler shared] andShowCancel:YES];
}

+ (ZXingWidgetController*) snapInPlace:(KZPlace*)_place
{
	[KZEngagementHandler shared].place = _place;
	return [KZSnapController snapWithDelegate:[KZEngagementHandler shared] andShowCancel:YES];
}

+ (void) cancel {
	[KZSnapController cancel];
}

- (void) diminishViewController:(UIViewController *)theViewController duration:(NSTimeInterval)theDuration
{
    UIView *_v = theViewController.view;
    
    theViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    _v.transform = CGAffineTransformMakeScale(1, 1);
    _v.alpha = 1;
    
    BOOL _isAnimated = (theDuration > 0);
    
    if (!IS_IOS_5_OR_NEWER)
    {
        [theViewController viewWillDisappear:_isAnimated];
    }
    
   	[UIView animateWithDuration:theDuration
                     animations:^{
                         CGAffineTransform transformBig = CGAffineTransformMakeScale(0.1, 0.1);
                         transformBig = CGAffineTransformTranslate(transformBig, 0, 0);	
                         _v.transform = transformBig;
                         
                         _v.alpha = 0;
                         [theViewController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
                         
                     }
                     completion:^(BOOL finished){
                         if (!IS_IOS_5_OR_NEWER)
                         {
                             [theViewController viewDidDisappear:_isAnimated];
                         }
                         if (IS_IOS_5_OR_NEWER)
                             
                            {
                                
                                [theViewController dismissViewControllerAnimated:NO completion:nil];
                            }
                            else
                            {
                                [theViewController dismissModalViewControllerAnimated:NO];
                            }
                     }];
}



- (void) dismissZXing
{
    if ([delegate respondsToSelector:@selector(willDismissZXing)])
    {
        [self.delegate willDismissZXing];
    }
    
    UIViewController *_visibleController = [KZApplication getAppDelegate].navigationController.visibleViewController;
    
    if ([_visibleController isKindOfClass:[ZXingWidgetController class]])
    {
        /*
        if (IS_IOS_5_OR_NEWER)
        {
            
            [[KZApplication getAppDelegate].navigationController.visibleViewController dismissViewControllerAnimated:YES completion:nil];
        }
        else
        {
            [[KZApplication getAppDelegate].navigationController.visibleViewController dismissModalViewControllerAnimated:YES];
        }*/
        CBMagnifiableViewController *magController  =   (CBMagnifiableViewController*)[KZApplication getAppDelegate].navigationController.visibleViewController;
        [self diminishViewController:magController duration:0.35];
    }
    
}

- (void) didSnapCode:(NSString*)_code {
   
	[self handleScannedQRCard:_code];
}

- (void) didCancelledSnapping {
	///////FIXME remove this line
	//[self handleScannedQRCard:@"3a6d77c45f0ed0c9301b"];		// staging
	//[self handleScannedQRCard:@"b8fb786ea24051fe2309"];		// production
    [self dismissZXing];
}

-(void)dismissZXingWithDelay:(NSString*)qrCode{
    [KZApplication hideLoading];
    if ([delegate respondsToSelector:@selector(willDismissZXing)])
    {
        [self.delegate willDismissZXing];
    }
    UIViewController *_visibleController = [KZApplication getAppDelegate].navigationController.visibleViewController;
    
    if ([_visibleController isKindOfClass:[ZXingWidgetController class]])
    {
        if (IS_IOS_5_OR_NEWER)
        {
            [[KZApplication getAppDelegate].navigationController.visibleViewController dismissViewControllerAnimated:YES completion:nil];
        }
        else
        {
            [[KZApplication getAppDelegate].navigationController.visibleViewController dismissModalViewControllerAnimated:YES];
        }
    }
    if ([qrCode hasPrefix:CASHBURY_SCAN_QRCODE_IDENTIFICATION]) {
         [[NSNotificationCenter defaultCenter] postNotificationName:@"DidScanCashburyUniqueCard" object:nil];
    }else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NonCashburyCodeDecoded" object:qrCode];
    }
   
  
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
    /*
    if ([qr_code hasPrefix:CASHBURY_SCAN_QRCODE_IDENTIFICATION])
    {
        NSArray *codeArray          =  [qr_code componentsSeparatedByString:CASHBURY_SCAN_QRCODE_IDENTIFICATION];
        
        NSString *_codeString        =   @"";
        
        if ([codeArray count] > 0)
        {
            _codeString     =   [(NSString*)[codeArray lastObject] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        }
        
        NSMutableDictionary *_headers = [[NSMutableDictionary alloc] init];
        [_headers setValue:@"application/xml" forKey:@"Accept"];
        req = [[[KZURLRequest alloc] initRequestWithString:[NSString stringWithFormat:@"%@/users/users_snaps/qr_code/%@.xml?auth_token=%@&long=%@&lat=%@&place_id=%@", 
                                                            API_URL, qr_code, [KZUserInfo shared].auth_token, 
                                                            [LocationHelper getLongitude], [LocationHelper getLatitude], 
                                                            (self.place.identifier != nil && [self.place.identifier isEqual:@""] != YES ? self.place.identifier : @"")]
                                                 andParams:nil delegate:self headers:nil andLoadingMessage:@"Loading..."] autorelease];
        [_headers release];
    }
    */
    // to be deleted
    
    [KZApplication showLoadingScreen:@"Loading.."];
    [self performSelector:@selector(dismissZXingWithDelay:) withObject:qr_code afterDelay:3.0];
    
    
//    if ([qr_code hasPrefix:CASHBURY_SCAN_QRCODE_IDENTIFICATION]) {//[qr_code isEqualToString:@"C$::ad9a522af1870140f181"]
//        //do other stuffs
//        
//        [KZApplication showLoadingScreen:@"Loading.."];
//        [self performSelector:@selector(dismissZXingWithDelay) withObject:nil afterDelay:3.0];
//
//    }else {
//        [self dismissZXing];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"NonCashburyCodeDecoded" object:qr_code];
//        /*
//        UIAlertView *_alert = [[UIAlertView alloc] initWithTitle:@"Invalid Stamp"
//                                                         message:@"The stamp you're trying to snap does not appear to be a valid Cashbury stamp."
//                                                        delegate:nil
//                                               cancelButtonTitle:@"OK"
//                                               otherButtonTitles:nil];
//        [_alert show];
//        [_alert release];*/
//    }
    
    /* if ([qr_code hasPrefix:CASHBURY_SCAN_QRCODE_IDENTIFICATION])
     {
     NSArray *codeArray          =  [qr_code componentsSeparatedByString:CASHBURY_SCAN_QRCODE_IDENTIFICATION];
     
     NSString *_codeString        =   @"";
     
     if ([codeArray count] > 0)
     {
     _codeString     =   [(NSString*)[codeArray lastObject] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
     }
     
     NSMutableDictionary *_headers = [[NSMutableDictionary alloc] init];
     [_headers setValue:@"application/xml" forKey:@"Accept"];
     req = [[[KZURLRequest alloc] initRequestWithString:[NSString stringWithFormat:@"%@/users/users_snaps/qr_code/%@.xml?auth_token=%@&long=%@&lat=%@&place_id=%@", 
     API_URL, qr_code, [KZUserInfo shared].auth_token, 
     [LocationHelper getLongitude], [LocationHelper getLatitude], 
     (self.place.identifier != nil && [self.place.identifier isEqual:@""] != YES ? self.place.identifier : @"")]
     andParams:nil delegate:self headers:nil andLoadingMessage:@"Loading..."] autorelease];
     [_headers release];
     
     [self dismissZXing:YES];
     }
     else if([[qr_code lowercaseString] hasPrefix:@"http://"])
     {
     [self dismissZXing:NO];
     
     CBQRScanViewController *_vc = [[CBQRScanViewController alloc] initWithNibName:@"CBQRScanView" bundle:nil];
     
     UINavigationController *nav = [KZApplication getAppDelegate].navigationController;
     [nav presentModalViewController:_vc animated:YES];
     
     _vc.typeLabel.text = @"URL";
     _vc.descriptionLabel.text = qr_code;
     
     [_vc.actionButton setTitle:@"Open in Browser" forState:UIControlStateNormal];
     }
     else if([[qr_code lowercaseString] hasPrefix:@"tel:"])
     {
     [self dismissZXing:NO];
     
     NSArray *codeArray          =  [[qr_code lowercaseString] componentsSeparatedByString:@"tel:"];
     
     NSString *_codeString        =   @"";
     
     if ([codeArray count] > 0)
     {
     _codeString     =   [(NSString*)[codeArray lastObject] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
     }
     
     CBQRScanViewController *_vc = [[CBQRScanViewController alloc] initWithNibName:@"CBQRScanView" bundle:nil];
     
     UINavigationController *nav = [KZApplication getAppDelegate].navigationController;
     [nav presentModalViewController:_vc animated:YES];
     
     _vc.typeLabel.text = @"Phone Number";
     _vc.descriptionLabel.text = _codeString;
     
     [_vc.actionButton setTitle:@"Call Number" forState:UIControlStateNormal];
     }
     else
     {
     [self dismissZXing:NO];
     
     CBQRScanViewController *_vc = [[CBQRScanViewController alloc] initWithNibName:@"CBQRScanView" bundle:nil];
     
     UINavigationController *nav = [KZApplication getAppDelegate].navigationController;
     [nav presentModalViewController:_vc animated:YES];
     
     _vc.typeLabel.text = @"Text";
     _vc.descriptionLabel.text = qr_code;
     
     _vc.actionButton.hidden = YES;
     }
*/
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
	NSArray *_nodes = [_document nodesForXPath:@"//snap" error:nil];
	
	for (CXMLElement *_node in _nodes) {
		KZBusiness *biz = [KZBusiness getBusinessWithIdentifier:[_node stringFromChildNamed:@"business-id"] 
														andName:[_node stringFromChildNamed:@"brand-name"] 
													andImageURL:[NSURL URLWithString:[_node stringFromChildNamed:@"brand-image"]]];
		
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
		//[nav pushViewController:eng_vc animated:YES];
		[nav presentModalViewController:eng_vc animated:YES];
		
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


@end
