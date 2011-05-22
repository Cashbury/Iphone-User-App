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
                                                     otherButtonTitles:@"Go Back", nil];
    
    [_actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)theActionSheet clickedButtonAtIndex:(NSInteger)theButtonIndex
{
    switch (theButtonIndex)
    {
        // Sign out button is clicked
        case 0:
            [self logout_action:theActionSheet];
            break;
            
        // Go back button is clicked
        case 1:
            [self.navigationController popViewControllerAnimated:YES];
            break;
            
        default:
            break;
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
	NSString *str_url = [NSString stringWithFormat:@"%@/users/sign_out.xml?auth_token=%@", API_URL, [KZApplication getAuthenticationToken]];
	NSURL *_url = [NSURL URLWithString:str_url];
    KZURLRequest *req = [[KZURLRequest alloc] initRequestWithURL:_url delegate:nil headers:nil];
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
