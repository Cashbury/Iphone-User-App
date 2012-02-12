//
//  LoginViewController.m
//  Cashbury
//
//  Created by Ahmed Magdy on 3/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "FBConnect.h"
#import "KZApplication.h"
#import "KZUserInfo.h"
#import "KZUtils.h"
#import "FacebookWrapper.h"
#import "ForgotPasswordViewController.h"
#import "SignupViewController.h"
#import "KZCardsAtPlacesViewController.h"


@implementation LoginViewController

@class KZUtils;


@synthesize txtEmail, txtPassword;
@synthesize label;
@synthesize fbButton;



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
	[self loginWithEmail:self.txtEmail.text andPassword:self.txtPassword.text andUsername:@"" andFirstName:nil andLastName:nil andShowLoading:YES];
}

- (IBAction) forgot_password {
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
	[shared login];
}

//////////////////////////////////////////////////////////////////////////////////////////////////
// UIViewController


/**
 * Set initial view
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
	[label setText:@"Please log in"];
    
    self.navigationController.navigationBarHidden = YES;
	//[fbButton updateImage];
	
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
	if ([[KZUserInfo shared] isLoggedIn]) {
		[KZUserInfo shared].user_id = nil;
		[KZUserInfo shared].auth_token = nil;
	}
	//if (!fbButton.isLoggedIn) {
	[label setText:@"Logged out Successfully"];
	fbButton.isLoggedIn         = NO;
	//[fbButton updateImage];
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
	[KZApplication hideLoading];
	[[FacebookWrapper shared] logout];
	NSLog(@"Could not Login");
	
}

- (void) fbDidLogin {
	[KZApplication showLoadingScreen:nil];
	NSLog(@"Logged in to Facebook");
	fbButton.isLoggedIn         = YES;
	//[fbButton updateImage];
}


- (void) didLoginWithUid:(NSString*)_uid andUsername:(NSString*)_username andFirstName:(NSString*)_first_name andLastName:(NSString*)_last_name {
	[KZUserInfo shared].first_name = _first_name;
	[KZUserInfo shared].last_name = _last_name;
    [KZUserInfo shared].facebookID = _uid;
	NSString *email = [NSString stringWithFormat:@"%@@facebook.com.fake", _uid];
	NSString *password = [KZUtils md5ForString:[NSString stringWithFormat:@"fb%@bf", _uid]];
	[self loginWithEmail:email andPassword:password andUsername:_username andFirstName:_first_name andLastName:_last_name andShowLoading:YES];
}

- (void) loginWithEmail:(NSString*)_email andPassword:(NSString*)_password andUsername:(NSString*)_username andFirstName:(NSString*)_first_name andLastName:(NSString*)_last_name andShowLoading:(BOOL)_show_loading {	
	NSString *url_str = [NSString stringWithFormat:@"%@/users/sign_in.xml", API_URL];
	NSString *params = [NSString stringWithFormat:@"email=%@&password=%@&username=%@&first_name=%@&last_name=%@", _email, _password, _username, _first_name, _last_name];
	
	NSMutableDictionary *_headers = [[NSMutableDictionary alloc] init];
	
	[_headers setValue:@"application/xml" forKey:@"Accept"];
	NSString *message;
	if (_show_loading) {
		message = @"Signing In";
	} else {
		message = nil;
	}
	KZURLRequest *login_request = [[[KZURLRequest alloc] initRequestWithString:url_str andParams:params delegate:self headers:_headers andLoadingMessage:message] autorelease];
	[_headers release];
	[KZUserInfo shared].email = _email;
	[KZUserInfo shared].password = _password;
	[KZUserInfo shared].first_name = _first_name;
	[KZUserInfo shared].last_name = _last_name;
	[KZUserInfo shared].is_logged_in = YES;
	[[KZUserInfo shared] persistData];
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
	[[KZUserInfo shared] clearPersistedData];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cashbury" message:@"Sorry an error has occured please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alert show];
	[alert release];
}

- (void) KZURLRequest:(KZURLRequest *)theRequest didSucceedWithData:(NSData*)theData {
	/**
	 Response:
	 <?xml version="1.0" encoding="UTF-8"?>
	 <user>
		<id type="integer">5</id>
		<first-name>Full Name</first-name>
		<last-name>Full Name</last-name>
		<email>user@domain.com</email>
		<authentication-token>Al9OAveJ62IqUuF1U_nN</authentication-token>
	 </user>
	 */
  //  if (theRequest == login_request)
  //  {
	
	CXMLDocument *_document = [[[CXMLDocument alloc] initWithData:theData options:0 error:nil] autorelease];
	CXMLElement *_error_node = [_document nodeForXPath:@"//error" error:nil];
	NSLog([_document description]);
	if (_error_node != nil) { 
		[KZUserInfo clearPersistedData];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cashbury" message:[_error_node stringValue] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];
		[alert release];
	} else {
        CXMLElement *_node = [_document nodeForXPath:@"//user" error:nil];
        
        // Escape the image URL
        NSString *_imageURLString = [[_node stringFromChildNamed:@"brand-image-url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
		[KZUserInfo shared].user_id = [_node stringFromChildNamed:@"id"];
		[KZUserInfo shared].currency_code = [_node stringFromChildNamed:@"currency-code"];
		[KZUserInfo shared].flag_url = [_node stringFromChildNamed:@"flag-url"];
		[KZUserInfo shared].cashier_business = [KZBusiness getBusinessWithIdentifier:[_node stringFromChildNamed:@"business-id"] 
																			 andName:[_node stringFromChildNamed:@"brand-name"] 
																		 andImageURL:[NSURL URLWithString:_imageURLString]];
		
		[KZUserInfo shared].first_name = [_node stringFromChildNamed:@"first-name"];
		[KZUserInfo shared].last_name = [_node stringFromChildNamed:@"last-name"];
		[KZUserInfo shared].auth_token = [_node stringFromChildNamed:@"authentication-token"];
		if ([[KZUserInfo shared] isLoggedIn]) {
			//UIWindow *window = [[[KZApplication getAppDelegate] window] retain];
			//UINavigationController *navigationController = [KZApplication getAppDelegate].navigationController;
			/////////////////FIXTHIS
			//KZPlacesViewController *view_controller = [[KZPlacesViewController alloc] initWithNibName:@"KZPlacesView" bundle:nil];			
			
			KZCardsAtPlacesViewController *_cardsViewController = [[KZCardsAtPlacesViewController alloc] initWithNibName:@"KZCardsAtPlaces" bundle:nil];
            [[KZApplication getAppDelegate].navigationController pushViewController:_cardsViewController animated:NO];
			//[window addSubview:[KZApplication getAppDelegate].leather_curtain];
			
			//[window addSubview:navigationController.view];
			//[navigationController pushViewController:view_controller animated:YES];
			//[window release];
			
		}
	}	
}


@end
