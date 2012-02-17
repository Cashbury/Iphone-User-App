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

@implementation KazdoorAppDelegate

@synthesize window, navigationController, loginViewController, dummy_splash_vc, leather_curtain, ringup_vc;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [application setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];

    // Override point for customization after application launch.
	[KZApplication setAppDelegate:self];
	[[KZApplication shared] setLocation_helper:[[[LocationHelper alloc] init] autorelease]];
	
	self.loginViewController = [[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil] autorelease];
//	self.navigationController = [[UINavigationController alloc] initWithNibName:@"NavigationController" bundle:nil];
//	/self.tool_bar_vc = [[KZToolBarViewController alloc] initWithNibName:@"KZToolBar" bundle:nil];

    [self.window addSubview:self.navigationController.view];
    [self.window makeKeyAndVisible];
    
	//if Log in data is persisted already then check with server
	if ([[KZUserInfo shared] isCredentialsPersistsed])
    {
		// show the splash screen that has the loading message
		self.dummy_splash_vc = [[[DummySplashViewController alloc] initWithMessage:@"Signing In"] autorelease];
        [self.navigationController pushViewController:dummy_splash_vc animated:NO];
		
		NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
		[self.loginViewController loginWithEmail:[prefs stringForKey:@"login_email"] andPassword:[prefs stringForKey:@"login_password"] andUsername:@"" andFirstName:[prefs stringForKey:@"login_first_name"] andLastName:[prefs stringForKey:@"login_last_name"] andShowLoading:NO];
	}
    else
    {
        // NOT Logged in then show login screen
		[self.navigationController pushViewController:loginViewController animated:NO];
	}
    return YES;
}

/*+
- (void)applicationWillResignActive:(UIApplication *)application {
    
     //Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     //Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    
     //Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     //If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    
     //Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    
     //Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     
}


- (void)applicationWillTerminate:(UIApplication *)application {
    
     //Called when the application is about to terminate.
     //See also applicationDidEnterBackground:.
     
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    
     //Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     
}
*/

- (void)dealloc {
    [window release];
    [super dealloc];
}

/*
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
	return [[self.loginViewController facebook] handleOpenURL:url];
}

 */
@end
