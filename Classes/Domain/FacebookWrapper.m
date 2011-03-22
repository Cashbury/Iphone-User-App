//
//  FacebookWrapper.m
//  Cashbery
//
//  Created by Basayel Said on 3/21/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import "FacebookWrapper.h"
#import "KZApplication.h"

@implementation FacebookWrapper
@class Facebook;

static FacebookWrapper *instance = nil;
static Facebook *_facebook = nil;
static id<FaceBookWrapperSessionDelegate> session_delegate = nil;
static id<FaceBookWrapperPublishDelegate> publish_delegate = nil;

- (id)init {
	self = [super init];
	if (nil != self){
		if (_facebook == nil) {
			_facebook = [[Facebook alloc] initWithAppId:APP_ID];
		}
		_permissions =  [[NSArray arrayWithObjects:
						  @"read_stream", @"offline_access",nil] retain];
	}
	return self;
}


+ (void) setSessionDelegate:(id<FaceBookWrapperSessionDelegate>)delegate {
	[session_delegate release];
	session_delegate = [delegate retain];
	return session_delegate;
}

+ (void) setPublishDelegate:(id<FaceBookWrapperPublishDelegate>)delegate {
	[publish_delegate release];
	publish_delegate = [delegate retain];
	return publish_delegate;
}

+ (FacebookWrapper*) shared {
	if (nil == instance) {
		instance = [[FacebookWrapper alloc] init];
	}
	return instance;
}

- (void)dealloc {
	[_facebook release];
	[_permissions release];
    [super dealloc];
}




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
	NSLog(@"Facebook logout");
	if ([_facebook isSessionValid]) {
		NSLog(@"Logging out from facebook");
		[_facebook logout:self];
	}
}


// FBSession /////////////////////////////////////////
/*
 - (void)session:(FBSession*)session didLogin:(FBUID)uid {
 /////TODO handle login
 }
 */

//////////////////////////////////////////////////////
/**
 * Make a Graph API Call to get information about the current logged in user.
 */
- (void)getUserInfo {
	[_facebook requestWithGraphPath:@"me" andDelegate:self];
}

/**
 * Make a REST API call to get a user's name using FQL.

- (void)getPublicInfo {
	NSMutableDictionary * params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
									@"SELECT uid,name FROM user WHERE uid=4", @"query",
									nil];
	[_facebook requestWithMethodName:@"fql.query"
						   andParams:params
					   andHttpMethod:@"POST"
						 andDelegate:self];
}
 */

/**
 * Open an inline dialog that allows the logged in user to publish a story to his or
 * her wall.
 */
- (void) publishStreamWithText:(NSString*)text andCaption:(NSString*)caption {
	SBJSON *jsonWriter = [[SBJSON new] autorelease];
	
	NSDictionary* actionLinks = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:
														   @"Cashbury",@"text",@"http:///www.spinninghats.com",@"href", nil], nil];
	
	NSString *actionLinksStr = [jsonWriter stringWithObject:actionLinks];
	NSDictionary* attachment = [NSDictionary dictionaryWithObjectsAndKeys:
								@"Cashbury", @"name",
								caption, @"caption",
								text, @"description", nil]; 
								//@"http:///www.spinninghats.com", @"href", nil];
	NSString *attachmentStr = [jsonWriter stringWithObject:attachment];
	NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								   APP_ID, @"api_key",
								   @"Share on Facebook",  @"user_message_prompt",
								   actionLinksStr, @"action_links",
								   attachmentStr, @"attachment",
								   nil];
	
	
	[_facebook dialog:@"stream.publish"
			andParams:params
		  andDelegate:self];
}
////////////////////////////////////////////////////////////////////////////////
// FBDialogDelegate

/**
 * Called when a UIServer Dialog successfully return.
 */
- (void)dialogDidComplete:(FBDialog *)dialog {
	if (nil != publish_delegate) [publish_delegate didPublish];
}


/**
 * Called when the user has logged in successfully.
 */
- (void)fbDidLogin {
	//label.text = @"Loading Please wait...";
	//[fbButton setIsLoggedIn:YES];
	//[fbButton updateImage];
	[self getUserInfo];
	if (session_delegate != nil) [session_delegate fbDidLogin]; 
}

/**
 * Called when the user canceled the authorization dialog.
 */
-(void)fbDidNotLogin:(BOOL)cancelled {
	//[label setText:@"Sorry could not login"];
	if (nil != session_delegate) [session_delegate didNotLogin]; 
}

/**
 * Called when the request logout has succeeded.
 */
- (void)fbDidLogout {
	if (nil != session_delegate) [session_delegate didLogout];
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
	if (session_delegate != nil) [session_delegate didLoginWithUid:[result objectForKey:@"id"] andName:[result objectForKey:@"name"]];
};

/**
 * Called when an error prevents the Facebook API request from completing
 * successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
	//[label setText:[error localizedDescription]];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cashbery" message:@"Sorry there was an error while requesting data from Facebook." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alert show];
	[alert release];
};





@end
