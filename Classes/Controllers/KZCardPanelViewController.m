    //
//  KZCardPanelViewController.m
//  Cashbery
//
//  Created by Basayel Said on 8/25/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import "KZCardPanelViewController.h"
#import "KZApplication.h"
#import "CBWalletSettingsViewController.h"
#import "KZCustomerReceiptHistoryViewController.h"

@implementation KZCardPanelViewController

@synthesize cell_load_up,  cell_receipts, cell_support, cell_locations, lbl_title, lbl_balance;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:@"KZCardPanelView" bundle:nil])) {
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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	UIButton *_settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _settingsButton.frame = CGRectMake(0, 0, 320, 44);
    [_settingsButton addTarget:self action:@selector(didTapSettingsButton:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = _settingsButton;
	
	[self.navigationItem setLeftBarButtonItem:[[[UIBarButtonItem alloc] initWithCustomView:[[UIView new] autorelease]] autorelease]];	
}



- (id) initWithBusiness:(KZBusiness*)_biz {
	if ((self = [super initWithNibName:@"KZCardPanelView" bundle:nil])) {
        biz = [_biz retain];
    }
    return self;
}

- (IBAction) goBack {
	
}

- (IBAction) goBackToPlaces {
	
}

- (IBAction) goBackToCards {
	
}

- (IBAction) showReceiptsHistory {
	[KZReceiptHistory getCustomerReceiptsWithDelegate:self];
}


- (void) gotCashierReceipts:(NSMutableArray*)_receipts {
	////DUMMY
}

- (void) gotCustomerReceipts:(NSMutableArray*)_receipts {
	KZCustomerReceiptHistoryViewController* vc = [[KZCustomerReceiptHistoryViewController alloc] initWithCustomerRceipts:_receipts];
	[self presentModalViewController:vc animated:YES];
	[vc release];
}

- (void) noReceiptsFound {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Sorry a server error has occurred while retrieving the Receipts. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alert show];
	[alert release];
}



- (void) didTapSettingsButton:(id)theSender {
	[[KZApplication getAppDelegate].tool_bar_vc hideToolBar];
    CBWalletSettingsViewController *_controller = [[CBWalletSettingsViewController alloc] initWithNibName:@"CBWalletSettingsView"
                                                                                                   bundle:nil];
    
    CATransition *_transition = [CATransition animation];
    _transition.duration = 0.35;
    _transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    _transition.type = kCATransitionMoveIn;
    _transition.subtype = kCATransitionFromBottom;
    
    [self.navigationController.view.layer addAnimation:_transition forKey:kCATransition];
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:_controller animated:NO];
    
    [_controller release];
}


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
	[biz release];
	
    [super dealloc];
}


@end
