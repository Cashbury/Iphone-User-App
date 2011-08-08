    //
//  KZUnlockedRewardViewController.m
//  Cashbery
//
//  Created by Basayel Said on 6/22/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import "KZUnlockedRewardViewController.h"
#import "QuartzCore/QuartzCore.h"
#import "KZUserInfo.h"

@implementation KZUnlockedRewardViewController

@synthesize lbl_reward_name, 
			lbl_brand_name, 
			img_reward_image, 
			lbl_cost_score, 
			redeem_request, 
			reward, 
			place,
			btn_gray_card,
			img_enjoy_crown,
			img_enjoy_text,
			place_vc,
			lbl_heading1,
			lbl_heading2;


- (id) initWithReward:(KZReward*)theReward {
    self = [super initWithNibName:@"KZUnlockedRewardView" bundle:nil];
    if (self != nil) {
		self.reward = theReward;
        self.place = theReward.place;
    }
    return self;    
}



- (void) dealloc {
	self.lbl_reward_name = nil;
	self.lbl_brand_name = nil;
	self.img_reward_image = nil;
	self.lbl_cost_score = nil;
	self.redeem_request = nil;
	self.reward = nil;
	self.place = nil;
	[req release];
	
	[super dealloc];
}

//------------------------------------
// UIViewController methods
//------------------------------------

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.lbl_reward_name.text = self.reward.name;
	self.lbl_brand_name.text = [NSString stringWithFormat:@"@%@", self.place.business.name];
	if (![self.reward isUnlocked]) {	// not ready
		self.lbl_cost_score.text = [NSString stringWithFormat:@"+%d points needed to enjoy. Score: %d", [self.reward getNeededRemainingPoints], [self.reward getEarnedPoints]];
		[self.img_enjoy_text setImage:[UIImage imageNamed:@"tap2enjoy_gray.png"]];
		[self.img_enjoy_crown setImage:[UIImage imageNamed:@"crown_gray.png"]];
		[self.btn_gray_card setSelected:YES];
		
		self.lbl_heading1.text = @"Your reward is still locked.";
		self.lbl_heading2.text = @"Score some more to unlock it.";
		
	} else {	// ready
		self.lbl_cost_score.text = [NSString stringWithFormat:@"Ready to enjoy. Score: %d", [self.reward getEarnedPoints]];
		[self.img_enjoy_text setImage:[UIImage imageNamed:@"tap2enjoy_green.png"]];
		[self.img_enjoy_crown setImage:[UIImage imageNamed:@"crown_green.png"]];
		self.lbl_heading1.text = @"Your reward is ready to be enjoyed.";
		self.lbl_heading2.text = @"";//@"Come on in to enjoy anytime.";
		
		
	}
	if (self.reward.reward_image != nil && [self.reward.reward_image isEqual:@""] != YES) { 
		// set the logo image
		[self performSelectorInBackground:@selector(loadRewardImage) withObject:nil];
	}
	if (self.reward.needed_amount == 0) {
		[self.btn_gray_card setHidden:YES];
	} else {
		[self.btn_gray_card setHidden:NO];
	}
}




- (void) loadRewardImage {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	if (self.img_reward_image != nil) {
		UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.reward.reward_image]]];
		CGRect image_frame = self.img_reward_image.frame;
		image_frame.size = img.size;
		self.img_reward_image.frame = image_frame;
		[self.img_reward_image setImage:img];
		self.img_reward_image.layer.masksToBounds = YES;
		self.img_reward_image.layer.cornerRadius = 5.0;
		 
	}
	[pool release];
}

- (IBAction) returnToStampsScreen {
	NSLog(@"Removing current View..............");
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view.superview cache:NO];
    [UIView setAnimationDuration:0.5];
    [self.view removeFromSuperview];
    [UIView commitAnimations];
	
}

- (IBAction) enjoyReward {
	if ([self userHasEnoughPoints]) {
		UIAlertView *_alert = [[UIAlertView alloc] initWithTitle:@"Ready to Enjoy?"
														 message:@"To enjoy your reward you must flash the grant my reward screen to a staff at the store."
														delegate:self
											   cancelButtonTitle:@"Cancel"
											   otherButtonTitles:@"Enjoy Now",nil];
		[_alert show];
		[_alert release];
	}	
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 1)
	{
		[self redeem_reward];
	}
}


- (void) redeem_reward {
	NSMutableDictionary *_headers = [[NSMutableDictionary alloc] init];
	[_headers setValue:@"application/xml" forKey:@"Accept"];
	req = [[KZURLRequest alloc] initRequestWithString:
			[NSString stringWithFormat:@"%@/users/rewards/%@/claim.xml?auth_token=%@", 
			 API_URL, self.reward.reward_id, [KZUserInfo shared].auth_token] 
											 andParams:nil delegate:self headers:_headers andLoadingMessage:@"Loading..."];
	[_headers release];
}

- (BOOL) userHasEnoughPoints
{
	return [self.reward isUnlocked];
}

- (void) KZURLRequest:(KZURLRequest *)theRequest didFailWithError:(NSError*)theError {
	UIAlertView *_alert = [[UIAlertView alloc] initWithTitle:@"Sorry"
													 message:@"An error has occured while you were claiming your reward. Please Try again later."
													delegate:nil
										   cancelButtonTitle:@"OK"
										   otherButtonTitles:nil];
	[_alert show];
	[_alert release];
}

- (void) grantReward:(NSString*)_reward_id byBusinessId:(NSString*)business_id {
	KZReward* _reward = [[KZApplication getRewards] objectForKey:_reward_id];
	KZBusiness *biz = [KZBusiness getBusinessWithIdentifier:business_id andName:nil andImageURL:nil];
	GrantViewController *vc = [[GrantViewController alloc] initWithBusiness:biz 
																   andPlace:self.place
																  andReward:_reward];
	//UINavigationController *nav = [KZApplication getAppDelegate].navigationController;
	[self.place_vc presentModalViewController:vc animated:YES];
	//////////////CONTINUEME
	[vc release];
}

/// redeem reward HTTP Callback
- (void) KZURLRequest:(KZURLRequest *)theRequest didSucceedWithData:(NSData*)theData {
	
	CXMLDocument *_document = [[[CXMLDocument alloc] initWithData:theData options:0 error:nil] autorelease];
	NSArray *_nodes = [_document nodesForXPath:@"//redeem" error:nil];
	
	for (CXMLElement *_node in _nodes) {
		NSString *business_id = [_node stringFromChildNamed:@"business-id"];
		NSString *campaign_id = [_node stringFromChildNamed:@"campaign-id"];
		NSString *reward_id = [_node stringFromChildNamed:@"reward-id"];
		NSString *account_points = [_node stringFromChildNamed:@"account-amount"];
		
		// not used yet
		if ([[_node stringFromChildNamed:@"hide-reward"] isEqual:@"true"]) {
			[[KZApplication getRewards] removeObjectForKey:reward_id];
		}
		
		NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
		[f setNumberStyle:NSNumberFormatterDecimalStyle];
		NSNumber * _balance = [f numberFromString:account_points];
		[f release];
		
		[KZAccount updateAccountBalance:_balance withCampaignId:campaign_id];
		
		//[self didUpdatePoints];
		[self grantReward:reward_id byBusinessId:business_id];
	}
}


@end
