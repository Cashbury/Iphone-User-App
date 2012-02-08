//
//  CBWalletSettingsViewController.m
//  Cashbury
//
//  Created by Rami on 17/5/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import "CBWalletSettingsViewController.h"
#import "KZApplication.h"
#import "KZUserInfo.h"
#import "KZUtils.h"
#import "FacebookWrapper.h"
#import <QuartzCore/QuartzCore.h>
#import "FileSaver.h"
#import "CWRingUpViewController.h"
#import "LoginViewController.h"

@interface CBWalletSettingsViewController (PrivateMethods)
- (void) logout_action:(id)sender;
- (void) prv_hideKeyBoard;

@end


@implementation CBWalletSettingsViewController

@synthesize txt_phone, lbl_name, phone_number, img_phone_field_bg, tbl_view, cell_balance, cell_phone, view_dropdown, lbl_business_name, view_for_life, view_for_work;
@synthesize profileImage, backButton, logoutButton;

//------------------------------------
// Init & dealloc
//------------------------------------
#pragma mark - Init & dealloc

- (void)dealloc
{
    [backButton release];
    [logoutButton release];
    [profileImage release];
    
    [super dealloc];
}

//------------------------------------
// UIViewController methods
//------------------------------------
#pragma mark - UIViewController methods

- (void) viewDidLoad {
	[super viewDidLoad];
	// curved edges
	self.view_dropdown.layer.masksToBounds = YES;
	self.view_dropdown.layer.cornerRadius = 5.0;
//	self.view_dropdown.layer.borderColor = [UIColor lightGrayColor].CGColor;
//	self.view_dropdown.layer.borderWidth = 1.0;
	
	if ([[KZUserInfo shared].current_profile isEqual:@"life"] == NO) {
		CGRect life_frame = self.view_for_life.frame;
		CGRect work_frame = self.view_for_work.frame;
		self.view_for_work.frame = life_frame;
		self.view_for_life.frame = work_frame;
	}
	self.lbl_business_name.text = [KZUserInfo shared].cashier_business.name;
	
	self.phone_number = [self getPersistedPhoneNumber];
	if ([KZUtils isStringValid:self.phone_number]) {
		self.txt_phone.text = self.phone_number;
		self.txt_phone.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
		[self.img_phone_field_bg setHighlighted:NO];
	} else {
		self.txt_phone.textColor = [UIColor colorWithWhite:0.8 alpha:1.0];
		[self.img_phone_field_bg setHighlighted:YES];
	}
	self.lbl_name.text = [NSString stringWithFormat:@"%@", [[KZUserInfo shared] getFullName]];
    
    self.profileImage.cropNorth = YES;
    self.profileImage.layer.cornerRadius = 5.0;
    
    // Load the profile Image
    NSString *_imagePath = [FileSaver getFilePathForFilename:@"facebook_user_image"];
    
	if ([KZUtils isStringValid:_imagePath])
    {
		UIImage *_profileImage = [UIImage imageWithContentsOfFile:_imagePath];
        
		self.profileImage.image = _profileImage;
	}
    else
    {
        NSURL *_profileURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=normal", [KZUserInfo shared].facebookID]];
        [self.profileImage loadImageWithAsyncUrl:_profileURL];
    }
}

- (void) viewDidUnload
{
    [super viewDidUnload];
    
    self.profileImage = nil;
    self.backButton = nil;
    self.logoutButton = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//------------------------------------
// IBAction methods
//------------------------------------
#pragma mark - IBAction methods

- (IBAction) didTapWalkOutButton:(id)theSender
{
    UIActionSheet *_actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                              delegate:self
                                                     cancelButtonTitle:@"Cancel"
                                                destructiveButtonTitle:@"Sign Out"
                                                     otherButtonTitles:nil];
    
    [_actionSheet showInView:self.view];
}

- (IBAction) didTapGoBackButton:(id)theSender
{
    CATransition *_transition = [CATransition animation];
    _transition.duration = 0.35;
    _transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    _transition.type = kCATransitionMoveIn;
    _transition.subtype = kCATransitionFromTop;
    
    [self.navigationController.view.layer addAnimation:_transition forKey:kCATransition];
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction) showCashierViews:(id) sender {
	
	
	if ([[KZUserInfo shared].current_profile isEqual:@"work"]) {	// if the same then open menu
		
		CGRect f = self.view_dropdown.frame;
		if (f.size.height > 44) {	// then it is open then close it
			f.size.height = 44;
		} else {	// it is closed then open it
			f.size.height = 90;
		}
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.5];
		self.view_dropdown.frame = f;
		[UIView commitAnimations];
	} else {	// switch to cashbury for work
		
		CWRingUpViewController* vc = [[CWRingUpViewController alloc] initWithBusinessId:[KZUserInfo shared].cashier_business.identifier];
		CGRect f = vc.view.frame;
		f.origin.y += 20;
		vc.view.frame = f;
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.5];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:[KZApplication getAppDelegate].window cache:NO];
	
		[[KZApplication getAppDelegate].window addSubview:vc.view];
		[UIView commitAnimations];
		//vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
		//[self presentModalViewController:vc animated:YES];
		[KZApplication getAppDelegate].ringup_vc = vc;
		[vc release];
	}
	/*
	UIAlertView *_alert = [[UIAlertView alloc] initWithTitle:@"Are you Sure ?"
													 message:@"Are you sure you want to switch to the Cashbury for work profile?"
													delegate:self
										   cancelButtonTitle:@"Cancel"
										   otherButtonTitles:@"Switch Now",nil];
	[_alert show];
	[_alert release];
	 */
}


