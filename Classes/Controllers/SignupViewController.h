//
//  SignupViewController.h
//  Cashbury
//
//  Created by Basayel Said on 3/24/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KZURLRequest.h"
#import "TouchXML.h"
#import "KZApplication.h"
#import "KZUtils.h"
#import "LoginViewController.h"

@interface SignupViewController : UIViewController <KZURLRequestDelegate> {

	IBOutlet UITextField *txtEmail;
	IBOutlet UITextField *txtPassword;
	IBOutlet UITextField *txtRePassword;
	IBOutlet UITextField *txtName;
}

@property (retain, nonatomic) IBOutlet UITextField *txtEmail;
@property (retain, nonatomic) IBOutlet UITextField *txtPassword;
@property (retain, nonatomic) IBOutlet UITextField *txtRePassword;
@property (retain, nonatomic) IBOutlet UITextField *txtName;

- (IBAction) signup_action:(id)sender;

- (IBAction) cancel_action:(id)sender;

- (IBAction) hideKeyboard;
@end
