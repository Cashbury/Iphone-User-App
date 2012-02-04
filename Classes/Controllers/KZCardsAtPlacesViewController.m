    //
//  KZCardsAtPlacesViewController.m
//  Cashbery
//
//  Created by Basayel Said on 6/26/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import "KZCardsAtPlacesViewController.h"
#import "KZUserIDCardViewController.h"
#import "CBWalletSettingsViewController.h"
#import "UINavigationController+CustomTransitions.h"
#import "KZApplication.h"
#import "CBCitySelectorViewController.h"
#import "KZEngagementHandler.h"
#import "KZUserInfo.h"
#import "FileSaver.h"
#import "CBSavings.h"

@interface KZCardsAtPlacesViewController (PrivateMethods)
- (void) setBalanceLabelValue:(NSNumber *)theBalance;
@end

@implementation KZCardsAtPlacesViewController

@synthesize cardContainer, frontCard, backCard, frontCardBackground, customerName, userID, profileImage, savingsBalance;

//------------------------------------
// Init & dealloc
//------------------------------------
#pragma mark - Init & dealloc

- (void) dealloc
{
    [cardContainer release];
    [frontCard release];
    [backCard release];
    
    [frontCardBackground release];
    [customerName release];
    [userID release];
    [profileImage release];
    
    [savingsBalance release];
    
    [super dealloc];
}

//------------------------------------
// View lifecycle
//------------------------------------
#pragma mark - View lifecycle

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    [self.backCard removeFromSuperview];
    
    // Wire up the gesture recognizer
    UITapGestureRecognizer *_controlTap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(flipCard:)] autorelease];
    UITapGestureRecognizer *_controlTap2 = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(flipCard:)] autorelease];
    UITapGestureRecognizer *_controlTap3 = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(flipCard:)] autorelease];
    
    [self.profileImage addGestureRecognizer:_controlTap];
    [self.customerName addGestureRecognizer:_controlTap2];
    [self.userID addGestureRecognizer:_controlTap3];
    
    UITapGestureRecognizer *_backgroundTap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showQRCode:)] autorelease];
    
    [self.frontCardBackground addGestureRecognizer:_backgroundTap];
    
    // Fill in the front card
    
    self.customerName.text  = [[KZUserInfo shared] getShortName];
//    self.userID.text    = [KZUserInfo shared].facebookID;
    
    self.profileImage.contentMode = UIViewContentModeScaleAspectFill;
    self.profileImage.layer.masksToBounds = YES;
    self.profileImage.layer.cornerRadius = 5.0;
    self.profileImage.layer.borderWidth = 4.0;
    self.profileImage.layer.borderColor = [UIColor whiteColor].CGColor;
    
    NSString *_imagePath = [FileSaver getFilePathForFilename:@"facebook_user_image"];
    
	if ([KZUtils isStringValid:_imagePath])
    {
		UIImage *_profileImage = [UIImage imageWithContentsOfFile:_imagePath];
        
		self.profileImage.image = _profileImage;
	}
    else
    {
        NSURL *_profileURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=normal", [KZUserInfo shared].facebookID]];
        [self.profileImage loadImageWithAsyncUrl:_profileURL];
    }
    
    // Fill in the control panel
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUpdateTotalBalance:) name:CBTotalSavingsUpdateNotification object:nil];
    
    [self setBalanceLabelValue:[[CBSavings sharedInstance] totalSavings]];
}

- (void) viewDidUnload
{
    self.frontCard = nil;
    self.backCard = nil;
    self.frontCardBackground = nil;
    self.customerName = nil;
    self.userID = nil;
    self.profileImage = nil;
    self.savingsBalance = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super viewDidUnload];
}

- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

//------------------------------------
// Private methods
//------------------------------------
#pragma mark - Private methods

- (void) setBalanceLabelValue:(NSNumber *)theBalance
{
    float _balance = [theBalance floatValue];
    
    self.savingsBalance.text = [NSString stringWithFormat:@"$%1.2f", _balance];
}

//------------------------------------
// Actions
//------------------------------------
#pragma mark - Actions

- (IBAction) didTapPlaces:(id)sender
{
    KZPlacesViewController *_controller = [[KZPlacesViewController alloc] initWithNibName:@"KZPlacesView" bundle:nil];
    UINavigationController *_b = [[UINavigationController alloc] initWithRootViewController:_controller];
    
    _controller.delegate = self;
    
    [self magnifyViewController:_b duration:0.35];
}

- (IBAction) showQRCode:(id)sender
{
    KZUserIDCardViewController* user_id_card = [[KZUserIDCardViewController alloc] initWithBusiness:nil];
    user_id_card.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [[KZApplication getAppDelegate].navigationController presentModalViewController:user_id_card animated:YES];
    [user_id_card release];
}

- (IBAction) didTapSnap:(id)sender
{
    ZXingWidgetController* vc = [KZEngagementHandler snap];
    
    if (IS_IOS_5_OR_NEWER)
    {
        [self presentViewController:vc animated:YES completion:nil];
    }
    else
    {
        [self presentModalViewController:vc animated:YES];
    }
}

- (IBAction) didTapNotifications:(id)sender
{
    
}

- (void) didTapProfile:(id)sender
{
    CBWalletSettingsViewController *_controller = [[CBWalletSettingsViewController alloc] initWithNibName:@"CBWalletSettingsView" bundle:nil];
    _controller.delegate = self;
    
    [self magnifyViewController:_controller duration:0.35];
}

- (void) didUpdatePlaces
{
	[KZApplication hideLoading];
}

- (void) didFailUpdatePlaces
{
	[KZApplication hideLoading];
}


- (IBAction) flipCard:(id)theSender
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
    
    if ([frontCard superview])
    {
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.cardContainer cache:YES];
        
        [frontCard removeFromSuperview];
        [cardContainer addSubview:backCard];
    }
    else
    {
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.cardContainer cache:YES];
        
        [backCard removeFromSuperview];
        [cardContainer addSubview:frontCard];
    }
    
    [UIView commitAnimations];
}

- (void) didUpdateTotalBalance:(NSNotification *) theNotification
{
    NSNumber *_balanceNumber = (NSNumber *) [theNotification object];
    [self setBalanceLabelValue:_balanceNumber];
}

//------------------------------------
// CBMagnifiableViewControllerDelegate methods
//------------------------------------
#pragma mark - CBMagnifiableViewControllerDelegate methods

- (void) dismissViewController:(CBMagnifiableViewController *)theController
{
    UIViewController *_controllerToRemove = theController;
    
    if (theController.navigationController)
    {
        _controllerToRemove = theController.navigationController;
    }
    
    [self diminishViewController:_controllerToRemove duration:0.35];
    
    [_controllerToRemove release];
}

@end
