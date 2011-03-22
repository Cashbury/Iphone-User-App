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
}

- (IBAction) forgot_password{
	[self hideKeyboard];
}

- (IBAction) signup {
	[self hideKeyboard];
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

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

/**
 * Called when the request logout has succeeded.
 */
- (void)didLogout {
	NSLog(@".....didLogout");
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
	NSLog(@"did login to Facebook with UID");
	//NSString *password = [[NSString alloc] initWithFormat:@"fb%@", [result objectForKey:@"id"]];
	NSString *password = [KZUtils md5ForString:[NSString stringWithFormat:@"fb%@bf", _uid]];
	NSString *encoded_full_name = [KZUtils urlEncodeForString:_name];
	
	//[label setText:[[[NSString alloc] initWithFormat:@"Welcome %@", full_name] autorelease]];
	
	
	//		/users/sessions.xml
	//		post_params = email=eng.basayel@gmail.com&password=123456&full_name=basayel%20said
	
	//NSString *url_str = [[NSString alloc] initWithString:@"http://localhost:3000/login.xml"];//[NSString stringWithFormat:@"http://localhost:3000/login.xml?email=%@%40facebook.com.fake&password=%@&full_name=%@", uid, uid, uid];
	NSString *url_str = [NSString stringWithFormat:@"%@/users/sign_in.xml", API_URL];
	NSString *params = [NSString stringWithFormat:@"email=%@%%40facebook.com.fake&password=%@&full_name=%@", _uid, password, encoded_full_name];
	//NSLog(@">>>>>> %@\n", params);
	NSURL *_url = [[NSURL alloc] initWithString:url_str];
	NSMutableDictionary *_headers = [[NSMutableDictionary alloc] init];
	
	[_headers setValue:@"application/xml" forKey:@"Accept"];
	
	login_request = [[KZURLRequest alloc] initRequestWithURL:_url params:params
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
	NSLog(@"%@", [theError description]);
}

- (void) KZURLRequest:(KZURLRequest *)theRequest didSucceedWithData:(NSData*)theData {
	/**
	 Response:
	 <?xml version="1.0" encoding="UTF-8"?>
	 <user>
	 <id type="integer">5</id>
	 <authentication-token>Al9OAveJ62IqUuF1U_nN</authentication-token>
	 </user>
	 */
    if (theRequest == login_request)
    {
        CXMLDocument *_document = [[[CXMLDocument alloc] initWithData:theData options:0 error:nil] autorelease];
        NSLog(@"##Response XML######## %@", [_document stringValue]);
        NSArray *_nodes = [_document nodesForXPath:@"//user" error:nil];

        for (CXMLElement *_node in _nodes)
        {
			[KZApplication setUserId:[_node stringFromChildNamed:@"id"]];
			[KZApplication setAuthenticationToken:[_node stringFromChildNamed:@"authentication-token"]];
        }
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
