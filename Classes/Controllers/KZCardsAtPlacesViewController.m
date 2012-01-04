    //
//  KZCardsAtPlacesViewController.m
//  Cashbery
//
//  Created by Basayel Said on 6/26/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import "KZCardsAtPlacesViewController.h"
#import "KZPlacesViewController.h"
#import "KZUserIDCardViewController.h"
#import "CBWalletSettingsViewController.h"
#import "UINavigationController+CustomTransitions.h"
#import "KZApplication.h"

@interface KZCardsAtPlacesViewController ()
- (void) magnifyViewController:(UIViewController *)theViewController duration:(NSTimeInterval)theDuration;
@end

@implementation KZCardsAtPlacesViewController

@synthesize cardContainer, frontCard, backCard;

//------------------------------------
// Init & dealloc
//------------------------------------
#pragma mark - Init & dealloc

- (void) dealloc
{
    [cardContainer release];
    [frontCard release];
    [backCard release];
    
    [super dealloc];
}

//------------------------------------
// View lifecycle
//------------------------------------
#pragma mark - View lifecycle

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

//------------------------------------
// Actions
//------------------------------------
#pragma mark - Actions

- (IBAction) didTapPlaces:(id)sender
{
    KZPlacesViewController *_controller = [[[KZPlacesViewController alloc] initWithNibName:@"KZPlacesView" bundle:nil] autorelease];

    [self magnifyViewController:_controller duration:0.35];
}

- (IBAction) didSlide:(id)sender
{
    KZUserIDCardViewController* user_id_card = [[KZUserIDCardViewController alloc] initWithBusiness:nil];
    user_id_card.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [[KZApplication getAppDelegate].navigationController presentModalViewController:user_id_card animated:YES];
    [user_id_card release];
}

- (IBAction) didTapSnap:(id)sender
{
}

- (IBAction) didTapNotifications:(id)sender
{
    
}

- (void) didTapProfile:(id)sender
{
    CBWalletSettingsViewController *_controller = [[[CBWalletSettingsViewController alloc] initWithNibName:@"CBWalletSettingsView" bundle:nil] autorelease];
    
    [self magnifyViewController:_controller duration:0.35];
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
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
    
    if ([frontCard superview])
    {
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.cardContainer cache:YES];
        
        [frontCard removeFromSuperview];
        [cardContainer addSubview:backCard];
    }
    else
    {
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.cardContainer cache:YES];
        
        [backCard removeFromSuperview];
        [cardContainer addSubview:frontCard];
    }
    
    [UIView commitAnimations];
}

//------------------------------------
// Private methods
//------------------------------------
#pragma mark - Private methods

- (void) magnifyViewController:(UIViewController *)theViewController duration:(NSTimeInterval)theDuration
{
    UIView *_v = theViewController.view;
    CGRect _frame = _v.frame;
    
    theViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	theViewController.view.frame = CGRectMake(0, 0,  _frame.size.width, _frame.size.height);
    
    [self.view insertSubview:_v atIndex:1];
	[self.view bringSubviewToFront:_v];
    
    _v.transform = CGAffineTransformMakeScale(.15, .15);
    
   	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.20];
	CGAffineTransform transformBig = CGAffineTransformMakeScale(1, 1);
	transformBig = CGAffineTransformTranslate(transformBig, 0, 0);	
	_v.transform = transformBig;	
	[UIView commitAnimations];
}

@end
