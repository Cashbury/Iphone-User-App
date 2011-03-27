//
//  LoginViewController.m
//  Cashbery
//
//  Created by Ahmed Magdy on 3/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "FBConnect.h"
#import "KZApplication.h"
#import "KZUtils.h"
#import "KZPlacesViewController.h"
#import "MainScreenViewController.h"
#import "FacebookWrapper.h"
#import "ForgotPasswordViewController.h"
#import "SignupViewController.h"


@implementation LoginViewController

@class KZUtils;


@synthesize txtEmail, txtPassword;
@synthesize label;
@synthesize fbButton;


/////////////////////////////////////////////

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[self hideKeyboard];
	return YES;
}

- (IBAction) hideKeyboard {
	[txtEmail resignFirstResponder];
	[txtPassword resignFirstResponder];
}

- (IBAction) loginAction{
	[self hideKeyboard];
	if (![self isInputValid]) return; 
	[self prvLoginWithEmail:self.txtEmail.text andPassword:self.txtPassword.text andName:nil];
}

- (IBAction) forgot_password{
	[self hideKeyboard];
	ForgotPasswordViewController *forgot_pass = [[ForgotPasswordViewController alloc] initWithNibName:@"ForgotPasswordView" bundle:nil];
	[self presentModalViewController:forgot_pass animated:YES];
}

- (IBAction) signup {
	[self hideKeyboard];
	SignupViewController *signup = [[SignupViewController alloc] initWithNibName:@"SignupView" bundle:nil];
	[self presentModalViewController:signup animated:YES];
}

- (IBAction) facebook_connect{
	FacebookWrapper *shared = [FacebookWrapper shared];
	[FacebookWrapper setSessionDelegate:self];
	[self hideKeyboard];
	if ([[self fbButton] isLoggedIn]) {
		[shared logout];
	} else {
		[shared login];
	}
}


// FBSession /////////////////////////////////////////
/*
- (void)session:(FBSession*)session didLogin:(FBUID)uid {
 /////TODO handle login
}
*/

//////////////////////////////////////////////////////////////////////////////////////////////////
// UIViewController


/**
 * Set initial view
 */
- (void)viewDidLoad {
	[label setText:@"Please log in"];
	[fbButton updateImage];
	
	//[self didLoginWithUid:@"520370946" andName:@"Ahmed Magdy"];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

- (void)dealloc {
	[label release];
	[fbButton release];
	[super dealloc];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}
*/
/**
 * Called when the request logout has succeeded.
 */
- (void)didLogout {
	if ([KZApplication isLoggedIn]) {
		[KZApplication setUserId:nil];
		[KZApplication setAuthenticationToken:nil];
	}
	//if (!fbButton.isLoggedIn) {
	[label setText:@"Logged out Successfully"];
	fbButton.isLoggedIn         = NO;
	[fbButton updateImage];
	//}
}

- (BOOL) isInputValid {
	BOOL output = YES;
	NSMutableString *error_msg = [[NSMutableString alloc] initWithString:@"Error:"];
	if (![KZUtils isEmailValid:self.txtEmail.text]) {
		[error_msg appendString:@"\nThe Email address is invalid"];
		output = NO;
	}
	if (![KZUtils isPasswordValid:self.txtPassword.text]) {
		[error_msg appendString:@"\nThe password is invalid; it should be at least 6 characters."];
		output = NO;
	}
	if (output == NO) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cashbury" message:error_msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];
		[alert release];
	}
	return output;
}

- (void) didNotLogin {
	NSLog(@"Could not Login");
}

- (void) fbDidLogin {
	NSLog(@"Logged in to Facebook");
	fbButton.isLoggedIn         = YES;
	[fbButton updateImage];
}

- (void) didLoginWithUid:(NSString *)_uid andName:(NSString *)_name {
	[KZApplication setFullName:_name];
	NSString *email = [NSString stringWithFormat:@"%@@facebook.com.fake", _uid];
	NSString *password = [KZUtils md5ForString:[NSString stringWithFormat:@"fb%@bf", _uid]];
	[self prvLoginWithEmail:email andPassword:password andName:_name];
}

