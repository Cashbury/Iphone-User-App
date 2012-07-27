//
//  CBMainNavigationController.m
//  Cashbury
//
//  Created by Rami on 28/2/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#import "CBMainNavigationController.h"
#import "CBMagnifiableViewController.h"
#import "KZUserInfo.h"
#import "KZApplication.h"
#import "KazdoorAppDelegate.h"
#import "KZEngagementHandler.h"

@implementation CBMainNavigationController

- (void) viewDidBecomeActive
{
    KZUserInfo *_userInfo = [KZUserInfo shared];
    if ([_userInfo isScanner] == TRUE) {
        ZXingWidgetController* vc = [KZEngagementHandler snap];
        UINavigationController *zxingnavController  =   [[UINavigationController alloc]initWithRootViewController:vc];
        [vc.navigationController.navigationBar setHidden:TRUE];
        if (IS_IOS_5_OR_NEWER)
        {
            [self presentViewController:zxingnavController animated:FALSE completion:nil];
        }
        else
        {
            [self presentModalViewController:zxingnavController animated:FALSE];
        }
        [zxingnavController release];
    }
    
    
    if ([_userInfo hasPINCode])
    {
        UIView *getView =    nil;
        NSArray *getArray   =   [self.view subviews];
        if ([getArray count] > 0) {
            getView =   [[self.view subviews] lastObject];
        }
        UIResponder* nextResponder = [getView nextResponder];
        if (![nextResponder isKindOfClass:[CBLockViewController class]]) {
            CBLockViewController *_vc = [[CBLockViewController alloc] initWithNibName:@"CBLockView" bundle:nil];
            _vc.delegate = self;
            
            [((KazdoorAppDelegate*)[[UIApplication sharedApplication] delegate]).navigationController magnifyViewController:_vc duration:0];
            
            [_vc clearAllFields];
            
        }
        
        
    }
}

#pragma mark - CBLockViewControllerDelegate

- (void) lockViewController:(CBLockViewController *)theSender didEnterPIN:(NSString *)thePin
{
    if ([thePin isEqualToString:[KZUserInfo shared].pinCode])
    {
        [self diminishViewController:theSender duration:0.3];
        
        [theSender release];
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

@end
