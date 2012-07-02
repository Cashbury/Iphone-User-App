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

/**
 * Fired when the app is restored from the background.
 */
extern NSString * const CashburyApplicationDidBecomeActive;

@interface KazdoorAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) UINavigationController *navigationController;
@property (nonatomic, retain) CWRingUpViewController* ringup_vc;
@property (nonatomic, retain) LoginViewController *loginViewController;
@property (nonatomic, retain) UIImageView *leather_curtain;
@property (nonatomic, retain) NSMutableArray *scanHistoryArray;
@property (nonatomic, retain) NSMutableArray *placesArray;

-(void)showLoadingView;
-(void)removeLoadingView;
-(void)hideBottomCorner;
-(void)showBottomCorner;
@end

