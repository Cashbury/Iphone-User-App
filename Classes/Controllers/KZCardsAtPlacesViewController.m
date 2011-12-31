    //
//  KZCardsAtPlacesViewController.m
//  Cashbery
//
//  Created by Basayel Said on 6/26/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import "KZCardsAtPlacesViewController.h"
#import "CBCitySelectorViewController.h"
#import "KZUserIDCardViewController.h"
#import "CBWalletSettingsViewController.h"

@implementation KZCardsAtPlacesViewController

@synthesize frontCard, backCard;

- (void) dealloc
{
    [frontCard release];
    [backCard release];
    
    [super dealloc];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    [self.backCard removeFromSuperview];
}

- (void) viewDidUnload
{
    self.frontCard = nil;
    self.backCard = nil;
    
    [super viewDidUnload];
}

- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (IBAction) didTapPlaces:(id)sender
{
	[[KZApplication getAppDelegate].tool_bar_vc hideToolBar];
    CBCitySelectorViewController *_controller = [[CBCitySelectorViewController alloc] initWithNibName:@"CBCitySelectorView"
                                                                                               bundle:nil];
    
    CATransition *_transition = [CATransition animation];
    _transition.duration = 0.35;
    _transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    _transition.type = kCATransitionPush;
    _transition.subtype = kCATransitionFromBottom;
    
    [self.navigationController.view.layer addAnimation:_transition forKey:kCATransition];
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:_controller animated:NO];
    
    [_controller release];
}

- (IBAction) didSlide:(id)sender
{
    
}

- (IBAction) didTapSnap:(id)sender
{
    
}

- (IBAction) didTapNotifications:(id)sender
{
    
}

- (void) didTapProfile:(id)sender
{
    CBWalletSettingsViewController *_controller = [[CBWalletSettingsViewController alloc] initWithNibName:@"CBWalletSettingsView"
                                                                                                   bundle:nil];
    
    CATransition *_transition = [CATransition animation];
    _transition.duration = 0.35;
    _transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    _transition.type = kCATransitionMoveIn;
    _transition.subtype = kCATransitionFromBottom;
    
    [self.navigationController.view.layer addAnimation:_transition forKey:kCATransition];
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:_controller animated:NO];
    
    [_controller release];
}

- (void) didUpdatePlaces
{
	[KZApplication hideLoading];
}

- (void) didFailUpdatePlaces
{
	[KZApplication hideLoading];
}


- (IBAction) didTapOnCard:(id)theSender
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    
    if ([frontCard superview])
    {
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.frontCard cache:YES];
        
        [frontCard removeFromSuperview];
        [self.view addSubview:backCard];
        [self.view sendSubviewToBack:frontCard];
    }
    else
    {
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.backCard cache:YES];
        
        [backCard removeFromSuperview];
        [self.view addSubview:frontCard];
        [self.view sendSubviewToBack:backCard];
    }
    
    [UIView commitAnimations];
}



@end
