//
//  LoginViewController.h
//  Cashbury
//
//  Created by Ahmed Magdy on 3/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FacebookWrapper.h"
#import "FBLoginBtn.h"
#import "KZURLRequest.h"
#import "CXMLElement+Helpers.h"
#import "TouchXML.h"
#import "KZUtils.h"

@class Facebook;

@interface LoginViewController : UIViewController <
FaceBookWrapperSessionDelegate,
KZURLRequestDelegate>{
	IBOutlet UITextField *txtEmail;
	IBOutlet UITextField *txtPassword;
	IBOutlet FBLoginBtn *fbButton;
	IBOutlet UILabel *label;
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

- (void) loginWithEmail:(NSString*)_email andPassword:(NSString*)_password andUsername:(NSString*)_username andFirstName:(NSString*)_first_name andLastName:(NSString*)_last_name andShowLoading:(BOOL)_show_loading;

@end