- (IBAction) showCustomerViews:(id) sender {
	//if ([[KZUserInfo shared].current_profile isEqual:@"life"]) {	// if the same then open menu
	if ([KZUserInfo shared].cashier_business == nil) return; 
		CGRect f = self.view_dropdown.frame;
		if (f.size.height > 44) {	// then it is open then close it
			f.size.height = 44;
		} else {	// it is closed then open it
			f.size.height = 90;
		}
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.5];
		self.view_dropdown.frame = f;
		[UIView commitAnimations];
	//} else {	// switch to cashbury for life
		//////////TODO continue here
	//}
	
}



//------------------------------------
// UIActionSheetDelegate methods
//------------------------------------
#pragma mark - UIActionSheetDelegate methods

- (void)actionSheet:(UIActionSheet *)theActionSheet clickedButtonAtIndex:(NSInteger)theButtonIndex
{
    if (theButtonIndex == 0)
    {
        [self logout_action:theActionSheet];
    }
}

//------------------------------------
// Private methods
//------------------------------------
#pragma mark - Private methods

- (void) logout_action:(id)sender {
	//[searchBar resignFirstResponder];
	[[FacebookWrapper shared] logout];
    
	//NSString *str_url = [NSString stringWithFormat:@"%@/users/sign_out.xml?", API_URL];
    //NSString *params = [NSString stringWithFormat:@"auth_token=%@", [KZUserInfo shared].auth_token];
	NSString *str_url = [NSString stringWithFormat:@"%@/users/sign_out.xml?auth_token=%@", API_URL, [KZUserInfo shared].auth_token];
	
	NSMutableDictionary *_headers = [[NSMutableDictionary alloc] init];
	[_headers setValue:@"application/xml" forKey:@"Accept"];
    
    KZURLRequest *req = [[KZURLRequest alloc] initRequestWithString:str_url
                                                          andParams:nil
                                                           delegate:nil
                                                            headers:_headers
                                                  andLoadingMessage:@"Signing out..."];
    [_headers release];
    [req autorelease];
	
	[KZUserInfo shared].user_id = nil;
	[KZUserInfo shared].auth_token = nil;
	
	[[KZUserInfo shared] clearPersistedData];
    
    // Dismiss the current view
    [self.delegate dismissViewController:self];
    
    // Replace the view controllers of the navigation controller
    UINavigationController *_navController = [KZApplication getAppDelegate].navigationController;
    LoginViewController *_loginViewController = [[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil] autorelease];
    NSArray *_vcs = [NSArray arrayWithObject:_loginViewController];
    [_navController setViewControllers:_vcs animated:NO];
}

- (IBAction) hideKeyBoard {
	[self prv_hideKeyBoard];
}

- (void) prv_hideKeyBoard {
	[self.txt_phone resignFirstResponder];
	[self processPhoneNumber];
}

- (void) persistPhoneNumber:(NSString*)_phone_number {
	if (_phone_number == nil) _phone_number = @"";
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:_phone_number forKey:@"phone_number"];
	[prefs synchronize];	
}

- (NSString*) getPersistedPhoneNumber {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	return [prefs stringForKey:@"phone_number"];
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField {
	self.txt_phone.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
	[self.img_phone_field_bg setHighlighted:NO];
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[self prv_hideKeyBoard];
	return YES;
}

- (void) processPhoneNumber {
	NSString* new_phone_number = self.txt_phone.text;
	if ([new_phone_number isEqual:self.phone_number]) return;	// if old = new
	if (![KZUtils isStringValid:new_phone_number] || [new_phone_number rangeOfString:@"^(00|\\+)[0-9]+$" options:NSRegularExpressionSearch].location == NSNotFound) {
		NSLog(@"Invalid FROM mobile");
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Opps! Invalid phone Number" message:@"Enter your number starting with your country code, area code, then telphone number." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];
		[alert release];
		return;
	}

	NSMutableDictionary *_headers = [[NSMutableDictionary alloc] init];
	[_headers setValue:@"application/xml" forKey:@"Accept"];
	[[KZURLRequest alloc] initRequestWithString:
						 [NSString stringWithFormat:@"%@/users/add_my_phone/%@.xml?auth_token=%@", 
																	 API_URL, 
																	 self.txt_phone.text, 
																	 [KZUserInfo shared].auth_token]
											andParams:nil delegate:self headers:_headers andLoadingMessage:@"Loading..."];
	[_headers release];
}


- (void) KZURLRequest:(KZURLRequest *)theRequest didFailWithError:(NSError*)theError {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Sorry a server error has occurred. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alert show];
	[alert release];
}

