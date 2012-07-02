//
//  KazdoorAppDelegate.m
//  Kazdoor
//
//  Created by Rami on 7/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import "KazdoorAppDelegate.h"
#import "KZApplication.h"
#import "KZPlacesViewController.h"
#import "KZUserInfo.h"

NSString * const CashburyApplicationDidBecomeActive = @"CashburyApplicationDidBecomeActive";


@interface KazdoorAppDelegate (Private)
- (void) showLoginView;
@end


@implementation KazdoorAppDelegate

@synthesize window, navigationController, loginViewController, leather_curtain, ringup_vc;
@synthesize scanHistoryArray,placesArray;

#pragma mark -

#pragma mark Loading view
-(void)setUpLoadingView{
    
    LoadingViewController *load     =   [[LoadingViewController alloc] initWithNibName:@"LoadingView" bundle:nil];
    load.view.frame                 =   CGRectMake(0.0, 0.0, 320.0, 460.0);
    load.view.tag                   =   101;
    load.view.hidden                =   TRUE;
    [window addSubview:load.view];
    [load release];

}

-(void)showLoadingView{
    UIView *fullView    =   (UIView*)[window viewWithTag:101];
    fullView.hidden     =   FALSE;

    
}

-(void)removeLoadingView{
    UIView *fullView    =   (UIView*)[window viewWithTag:101];
    fullView.hidden     =   TRUE;
}

#pragma mark Application lifecycle
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [application setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];

    scanHistoryArray    =   [[NSMutableArray alloc] init];
    placesArray         =   [[NSMutableArray alloc] init];
	[KZApplication setAppDelegate:self];
	[[KZApplication shared] setLocation_helper:[[[LocationHelper alloc] init] autorelease]];
	
	self.loginViewController = [[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil] autorelease];

    [self.window addSubview:self.navigationController.view];
    [self.window makeKeyAndVisible];
    
//    KZUserInfo *_userInfo = [KZUserInfo shared];
//    
//	if ([_userInfo isCredentialsPersistsed])
//    {
//        [self showLoginView];
//	}
//    else
//    {
//        // NOT Logged in then show login screen
//		[self.navigationController pushViewController:loginViewController animated:NO];
//	}
    [self.navigationController pushViewController:loginViewController animated:NO];
    [self setUpLoadingView];
    UIImageView *btmCornerImgView       =   [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 473, 320, 7.0)];
    btmCornerImgView.image              =   [UIImage imageNamed:@"btmCorner"];
    btmCornerImgView.tag                =   75;
    btmCornerImgView.hidden             =   TRUE;
    [self.window addSubview:btmCornerImgView];
    [btmCornerImgView release];
    return YES;
}
-(void)hideBottomCorner{
    [(UIImageView*)[self.window viewWithTag:75] setHidden:TRUE];
    
}

-(void)showBottomCorner{
    [(UIImageView*)[self.window viewWithTag:75] setHidden:FALSE];
    
}

- (void) applicationDidBecomeActive:(UIApplication *)application 
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    
    // Allows other parts of the app to respond to he application becoming active
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:CashburyApplicationDidBecomeActive 
                                                                                         object:nil]];
}

//- (void) showLoginView
//{
//    self.dummy_splash_vc = [[[DummySplashViewController alloc] initWithMessage:@"Signing In"] autorelease];
//    [self.navigationController pushViewController:dummy_splash_vc animated:NO];
//    
//    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//    [self.loginViewController loginWithEmail:[prefs stringForKey:@"login_email"] andPassword:[prefs stringForKey:@"login_password"] andUsername:@"" andFirstName:[prefs stringForKey:@"login_first_name"] andLastName:[prefs stringForKey:@"login_last_name"] andShowLoading:NO];
//}

- (void)dealloc
{
    [window release];
    [scanHistoryArray release];
    [placesArray release];
    [super dealloc];
}

/*
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
	return [[self.loginViewController facebook] handleOpenURL:url];
}

 */
@end
