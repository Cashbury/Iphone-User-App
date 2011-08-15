    //
//  ForgotPasswordViewController.m
//  Cashbury
//
//  Created by Basayel Said on 3/24/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import "ForgotPasswordViewController.h"


@implementation ForgotPasswordViewController

@synthesize txtEmail;
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}



- (IBAction) forgotpass_action:(id)sender {
	[self hideKeyboard];
	if (![KZUtils isEmailValid:self.txtEmail.text]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cashbury" message:@"Error:\nThe Email address is invalid" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];
		[alert release];
		return;
	}
	NSString *email = self.txtEmail.text;
	
	NSString *url_str = [NSString stringWithFormat:@"%@/users/passwords.xml", API_URL];
	NSString *params = [NSString stringWithFormat:@"user[email]=%@", [KZUtils urlEncodeForString:email]];
	
	NSMutableDictionary *_headers = [[NSMutableDictionary alloc] init];
	
	[_headers setValue:@"application/xml" forKey:@"Accept"];
	
	[[[KZURLRequest alloc] initRequestWithString:url_str andParams:params delegate:self headers:_headers andLoadingMessage:@"Loading..."] autorelease];
	[_headers release];

}

- (IBAction) cancel_action:(id)sender {
	[self hideKeyboard];
	[self dismissModalViewControllerAnimated:YES];
}



//------------------------------------------
// KZURLRequestDelegate methods
//------------------------------------------
#pragma mark KZURLRequestDelegate methods

- (void) KZURLRequest:(KZURLRequest *)theRequest didFailWithError:(NSError*)theError {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cashbury" message:@"Sorry an error has occured please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alert show];
	[alert release];
}

- (void) KZURLRequest:(KZURLRequest *)theRequest didSucceedWithData:(NSData*)theData {
	/**
	 Response:
	 <?xml version="1.0" encoding="UTF-8"?>
	 <user>
	 <email>user@domain.com</email>
	 </user>
	 */
	CXMLDocument *_document = [[[CXMLDocument alloc] initWithData:theData options:0 error:nil] autorelease];
	CXMLNode *_error_node = [_document nodeForXPath:@"//error" error:nil];
	if (_error_node != nil) { 
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cashbury" message:[_error_node stringValue] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];
		[alert release];	
	} else {
		CXMLElement *_node = [_document nodeForXPath:@"//user" error:nil];
		NSString *email = [_node stringFromChildNamed:@"email"];
		[self dismissModalViewControllerAnimated:YES];
		[[KZApplication getAppDelegate].loginViewController.txtEmail setText:email];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thank you" message:@"An email has been sent to you to reset your password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];
		[alert release];
	}
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[self hideKeyboard];
	return YES;
}

- (IBAction) hideKeyboard {
	[txtEmail resignFirstResponder];
}


@end
