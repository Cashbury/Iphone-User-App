//
//  KZRewardViewController.m
//  Cashbury
//
//  Created by Basayel Said on 3/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "KZRewardViewController.h"
#import "KZStampView.h"
#import "KZReward.h"
#import "KZPlaceInfoViewController.h"
#import "QRCodeReader.h"
#import "CXMLDocument.h"
#import "FacebookWrapper.h"
#import "UnlockRewardViewController.h"
#import "GrantViewController.h"

@interface KZRewardViewController (PrivateMethods)
- (BOOL) userHasEnoughPoints;
- (void) didTapInfoButton:(id)theSender;
- (void) didUpdatePoints;
@end


@implementation KZRewardViewController

@synthesize businessNameLabel, rewardNameLabel, descriptionLabel, 
			pointsValueLabel, button, starImage, showToClaimLabel, 
			grantRewardLabel, gageBackground, pointsLabel, 
			stampView, reward, place, redeem_request;

//------------------------------------
// Init & dealloc
//------------------------------------


- (id) initWithReward:(KZReward*)theReward
{
    self = [super initWithNibName:@"KZRewardView" bundle:nil];
    
    if (self != nil)
    {
		self.reward = theReward;
        self.place = theReward.place;
        
        pointsArchive = [[KZApplication shared] pointsArchive];
        pointsArchive.delegate = self;
        
        earnedPoints = [KZApplication getPointsForProgram:reward.program_id];
    }
    
    return self;    
}

- (void)dealloc
{
	[reward release];
	[place release];
	[businessNameLabel release];
	[rewardNameLabel release];
	[descriptionLabel release];
	[pointsValueLabel release];
	[button release];
	[starImage release];
	[showToClaimLabel release];
	[grantRewardLabel release];
	[gageBackground release];
	[pointsLabel release];
	[stampView release];
    
    [super dealloc];
}

//------------------------------------
// UIViewController methods
//------------------------------------

- (void)viewDidLoad
{
    [super viewDidLoad];
    //////////////////////////////////////////////////////
	/*
	// view controllers are created lazily
    // in the meantime, load the array with placeholders which will be replaced on demand
    NSMutableArray *controllers = [[NSMutableArray alloc] initWithNulls:kNumberOfPages];
    
	self.viewControllers = controllers;
	[controllers release];
	
    // a page is the width of the scroll view
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * kNumberOfPages, scrollView.frame.size.height);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
	
    pageControl.numberOfPages = kNumberOfPages;
    pageControl.currentPage = 0;
	
    // pages are created on demand
    // load the visible page
    // load the page on either side to avoid flashes when the user starts scrolling
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
	 */
	//////////////////////////////////////////////////////
	
	
	self.stampView = [[[KZStampView alloc] initWithFrame:CGRectMake(35, 156, 250, 18)
									numberOfStamps:reward.points
						   numberOfCollectedStamps:0] autorelease];
	
	[self.view addSubview:stampView];
	
	//[self didUpdatePoints];
	
    if (self.place != nil)
    {
        self.title = place.name;
        
        self.businessNameLabel.text = place.name;
        self.descriptionLabel.text = place.description;
        
        if (reward)
        {
            self.stampView = [[[KZStampView alloc] initWithFrame:CGRectMake(35, 156, 250, 18)
                                            numberOfStamps:reward.points
                                   numberOfCollectedStamps:0] autorelease];
            [self.view addSubview:stampView];
			
            //[self didUpdatePoints];
        }
        
        //UIBarButtonItem *_infoButton = [[UIBarButtonItem alloc] initWithTitle:@"Info" style:UIBarButtonItemStylePlain target:self action:@selector(didTapInfoButton:)];          
        //self.navigationItem.rightBarButtonItem = _infoButton;
        //[_infoButton release];
    }
	[self didUpdatePoints];
	[KZApplication setRewardVC:self];
}

