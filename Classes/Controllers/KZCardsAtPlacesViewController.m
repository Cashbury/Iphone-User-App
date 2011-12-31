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

- (void) didTapPlaces:(id)sender
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

- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void) didUpdatePlaces
{
	[KZApplication hideLoading];
}

- (void) didFailUpdatePlaces
{
	[KZApplication hideLoading];
}


- (IBAction) didTapOnCard:(id)sender
{
	KZUserIDCardViewController* user_id_card = [[KZUserIDCardViewController alloc] initWithBusiness:[self currentBusiness]];
	user_id_card.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[[KZApplication getAppDelegate].navigationController presentModalViewController:user_id_card animated:YES];
	[user_id_card release];	
}


@end
