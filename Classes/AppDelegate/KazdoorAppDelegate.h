//
//  KazdoorAppDelegate.h
//  Kazdoor
//
//  Created by Rami on 7/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
////////////FIXME remove NSZombieEnabled before Release


#import <UIKit/UIKit.h>
#import "DummySplashViewController.h"
#import "CWRingUpViewController.h"
#import "LoginViewController.h"
#import "CBMainNavigationController.h"
#import "LoadingViewController.h"
#import <CoreData/CoreData.h>

/**
 * Fired when the app is restored from the background.
 */
extern NSString * const CashburyApplicationDidBecomeActive;

@interface KazdoorAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;

}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) CBMainNavigationController *navigationController;
@property (nonatomic, retain) CWRingUpViewController* ringup_vc;
@property (nonatomic, retain) LoginViewController *loginViewController;
@property (nonatomic, retain) UIImageView *leather_curtain;
@property (nonatomic, retain) NSMutableArray *placesArray;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


-(void)showLoadingView;
-(void)removeLoadingView;

- (void)saveContext;
@end

