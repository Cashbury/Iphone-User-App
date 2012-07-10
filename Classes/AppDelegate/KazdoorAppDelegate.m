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
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

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
	
	self.loginViewController    =   [[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil] autorelease];
    self.navigationController   =   [[UINavigationController alloc]initWithRootViewController:self.loginViewController];

    [self.window addSubview:self.navigationController.view];
    [self.window makeKeyAndVisible];
    
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

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Cashbury" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Cashbury.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
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
    [__managedObjectContext release];
    [__managedObjectModel release];
    [__persistentStoreCoordinator release];
    [super dealloc];
}

/*
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
	return [[self.loginViewController facebook] handleOpenURL:url];
}

 */
@end