- (void)viewDidAppear:(BOOL)animated
{
	NSLog(@"Reward_ID: %@ ............", reward.identifier);
    ready = NO;

	//earnedPoints = [KZApplication getPointsForProgram:self.reward.program_id];
	//[self didUpdatePoints];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.businessNameLabel = nil;
    self.rewardNameLabel = nil;
    self.descriptionLabel = nil;
    self.pointsLabel = nil;
    self.stampView = nil;
    self.button = nil;
    self.starImage = nil;
    self.showToClaimLabel = nil;
    self.grantRewardLabel = nil;
    self.gageBackground = nil;
    self.pointsValueLabel = nil;    
}

//------------------------------------
// ZXingDelegateMethods
//------------------------------------

- (void)zxingController:(ZXingWidgetController*)controller didScanResult:(NSString *)result
{
	//[[KZApplication getPlaceScrollView] setHidden:NO];
    [KZApplication handleScannedQRCard:result withPlace:reward.place withDelegate:nil];
	[self dismissModalViewControllerAnimated:YES];
	[[KZApplication getAppDelegate].navigationController setNavigationBarHidden:NO animated:NO];
	[[KZApplication getAppDelegate].navigationController setToolbarHidden:NO animated:NO];
}

- (void)zxingControllerDidCancel:(ZXingWidgetController*)controller
{
	//[[KZApplication getPlaceScrollView] setHidden:NO];
	[self dismissModalViewControllerAnimated:YES];
	[[KZApplication getAppDelegate].navigationController setNavigationBarHidden:NO animated:NO];
	[[KZApplication getAppDelegate].navigationController setToolbarHidden:NO animated:NO];
    
}


//------------------------------------
// UIAlertViewDelegate methods
//------------------------------------
#pragma mark -
#pragma mark UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        ready = YES;
		[self redeem_reward];
        //[pointsArchive setPoints:(earnedPoints - reward.points) forBusiness:self.place.businessIdentifier];
    }
}


//------------------------------------
// KZPointsLibraryDelegate methods
//------------------------------------
#pragma mark -
#pragma mark KZPointsLibraryDelegate methods
/*
- (void)didUpdatePointsForBusinessIdentifier:(NSString *)theBusinessIdentifier points:(NSUInteger)thePoints
{
    if (theBusinessIdentifier == self.place.businessIdentifier)
    {
        earnedPoints = thePoints;
        
        if (reward)
        {
            [self didUpdatePoints];
            
            if ([self userHasEnoughPoints])
            {
                UIAlertView *_alert = [[UIAlertView alloc] initWithTitle:@"Reward Unlocked"
                                                                 message:@"When ready to enjoy your reward, simply select it and click Enjoy"
                                                                delegate:nil
                                                       cancelButtonTitle:@"Woohoo"
                                                       otherButtonTitles:nil];
                [_alert show];
                [_alert release];
            }
        }
    }
}
*/
//------------------------------------
// Actions
//------------------------------------
#pragma mark -
#pragma mark Actions


- (IBAction) didTapSnapButton:(id)theSender
{
    if ([self userHasEnoughPoints])
    {
        if (!ready)
        {
            UIAlertView *_alert = [[UIAlertView alloc] initWithTitle:@"Are you ready?"
                                                             message:@"You can redeem your award only once. Click when ready."
                                                            delegate:self
                                                   cancelButtonTitle:@"Cancel"
                                                   otherButtonTitles:@"Enjoy Now",nil];
            [_alert show];
            [_alert release];
        }
    }
    else
    {
		//[[KZApplication getPlaceScrollView] setHidden:YES];
		ZXingWidgetController *widController = [[ZXingWidgetController alloc] initWithDelegate:self showCancel:YES OneDMode:NO];
		QRCodeReader* qrcodeReader = [[QRCodeReader alloc] init];
		NSSet *readers = [[NSSet alloc ] initWithObjects:qrcodeReader,nil];
		[qrcodeReader release];
		widController.readers = readers;
		[readers release];
		widController.soundToPlay = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"beep-beep" ofType:@"aiff"] isDirectory:NO];
		[self presentModalViewController:widController animated:YES];
		[widController release];
		[[KZApplication getAppDelegate].navigationController setNavigationBarHidden:YES animated:NO];
		[[KZApplication getAppDelegate].navigationController setToolbarHidden:YES animated:NO];
		
    }
}

