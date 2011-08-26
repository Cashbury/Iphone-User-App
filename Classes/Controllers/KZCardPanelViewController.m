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
#import "KZReceiptHistory.h"

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
- (void) viewDidLoad {
    [super viewDidLoad];
	UIButton *_settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _settingsButton.frame = CGRectMake(0, 0, 320, 44);
    [_settingsButton addTarget:self action:@selector(didTapSettingsButton:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = _settingsButton;
	
	[self.navigationItem setLeftBarButtonItem:[[[UIBarButtonItem alloc] initWithCustomView:[[UIView new] autorelease]] autorelease]];	
	self.lbl_title.text = biz.name;
}



- (id) initWithBusiness:(KZBusiness*)_biz {
	if ((self = [super initWithNibName:@"KZCardPanelView" bundle:nil])) {
        biz = [_biz retain];
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
	[[KZApplication getAppDelegate].tool_bar_vc showToolBar:self.navigationController];
}


- (IBAction) goBack {
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) goBackToPlaces {
	[UIView beginAnimations:@"trans" context:nil];
	[UIView setAnimationDuration:0.35];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:[KZApplication getAppDelegate].navigationController.view cache:NO];
	[[KZApplication getAppDelegate].navigationController popViewControllerAnimated:NO];
	[[KZApplication getAppDelegate].navigationController popViewControllerAnimated:NO];
	[UIView commitAnimations];
}

- (IBAction) goBackToCards {
	[self.navigationController popViewControllerAnimated:YES];
} 

- (void) gotCashierReceipts:(NSMutableArray*)_receipts {
	////DUMMY
}

- (void) gotCustomerReceipts:(NSArray*)_receipts {
	KZCustomerReceiptHistoryViewController* vc = [[KZCustomerReceiptHistoryViewController alloc] initWithCustomerRceipts:_receipts andBusiness:biz];
	[self.navigationController pushViewController:vc animated:YES];
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
/*
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
*/

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[biz release];
	
    [super dealloc];
}




#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section	
    return 4;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {	// load up
		return self.cell_load_up;
	} else if (indexPath.row == 1) {	// receipts
		return self.cell_receipts;
	} else if (indexPath.row == 2) {	// support
		return self.cell_support;
	} else if (indexPath.row == 3) {	// branches
		return self.cell_locations;
	}
    return nil;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0) {	// load up
		
	} else if (indexPath.row == 1) {	// receipts
		[KZReceiptHistory getCustomerReceiptsForBusinessId:biz.identifier andDelegate:self];
	} else if (indexPath.row == 2) {	// support

	} else if (indexPath.row == 3) {	// branches
		
	}
	
}

@end
