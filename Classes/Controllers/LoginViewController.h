//
//  LoginViewController.h
//  Cashbery
//
//  Created by Ahmed Magdy on 3/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FBConnect.h"
#import "FBLoginBtn.h"
#import "KZURLRequest.h"
#import "CXMLElement+Helpers.h"
#import "TouchXML.h"
#import "KZUtils.h"

@class Facebook;

@interface LoginViewController : UIViewController <FBRequestDelegate,
FBDialogDelegate,
FBSessionDelegate,
KZURLRequestDelegate>{
	IBOutlet UITextField *txtEmail;
	IBOutlet UITextField *txtPassword;
	IBOutlet FBLoginBtn *fbButton;
	IBOutlet UILabel *label;
	NSArray *_permissions;
	KZURLRequest *login_request;
}

- (IBAction) hideKeyboard;
- (IBAction) loginAction;
- (IBAction) forgot_password;
- (IBAction) signup;
- (IBAction) facebook_connect;

@property (nonatomic, retain) IBOutlet UITextField *txtEmail;
@property (nonatomic, retain) IBOutlet UITextField *txtPassword;
@property (nonatomic, retain) IBOutlet UILabel *label;
@property (nonatomic, retain) IBOutlet FBLoginBtn *fbButton;

+ (Facebook *) getFacebook;

@end
