//
//  CBWalletSettingsViewController.m
//  Cashbery
//
//  Created by Rami on 17/5/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import "CBWalletSettingsViewController.h"
#import "KZApplication.h"
#import "KZURLRequest.h"
#import "FacebookWrapper.h"

@interface CBWalletSettingsViewController (PrivateMethods)
- (void) logout_action:(id)sender;
@end


@implementation CBWalletSettingsViewController

//------------------------------------
// Init & dealloc
//------------------------------------
#pragma mark - Init & dealloc

- (void)dealloc
{   
    [super dealloc];
}

//------------------------------------
// UIViewController methods
//------------------------------------
#pragma mark - UIViewController methods

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//------------------------------------
// IBAction methods
//------------------------------------
#pragma mark - IBAction methods

- (IBAction) didTapWalkOutButton:(id)theSender
{
    UIActionSheet *_actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                              delegate:self
                                                     cancelButtonTitle:@"Cancel"
                                                destructiveButtonTitle:@"Sign Out"
                                                     otherButtonTitles:nil];
    
    [_actionSheet showInView:self.view];
}

- (IBAction) didTapGoBackButton:(id)theSender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//------------------------------------
// UIActionSheetDelegate methods
//------------------------------------
#pragma mark - UIActionSheetDelegate methods

- (void)actionSheet:(UIActionSheet *)theActionSheet clickedButtonAtIndex:(NSInteger)theButtonIndex
{
    if (theButtonIndex == 0)
    {
        [self logout_action:theActionSheet];
    }
}

//------------------------------------
// Private methods
//------------------------------------
#pragma mark - Private methods

- (void) logout_action:(id)sender
{
	//[searchBar resignFirstResponder];
	[[FacebookWrapper shared] logout];
	LoginViewController *loginViewController = [[KZApplication getAppDelegate] loginViewController];
	NSString *str_url = [NSString stringWithFormat:@"%@/users/sign_out.xml?", API_URL];
    
    NSString *params = [NSString stringWithFormat:@"auth_token=%@", [KZApplication getAuthenticationToken]];
	
	NSMutableDictionary *_headers = [[NSMutableDictionary alloc] init];
	
	[_headers setValue:@"application/xml" forKey:@"Accept"];
    
    KZURLRequest *req = [[KZURLRequest alloc] initRequestWithString:str_url
                                                          andParams:params
                                                           delegate:nil
                                                            headers:_headers
                                                  andLoadingMessage:@"Signing out..."];
    [_headers release];
    [req autorelease];
	
	[KZApplication setUserId:nil];
	[KZApplication setAuthenticationToken:nil];
	
	[KZApplication persistLogout];
	UIWindow *window = [[[KZApplication getAppDelegate] window] retain];
	
	[[KZApplication getAppDelegate].navigationController.view removeFromSuperview];
	[window addSubview:[loginViewController view]];
    [window makeKeyAndVisible];
	[window release];
}

@end
