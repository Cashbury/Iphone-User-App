//
//  MainScreenViewController.m
//  Cashbury
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
	
	self.title = @"Cashbury";
	
}



- (IBAction) places_action:(id) sender {
	[KZPlacesViewController showPlacesScreen];
}

- (void) logout_action:(id)sender {
	LoginViewController *loginViewController = [[KZApplication getAppDelegate] loginViewController];
	Facebook *fb = [LoginViewController getFacebook];
	if ([fb isSessionValid]) {
		[fb logout:loginViewController];
	}
	
	[KZApplication setUserId:nil];
	[KZApplication setAuthenticationToken:nil];
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

- (void)zxingController:(ZXingWidgetController*)controller didScanResult:(NSString *)result
{
    [KZApplication handleScannedQRCard:result withPlace:nil withDelegate:nil];
	[self dismissModalViewControllerAnimated:NO];
}

- (void)zxingControllerDidCancel:(ZXingWidgetController*)controller
{
    [self dismissModalViewControllerAnimated:NO];
}



@end
