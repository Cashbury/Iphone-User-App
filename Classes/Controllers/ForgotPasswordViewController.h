//
//  ForgotPasswordViewController.h
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

@interface ForgotPasswordViewController : UIViewController <KZURLRequestDelegate> {
	IBOutlet UITextField *txtEmail;
}

@property (retain, nonatomic) IBOutlet UITextField *txtEmail;

- (IBAction) forgotpass_action:(id)sender;

- (IBAction) cancel_action:(id)sender;

- (IBAction) hideKeyboard;

@end