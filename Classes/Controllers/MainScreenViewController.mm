//
//  MainScreenViewController.m
//  Cashbery
//
//  Created by Basayel Said on 3/15/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import "MainScreenViewController.h"
#import "KZApplication.h"
#import "KZPlacesViewController.h"
#import "LoginViewController.h"
#import "QRCodeReader.h"

@implementation MainScreenViewController

/**
 * Set initial view
 */
- (void)viewDidLoad {
	UIImage *backgroundTile = [UIImage imageNamed: @"bg.png"];
	UIColor *backgroundPattern = [[UIColor alloc] initWithPatternImage:backgroundTile];
	[self.view setBackgroundColor:backgroundPattern];
	[backgroundPattern release];
	
	[self.navigationController setNavigationBarHidden:NO];
	self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
	self.navigationController.navigationBar.tintColor = [UIColor blackColor];
	self.title = @"Cashbury";
	
	UIBarButtonItem *logout_btn = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(logout_action:)];
	self.navigationItem.rightBarButtonItem = logout_btn;
	[logout_btn release];
	
	UIBarButtonItem *_backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
	self.navigationItem.backBarButtonItem = _backButton;
	[_backButton release];
	
}

- (IBAction) snap_action:(id) sender {
	ZXingWidgetController *widController = [[ZXingWidgetController alloc] initWithDelegate:self showCancel:YES OneDMode:NO];
	QRCodeReader* qrcodeReader = [[QRCodeReader alloc] init];
	NSSet *readers = [[NSSet alloc ] initWithObjects:qrcodeReader,nil];
	[qrcodeReader release];
	widController.readers = readers;
	[readers release];
	widController.soundToPlay = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"beep-beep" ofType:@"aiff"] isDirectory:NO];
	[self presentModalViewController:widController animated:YES];
	[widController release];
}

- (IBAction) places_action:(id) sender {
	UINavigationController *navigationController = [KZApplication getAppDelegate].navigationController;
	KZPlacesViewController *view_controller = [[KZPlacesViewController alloc] initWithNibName:@"KZPlacesView" bundle:nil];
	[navigationController pushViewController:view_controller animated:YES];
	[view_controller release];
}

- (void) logout_action:(id)sender {
	LoginViewController *loginViewController = [[KZApplication getAppDelegate] loginViewController];
	Facebook *fb = [LoginViewController getFacebook];
	if ([fb isSessionValid]) {
		[fb logout:loginViewController];
	}
	
	[KZApplication setUserId:nil];
	UIWindow *window = [[[KZApplication getAppDelegate] window] retain];
	
	int upper_bound = [[window subviews] count] - 1;
	UIView *v = [[window subviews] objectAtIndex:upper_bound];
	[v removeFromSuperview];
	[window addSubview:[loginViewController view]];
    [window makeKeyAndVisible];
	[window release];
}

//------------------------------------
// ZXingDelegateMethods
//------------------------------------

- (void)zxingController:(ZXingWidgetController*)controller didScanResult:(NSString *)result
{
    [self dismissModalViewControllerAnimated:NO];
    [KZApplication handleScannedQRCard:result];
}

- (void)zxingControllerDidCancel:(ZXingWidgetController*)controller
{
    [self dismissModalViewControllerAnimated:YES];
}



@end
