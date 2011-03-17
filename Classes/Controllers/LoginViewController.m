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

//#define API_URL @"http://www.spinninghats.com"
//#define API_URL @"http://localcashbery"
#define API_URL @"http://demo.espace.com.eg:9900"

// Your Facebook APP Id must be set before running this example
// See http://www.facebook.com/developers/createapp.php
// Also, your application must bind to the fb[app_id]:// URL
// scheme (substitue [app_id] for your real Facebook app id).
static NSString* kAppId = @"158482100873206";
static Facebook *_facebook = nil;

@implementation LoginViewController

@class KZUtils;
@class Facebook;

@synthesize txtEmail, txtPassword;
@synthesize label;
@synthesize fbButton;

///////////////////////////////////////////////////////////////////////////////////////////////////
// private

/**
 * Show the authorization dialog.
 */
- (void)login {
	[_facebook authorize:_permissions delegate:self];
}

/**
 * Invalidate the access token and clear the cookie.
 */
- (void)logout {
	if ([_facebook isSessionValid]) {
		[_facebook logout:self];
	}
}

- (void) didLogout {
	if ([KZApplication isLoggedIn]) {
		[KZApplication setUserId:nil];
	}
}

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
	[self hideKeyboard];
	if ([[self fbButton] isLoggedIn]) {
		[self logout];
	} else {
		[self login];
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
 * initialization
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (!kAppId) {
		NSLog(@"missing app id!");
		exit(1);
		return nil;
	}
	
	
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		_permissions =  [[NSArray arrayWithObjects:
						  @"read_stream", @"offline_access",nil] retain];
	}
	
	return self;
}

/**
 * Set initial view
 */
- (void)viewDidLoad {
	if (_facebook == nil) {
		_facebook = [[Facebook alloc] initWithAppId:kAppId];
	}
	[label setText:@"Please log in"];
	[fbButton updateImage];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

- (void)dealloc {
	[label release];
	[fbButton release];
	[_permissions release];
	[super dealloc];
}

//////////////////////////////////////////////////////
/**
 * Make a Graph API Call to get information about the current logged in user.
 */
- (void)getUserInfo {
	[_facebook requestWithGraphPath:@"me" andDelegate:self];
}

/**
 * Make a REST API call to get a user's name using FQL.
 */
- (void)getPublicInfo {
	NSMutableDictionary * params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
									@"SELECT uid,name FROM user WHERE uid=4", @"query",
									nil];
	[_facebook requestWithMethodName:@"fql.query"
						   andParams:params
					   andHttpMethod:@"POST"
						 andDelegate:self];
}

/**
 * Open an inline dialog that allows the logged in user to publish a story to his or
 * her wall.
 */
- (IBAction)publishStream {
	
	SBJSON *jsonWriter = [[SBJSON new] autorelease];
	
	NSDictionary* actionLinks = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:
														   @"Always Running",@"text",@"http://itsti.me/",@"href", nil], nil];
	
	NSString *actionLinksStr = [jsonWriter stringWithObject:actionLinks];
	NSDictionary* attachment = [NSDictionary dictionaryWithObjectsAndKeys:
								@"a long run", @"name",
								@"The Facebook Running app", @"caption",
								@"it is fun", @"description",
								@"http://itsti.me/", @"href", nil];
	NSString *attachmentStr = [jsonWriter stringWithObject:attachment];
	NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								   @"Share on Facebook",  @"user_message_prompt",
								   actionLinksStr, @"action_links",
								   attachmentStr, @"attachment",
								   nil];
	
	
	[_facebook dialog:@"feed"
			andParams:params
		  andDelegate:self];
	
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

/**
 * Called when the user has logged in successfully.
 */
- (void)fbDidLogin {
	label.text = @"Loading Please wait...";
	[fbButton setIsLoggedIn:YES];
	[fbButton updateImage];
	[self getUserInfo];
	
}

/**
 * Called when the user canceled the authorization dialog.
 */
-(void)fbDidNotLogin:(BOOL)cancelled {
	[label setText:@"Sorry could not login"];
}

/**
 * Called when the request logout has succeeded.
 */
- (void)fbDidLogout {
	[label setText:@"Logged out Successfully"];
	fbButton.isLoggedIn         = NO;
	[fbButton updateImage];
	
}

