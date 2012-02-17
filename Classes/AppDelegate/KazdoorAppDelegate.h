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

@class KazdoorViewController;
@class LoginViewController;

@interface KazdoorAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) CWRingUpViewController* ringup_vc;
@property (nonatomic, retain) LoginViewController *loginViewController;
@property (nonatomic, retain) DummySplashViewController *dummy_splash_vc;
@property (nonatomic, retain) UIImageView *leather_curtain;

@end