//------------------------------------
// Private methods
//------------------------------------
#pragma mark -
#pragma mark Private methods

- (void) redeem_reward {
	NSMutableDictionary *_headers = [[NSMutableDictionary alloc] init];
	[_headers setValue:@"application/xml" forKey:@"Accept"];
	KZURLRequest *req = [[KZURLRequest alloc] initRequestWithString:
						 [NSString stringWithFormat:@"%@/users/rewards/%@/claim.xml?auth_token=%@", API_URL, reward.identifier,  
						  [KZApplication getAuthenticationToken]] delegate:self headers:nil];
	[req release];
	[_headers release];
	
}

- (BOOL) userHasEnoughPoints
{
    NSUInteger _neededPoints = (reward) ? reward.points : 0;
    
    return (earnedPoints >= _neededPoints);
}

- (void) didUpdatePoints
{
	earnedPoints = [KZApplication getPointsForProgram:self.reward.program_id];
	NSLog(@"Earned Points: %d", earnedPoints);
    NSUInteger _neededPoints = reward.points;
    
    self.rewardNameLabel.text = reward.name;
    self.businessNameLabel.text = place.name;
    
    if (ready)
    {
		NSLog(@"READY");
        self.stampView.hidden = YES;
        self.descriptionLabel.hidden = YES;
        self.grantRewardLabel.hidden = NO;
        self.showToClaimLabel.hidden = NO;
        self.button.hidden = YES;
        self.pointsValueLabel.hidden = YES;
        self.pointsLabel.hidden = YES;
        self.gageBackground.hidden = YES;
        self.starImage.hidden = YES;
    }
    else
    {
		NSLog(@"NOT READY");
        self.stampView.hidden = NO;
        self.stampView.numberOfCollectedStamps = earnedPoints;
        self.descriptionLabel.hidden = NO;
        self.gageBackground.hidden = NO;
        
        if (earnedPoints >= _neededPoints)
        {
			NSLog(@"NOT READY earned_points >= needed");
            self.starImage.hidden = NO;
            self.pointsValueLabel.hidden = YES;
            self.pointsLabel.hidden = YES;
            [self.button setImage:[UIImage imageNamed:@"button-enjoy.png"] forState:UIControlStateNormal];
            
            self.descriptionLabel.text = @"This reward is ready to be enjoyed";
        }
        else
        {
			NSLog(@"NOT READY earned_points < needed");
            self.starImage.hidden = YES;
            self.pointsLabel.hidden = NO;
            self.pointsValueLabel.hidden = NO;
            self.pointsValueLabel.text = [NSString stringWithFormat:@"%d", earnedPoints];
            [self.button setImage:[UIImage imageNamed:@"button-snap.png"] forState:UIControlStateNormal];
            
            self.descriptionLabel.text = reward.description;
        }
    }
}


- (void) checkRewards {
	if ([self userHasEnoughPoints]) {
		NSLog(@"has enough points");
		UnlockRewardViewController *vc = [[UnlockRewardViewController alloc] initWithNibName:@"UnlockRewardView" bundle:nil];
		
		UINavigationController *nav = [KZApplication getAppDelegate].navigationController;
		[nav setNavigationBarHidden:YES animated:NO];
		[nav setToolbarHidden:YES animated:NO];
		[nav presentModalViewController:vc animated:YES];
		
		vc.lblBusinessName.text = place.businessName;
		vc.lblBranchAddress.text = place.address;
		vc.txtReward.text = [NSString stringWithFormat:@"Whoohoo! You just unlocked %@. When you are ready to redeem it, select it, and tap Enjoy.", reward.name];
		vc.share_string = [NSString stringWithFormat:@"Whoohoo! I have just unlocked %@ from %@.", reward.name, place.businessName];
		
		// set time and date
		NSDate* date = [NSDate date];
		NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:@"HH:mm:ss a MM.dd.yyyy"];
		NSString* str = [formatter stringFromDate:date];
		vc.lblTime.text = str;
		[formatter release];
		
		[vc release];
		/**
		 UIAlertView *_alert = [[UIAlertView alloc] initWithTitle:@"Reward Unlocked"
		 message:@"When ready to enjoy your reward, simply select it and click Enjoy"
		 delegate:nil
		 cancelButtonTitle:@"Woohoo"
		 otherButtonTitles:nil];
		 [_alert show];
		 [_alert release];
		 */
	}
}