////////////////////////////////////////////////////////////////////////////////
// FBRequestDelegate

/**
 * Called when the Facebook API request has returned a response. This callback
 * gives you access to the raw response. It's called before
 * (void)request:(FBRequest *)request didLoad:(id)result,
 * which is passed the parsed response object.
 */
- (void)request: (FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
	NSLog(@"received response: %@\n", [[response URL] absoluteString]);
}

/**
 * Called when a request returns and its response has been parsed into
 * an object. The resulting object may be a dictionary, an array, a string,
 * or a number, depending on the format of the API response. If you need access
 * to the raw response, use:
 *
 * (void)request:(FBRequest *)request
 *      didReceiveResponse:(NSURLResponse *)response
 */
- (void)request:(FBRequest *)request didLoad:(id)result {
	if ([result isKindOfClass:[NSArray class]]) {
		result = [result objectAtIndex:0];
	}
	NSString *uid = [result objectForKey:@"id"];
	NSString *full_name = [result objectForKey:@"name"];
	//NSString *password = [[NSString alloc] initWithFormat:@"fb%@", [result objectForKey:@"id"]];
	NSString *password = [KZUtils md5ForString:[NSString stringWithFormat:@"fb%@bf", uid]];
	NSString *encoded_full_name = [KZUtils urlEncodeForString:full_name];

	[label setText:[[[NSString alloc] initWithFormat:@"Welcome %@", full_name] autorelease]];
	

	//    /login.xml?email=eng.basayel@gmail.com&password=123456&full_name=basayel%20said
	
	//NSString *url_str = [[NSString alloc] initWithString:@"http://localhost:3000/login.xml"];//[NSString stringWithFormat:@"http://localhost:3000/login.xml?email=%@%40facebook.com.fake&password=%@&full_name=%@", uid, uid, uid];
	NSString *url_str = [[NSString alloc] initWithFormat:@"%@/login.xml?email=%@%%40facebook.com.fake&password=%@&full_name=%@", API_URL, uid, password, encoded_full_name];
	//NSLog(@"%@\n", url_str);
	NSURL *_url = [[NSURL alloc] initWithString:url_str];
	[url_str release];
	NSMutableDictionary *_headers = [[NSMutableDictionary alloc] init];
	
	[_headers setValue:@"application/xml" forKey:@"Accept"];
	
	login_request = [[KZURLRequest alloc] initRequestWithURL:_url
													delegate:self
													 headers:_headers];
	
	[_url release];
	[_headers release];
};

/**
 * Called when an error prevents the Facebook API request from completing
 * successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
	[label setText:[error localizedDescription]];
};

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
}

- (void) KZURLRequest:(KZURLRequest *)theRequest didSucceedWithData:(NSData*)theData {
    if (theRequest == login_request)
    {
        CXMLDocument *_document = [[[CXMLDocument alloc] initWithData:theData options:0 error:nil] autorelease];
        
        NSArray *_nodes = [_document nodesForXPath:@"//user" error:nil];

        for (CXMLElement *_node in _nodes)
        {
			[KZApplication setUserId:[_node stringFromChildNamed:@"id"]];
        }
		if ([KZApplication isLoggedIn]) {
			UIWindow *window = [[[KZApplication getAppDelegate] window] retain];
			UINavigationController *navigationController;
			
			// Add the view controller's view to the window and display.
			navigationController = [[UINavigationController alloc] initWithNibName:@"NavigationController" bundle:nil];
			[[KZApplication getAppDelegate] setNavigationController:navigationController];
			//KZPlacesViewController *view_controller = [[KZPlacesViewController alloc] initWithNibName:@"KZPlacesView" bundle:nil];
			MainScreenViewController *view_controller = [[MainScreenViewController alloc] initWithNibName:@"MainScreen" bundle:nil];//[[KZPlacesViewController alloc] initWithNibName:@"KZPlacesView" bundle:nil];
			[window addSubview:navigationController.view];
			[navigationController pushViewController:view_controller animated:YES];
			
			[window release];
			[navigationController release];
			NSLog(@"The user is logged in by id: %@", [KZApplication getUserId]);
		}
    }	
}

+ (Facebook *) getFacebook {
	return _facebook;
}

@end
