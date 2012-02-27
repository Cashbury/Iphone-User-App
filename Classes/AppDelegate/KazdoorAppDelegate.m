//
//  KazdoorAppDelegate.m
//  Kazdoor
//
//  Created by Rami on 7/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import "KazdoorAppDelegate.h"
#import "LoginViewController.h"
#import "KZApplication.h"
#import "KZPlacesViewController.h"
#import "KZUserInfo.h"

@interface KazdoorAppDelegate (Private)
- (void) showLoginView;
@end

@implementation KazdoorAppDelegate

@synthesize window, navigationController, loginViewController, dummy_splash_vc, leather_curtain, ringup_vc;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [application setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];

	[KZApplication setAppDelegate:self];
	[[KZApplication shared] setLocation_helper:[[[LocationHelper alloc] init] autorelease]];
	
	self.loginViewController = [[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil] autorelease];

    [self.window addSubview:self.navigationController.view];
    [self.window makeKeyAndVisible];
    
    KZUserInfo *_userInfo = [KZUserInfo shared];
    
	if ([_userInfo isCredentialsPersistsed])
    {
        if (![_userInfo.pinCode isEqualToString:@""])
        {
            CBLockViewController *_vc = [[CBLockViewController alloc] initWithNibName:@"CBLockView" bundle:nil];
            _vc.delegate = self;
            
            [self.navigationController pushViewController:_vc animated:YES];
        }
        else
        {
            [self showLoginView];
        }
	}
    else
    {
        // NOT Logged in then show login screen
		[self.navigationController pushViewController:loginViewController animated:NO];
	}
    return YES;
}

- (void) showLoginView
{
    self.dummy_splash_vc = [[[DummySplashViewController alloc] initWithMessage:@"Signing In"] autorelease];
    [self.navigationController pushViewController:dummy_splash_vc animated:NO];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [self.loginViewController loginWithEmail:[prefs stringForKey:@"login_email"] andPassword:[prefs stringForKey:@"login_password"] andUsername:@"" andFirstName:[prefs stringForKey:@"login_first_name"] andLastName:[prefs stringForKey:@"login_last_name"] andShowLoading:NO];
}

- (void)dealloc
{
    [window release];
    [super dealloc];
}

#pragma mark - CBLockViewControllerDelegate

- (void) lockViewController:(CBLockViewController *)theSender didEnterPIN:(NSString *)thePin
{
    if ([thePin isEqualToString:[KZUserInfo shared].pinCode])
    {
        [self showLoginView];
    }
    else
    {
        UIAlertView *_alert = [[[UIAlertView alloc] initWithTitle:@"Cashbury"
                                                         message:@"Wrong PIN Code."
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil] autorelease];
        
        [_alert show];
        
        [theSender clearAllFields];
    }
}

/*
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
	return [[self.loginViewController facebook] handleOpenURL:url];
}

 */
@end