- (void) didTapInfoButton:(id)theSender
{
	
    KZPlaceInfoViewController *_infoController = [[KZPlaceInfoViewController alloc] initWithNibName:@"KZPlaceInfoView" bundle:nil place:self.place];
    [self presentModalViewController:_infoController animated:YES];
    [_infoController release];
	 
}



- (void) KZURLRequest:(KZURLRequest *)theRequest didFailWithError:(NSError*)theError {
	UIAlertView *_alert = [[UIAlertView alloc] initWithTitle:@"Sorry"
													 message:@"An error has occured while you were claiming your reward. Please contact us."
													delegate:nil
										   cancelButtonTitle:@"OK"
										   otherButtonTitles:nil];
	[_alert show];
	[_alert release];
}

- (void) grantReward:(NSString*)_reward_id byBusinessId:(NSString*)business_id {
	
	NSString* business_name = [[KZApplication getBusinesses] objectForKey:business_id];
	KZReward* _reward = [[KZApplication getRewards] objectForKey:_reward_id];
	GrantViewController *vc = [[GrantViewController alloc] initWithNibName:@"GrantView" bundle:nil];
	
	UINavigationController *nav = [KZApplication getAppDelegate].navigationController;
	[nav setNavigationBarHidden:YES animated:NO];
	[nav setToolbarHidden:YES animated:NO];
	[nav pushViewController:vc animated:YES];
	
	vc.lblBusinessName.text = business_name;
	if (place != nil) vc.lblBranchAddress.text = place.address;
	vc.lblName.text = [NSString stringWithFormat:@"By %@", [KZApplication getFullName]];
	vc.lblReward.text = _reward.name;
	// set time and date
	NSDate* date = [NSDate date];
	NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"hh:mm:ss a MM.dd.yyyy"];
	NSString* str = [formatter stringFromDate:date];
	vc.lblTime.text = [NSString stringWithFormat:@"Requested at %@", str];
	[formatter release];
	[vc release];
	NSLog(@"%d ... %d\n", _reward.claim, _reward.redeemCount);
	
	/*
	UIAlertView *_alert = [[UIAlertView alloc] initWithTitle:@"Grant"
													 message:@"You got it right."
													delegate:nil
										   cancelButtonTitle:@"OK"
										   otherButtonTitles:nil];
	[_alert show];
	[_alert release];
	 */
}

/// Snap Card HTTP Callback
- (void) KZURLRequest:(KZURLRequest *)theRequest didSucceedWithData:(NSData*)theData {
	
	CXMLDocument *_document = [[[CXMLDocument alloc] initWithData:theData options:0 error:nil] autorelease];
	NSArray *_nodes = [_document nodesForXPath:@"//redeem" error:nil];
	
	for (CXMLElement *_node in _nodes) {
		NSString *business_id = [_node stringFromChildNamed:@"business-id"];
		NSString *program_id = [_node stringFromChildNamed:@"program-id"];
		NSString *reward_id = [_node stringFromChildNamed:@"reward-id"];
		NSString *account_points = [_node stringFromChildNamed:@"account-points"];
		
		NSMutableDictionary *accounts = [KZApplication getAccounts];
		[accounts setValue:account_points forKey:program_id];
		[self didUpdatePoints];
		[self grantReward:reward_id byBusinessId:business_id];
		
	}
}



@end