- (void) KZURLRequest:(KZURLRequest *)theRequest didSucceedWithData:(NSData*)theData {
	NSString* str = [[NSString alloc] initWithData:theData encoding:NSUTF8StringEncoding];
	BOOL invalid = NO;
	
	NSString* error_msg = @"Enter your number starting with your country code, area code, then telphone number.";
	
	if (![KZUtils isStringValid:str]) {
		invalid = YES;
	} else {
		NSRange r = [str rangeOfString:@"^ *ERROR:" options:NSRegularExpressionSearch];
		if (r.location != NSNotFound) {
			invalid = YES;
			NSRange r2 = NSMakeRange(r.location + r.length, [str length] - (r.location + r.length));
			error_msg = [str substringWithRange:r2];
		}
	}
	[str release];
	
	if (invalid) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Opps! Invalid phone Number" message:error_msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];
		[alert release];
	} else {	// valid
		self.phone_number = self.txt_phone.text;
		[self persistPhoneNumber:self.phone_number];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Great!" message:@"This number has been linked to your account." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];
		[alert release];
	}
	/*
	CXMLDocument *_document = [[[CXMLDocument alloc] initWithData:theData options:0 error:nil] autorelease];

	NSArray *_nodes = [_document nodesForXPath:@"//user" error:nil];
	
	for (CXMLElement *_node in _nodes) {
		
	}
	*/
}









#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 2;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell;
	NSUInteger row = [indexPath row];
	if (row == 0) {
		cell = self.cell_balance;
		
	} else {
		cell = self.cell_phone;
		
	}
    
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	UIView *v = [[UIView alloc] init];
	//v.backgroundColor = [UIColor colorWithPatternImage:tile];
	cell.backgroundColor = [UIColor clearColor];
	v.opaque = NO;
	cell.backgroundView = v;
	
	return cell;
}
- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self hideKeyBoard];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell;
	NSUInteger row = [indexPath row];
	if (row == 0) {
		int height = self.view_dropdown.frame.size.height;
		if (height > 44) return self.cell_balance.frame.size.height + (height - 44);
		cell = self.cell_balance;
		
	} else {
		cell = self.cell_phone;
    }
	return cell.frame.size.height;
}


/*
- (IBAction)textFieldDidBeginEditing:(UITextField *)textField
{
    self.actifText = textField;
}


// To be link with your TextField event "Editing Did End"
//  release current TextField
- (IBAction)textFieldDidEndEditing:(UITextField *)textField
{
    self.actifText = nil;
}
*/
-(void) keyboardWillShow:(NSNotification *)note
{
    // Get the keyboard size
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] getValue: &keyboardBounds];
	
    // Detect orientation
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGRect frame = self.tbl_view.frame;
	
    // Start animation
    //[UIView beginAnimations:nil context:NULL];
   // [UIView setAnimationBeginsFromCurrentState:YES];
    //[UIView setAnimationDuration:0.3f];
	
    // Reduce size of the Table view 
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
        frame.size.height -= keyboardBounds.size.height;
    else 
        frame.size.height -= keyboardBounds.size.width;
	
    // Apply new size of table view
    self.tbl_view.frame = frame;
	
    // Scroll the table view to see the TextField just above the keyboard
    //if (self.actifText)
	//{
        CGRect textFieldRect = [self.tbl_view convertRect:self.txt_phone.bounds fromView:self.txt_phone];
        [self.tbl_view scrollRectToVisible:textFieldRect animated:YES];
	//}
	
    //[UIView commitAnimations];
}

-(void) keyboardWillHide:(NSNotification *)note
{
    // Get the keyboard size
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] getValue: &keyboardBounds];
	
    // Detect orientation
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGRect frame = self.tbl_view.frame;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];
	
    // Reduce size of the Table view 
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
        frame.size.height += keyboardBounds.size.height;
    else 
        frame.size.height += keyboardBounds.size.width;
	
    // Apply new size of table view
    self.tbl_view.frame = frame;
	
    [UIView commitAnimations];
}


@end