- (void) prvLoginWithEmail:(NSString*)_email andPassword:(NSString*)_password andName:(NSString*)_name {
	NSString *full_name_param = (_name == nil ? @"" : [NSString stringWithFormat:@"&full_name=%@", [KZUtils urlEncodeForString:_name]]);
	NSString *url_str = [NSString stringWithFormat:@"%@/users/sign_in.xml", API_URL];
	NSString *params = [NSString stringWithFormat:@"email=%@&password=%@%@", _email, _password, full_name_param];

	NSURL *_url = [[NSURL alloc] initWithString:url_str];
	NSMutableDictionary *_headers = [[NSMutableDictionary alloc] init];
	
	[_headers setValue:@"application/xml" forKey:@"Accept"];
	
	KZURLRequest *login_request = [[KZURLRequest alloc] initRequestWithURL:_url params:params
													delegate:self
													 headers:_headers];
	
	[_url release];
	[_headers release];
}

////////////////////////////////////////////////////////////////////////////////
// FBDialogDelegate

/**
 * Called when a UIServer Dialog successfully return.
 */
- (void)dialogDidComplete:(FBDialog *)dialog {
	[label setText:@"publish successfully"];
}

//------------------------------------------
// KZURLRequestDelegate methods
//------------------------------------------
#pragma mark KZURLRequestDelegate methods

- (void) KZURLRequest:(KZURLRequest *)theRequest didFailWithError:(NSError*)theError {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cashbery" message:@"Sorry an error has occured please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alert show];
	[alert release];
}

- (void) KZURLRequest:(KZURLRequest *)theRequest didSucceedWithData:(NSData*)theData {
	/**
	 Response:
	 <?xml version="1.0" encoding="UTF-8"?>
	 <user>
		<id type="integer">5</id>
		<full-name>Full Name</full-name>
		<email>user@domain.com</email>
		<authentication-token>Al9OAveJ62IqUuF1U_nN</authentication-token>
	 </user>
	 */
  //  if (theRequest == login_request)
  //  {
	CXMLDocument *_document = [[[CXMLDocument alloc] initWithData:theData options:0 error:nil] autorelease];
	CXMLElement *_error_node = [_document nodeForXPath:@"//error" error:nil];
	if (_error_node != nil) { 
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cashbery" message:[_error_node stringValue] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];
		[alert release];	
	} else {
        CXMLElement *_node = [_document nodeForXPath:@"//user" error:nil];
		[KZApplication setUserId:[_node stringFromChildNamed:@"id"]];
		[KZApplication setFullName:[_node stringFromChildNamed:@"full-name"]];
		[KZApplication setAuthenticationToken:[_node stringFromChildNamed:@"authentication-token"]];
        
		if ([KZApplication isLoggedIn]) {
			UIWindow *window = [[[KZApplication getAppDelegate] window] retain];
			UINavigationController *navigationController;
			
			// Add the view controller's view to the window and display.
			navigationController = [[UINavigationController alloc] initWithNibName:@"NavigationController" bundle:nil];
			[[KZApplication getAppDelegate] setNavigationController:navigationController];
			KZPlacesViewController *view_controller = [[KZPlacesViewController alloc] initWithNibName:@"KZPlacesView" bundle:nil];
			//MainScreenViewController *view_controller = [[MainScreenViewController alloc] initWithNibName:@"MainScreen" bundle:nil];//[[KZPlacesViewController alloc] initWithNibName:@"KZPlacesView" bundle:nil];
			[window addSubview:navigationController.view];
			[navigationController pushViewController:view_controller animated:YES];
			
			[window release];
			[navigationController release];
			NSLog(@"The user is logged in by id: %@", [KZApplication getUserId]);
		}
	}	
}


@end
