//
//  FacebookWrapper.h
//  Cashbury
//
//  Created by Basayel Said on 3/21/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"

// Your Facebook APP Id must be set before running this example
// See http://www.facebook.com/developers/createapp.php
// Also, your application must bind to the fb[app_id]:// URL
// scheme (substitue [app_id] for your real Facebook app id).
#define APP_ID @"158482100873206"

@protocol FaceBookWrapperSessionDelegate
- (void) didLoginWithUid:(NSString*)_uid andName:(NSString*)_name;
- (void) didLogout;
- (void) didNotLogin;
- (void) fbDidLogin;
@end


@protocol FaceBookWrapperPublishDelegate
- (void) didPublish;
@end


@interface FacebookWrapper : NSObject <FBRequestDelegate,
FBDialogDelegate,
FBSessionDelegate> {
	NSArray *_permissions;
}
	+ (FacebookWrapper*) shared;
	
	+ (void) setSessionDelegate:(id<FaceBookWrapperSessionDelegate>)delegate;
	
	+ (void) setPublishDelegate:(id<FaceBookWrapperPublishDelegate>)delegate;
	
	- (void)login;
	
	- (void)logout;
	
	- (void) didLogout;
	
	- (void) getUserInfo;
	
	- (void) publishStream:(NSString*)text;
	
	- (void) fbDidLogin;
	
	- (void) fbDidNotLogin:(BOOL)cancelled;
	
	- (void) fbDidLogout;
	
	- (void) request: (FBRequest *)request didReceiveResponse:(NSURLResponse *)response;
	
	- (void) request:(FBRequest *)request didLoad:(id)result;
	
	- (void) request:(FBRequest *)request didFailWithError:(NSError *)error;
	
	- (void) dialogDidComplete:(FBDialog *)dialog;	
	

@end
