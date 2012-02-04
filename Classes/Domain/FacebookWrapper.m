//
//  FacebookWrapper.m
//  Cashbury
//
//  Created by Basayel Said on 3/21/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import "FacebookWrapper.h"
#import "KZUserInfo.h"

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
	[_facebook logout:self];
}


/**
 * Make a Graph API Call to get information about the current logged in user.
 */
- (void)getUserInfo {
	[_facebook requestWithGraphPath:@"me" andDelegate:self];
} 

- (void)getUserImage {
    [_facebook requestWithGraphPath:@"me/picture?type=normal" andDelegate:self];
	////// http://graph.facebook.com/000000000/picture
}


/**
 * Open an inline dialog that allows the logged in user to publish a story to his or
 * her wall.
 */
- (void) publishStreamWithText:(NSString*)text andCaption:(NSString*)caption andImage:(NSString*)_image {
	/*
	SBJSON *jsonWriter = [[SBJSON new] autorelease];
	NSDictionary* actionLinks = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:
														   @"Cashbury",@"text",
														   nil], nil];
	
	NSString *actionLinksStr = [jsonWriter stringWithObject:actionLinks];
	
	NSDictionary* attachment = [NSDictionary dictionaryWithObjectsAndKeys:
									   @"Cashbury", @"name",
									   @"Cashbury is an awesome smart wallet that gets you rewards for going places. It's fun free and forever green. Get the app today. You will love it!", @"description",
									   nil];
	NSString *attachmentStr = [jsonWriter stringWithObject:attachment];
	
	NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								   APP_ID, @"api_key",
								   @"Post on Facebook",  @"user_message_prompt",
								   _image, @"picture", 
								   text, @"message",
								   @"http://www.cashbury.com", @"link",
								   attachmentStr, @"attachment",
								   nil];
	 */
	
	NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								   APP_ID, @"api_key",
								   @"Post on Facebook",  @"user_message_prompt",
								   [NSString stringWithFormat:@"%@ %@", [[KZUserInfo shared] getFullName], text], @"name",
								   @" ", @"caption",
								   @"http://s3.amazonaws.com/cashbury-dev/C-crowned-facebook.png", @"icon",
								   _image, @"picture", 
								   @"Cashbury is an awesome wallet for you smart phone that saves your money, and helps you discover your town. \nWith Cashbury no more forgetting, no more cards to bring, no more fat wallets to deal with. \nIt's fun, free and forever green. Get you free app today. You will love it!", @"description",
								   @"http://www.cashbury.com", @"link",
								   nil];
	[_facebook dialog:@"feed" andParams:params andDelegate:self];
	/*
	 ////RETRYME
	//NSArray *permissions =  [[NSArray arrayWithObjects:@"publish_stream",@"read_stream",@"offline_access",nil] retain];     
	//if (![_facebook isSessionValid]) {
	[_facebook authorize:permissions delegate:self];
	//}
	
	[_facebook requestWithGraphPath:@"/me/feed" andParams:params andHttpMethod:@"POST" andDelegate:self];
	//[_facebook openUrl:[NSString stringWithFormat:@"http://graph.facebook.com/%@/feed", APP_ID] params:params httpMethod:@"POST" delegate:self];
	 */
}

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
	[self getUserInfo];
	[self getUserImage];
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
	NSString *url = [[response URL] absoluteString];
	NSRange r = [[url lowercaseString] rangeOfString:@"\\.(jpg|jpeg|png|gif)$" options:NSRegularExpressionSearch];
	if (r.location != NSNotFound) {
		// if this is the facebook image then save it
		NSLog(@"This is the image URL: %@", url);
		NSData* data = [[NSData alloc] initWithContentsOfURL:[response URL]];
		//NSString* extension = [[[response URL] lastPathComponent] pathExtension];
		//NSLog([NSString stringWithFormat:@"facebook_user_image.%@", extension]);
		[FileSaver saveFile:@"facebook_user_image" andData:data];
	}
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
	//if (https://graph.facebook.com/me/picture) then  skip this part 
    BOOL isImageRequest = [request.url isEqualToString:@"https://graph.facebook.com/me/picture?type=normal"];
	if (isImageRequest) return;
	
	// if get user info request
	if ([result isKindOfClass:[NSArray class]]) {
		result = [result objectAtIndex:0];
	}
	//NSLog(@"\n\nFacebook Output:\n======================\n %@\n\n", [result description]);
	if (session_delegate != nil) [session_delegate didLoginWithUid:[result objectForKey:@"id"] andUsername:[result objectForKey:@"username"] andFirstName:[result objectForKey:@"first_name"] andLastName:[result objectForKey:@"last_name"]];
};

/**
 * Called when an error prevents the Facebook API request from completing
 * successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
	//[label setText:[error localizedDescription]];
	if (nil != session_delegate) [session_delegate didNotLogin];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cashbury" message:@"Sorry there was an error while requesting data from Facebook." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alert show];
	[alert release];
};





@end
