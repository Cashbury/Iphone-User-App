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
#import "StartViewController.h"

@implementation KazdoorAppDelegate


@synthesize window;
@synthesize navigationController;
@synthesize loginViewController;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    NSLog(@"ssssssssssssssssss");
    // Override point for customization after application launch.
	[KZApplication setAppDelegate:self];
	[[KZApplication shared] setLocation_helper:[[[LocationHelper alloc] init] autorelease]];
	
	/////////////////////////////////////////////////////
	//[KZApplication setUserId:@"5"];
	//[KZApplication setAuthenticationToken:@"_fPbgXUjYqUCIjSmWN5E"];

	
	loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
	StartViewController *svc = [[StartViewController alloc] initWithNibName:@"StartView" bundle:nil];
	
	[self.window addSubview:svc.view];
	[self.window makeKeyAndVisible];
	if ([KZApplication isLoggedInPersisted]) { 	
		NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
		[loginViewController loginWithEmail:[prefs stringForKey:@"login_email"] andPassword:[prefs stringForKey:@"login_password"] andFirstName:[prefs stringForKey:@"login_first_name"] andLastName:[prefs stringForKey:@"login_last_name"]];
		/*
		UIWindow *window = [[[KZApplication getAppDelegate] window] retain];
		UINavigationController *navigationController;
	
		// Add the view controller's view to the window and display.
		navigationController = [[UINavigationController alloc] initWithNibName:@"NavigationController" bundle:nil];
		[[KZApplication getAppDelegate] setNavigationController:navigationController];
		KZPlacesViewController *view_controller = [[KZPlacesViewController alloc] initWithNibName:@"KZPlacesView" bundle:nil];
		//MainScreenViewController *view_controller = [[MainScreenViewController alloc] initWithNibName:@"MainScreen" bundle:nil];//[[KZPlacesViewController alloc] initWithNibName:@"KZPlacesView" bundle:nil];
		[window addSubview:navigationController.view];
		[navigationController pushViewController:view_controller animated:YES];
	
		[window release];
		[navigationController release];
		NSLog(@"The user is logged in by id: %@", [KZApplication getUserId]);
		 */
	}
    return YES;
}

	 
- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
	NSLog(@"Out of Memory Errpr\n");
}


- (void)dealloc {
    [navigationController release];
    [window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
	return [[loginViewController facebook] handleOpenURL:url];
}

@end
