    //
//  KZToolBarViewController.m
//  Cashbery
//
//  Created by Basayel Said on 7/4/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import "KZToolBarViewController.h"
#import "KZPlacesViewController.h"
#import "KZCardsAtPlacesViewController.h"
#import "KZSnapController.h"
#import "KZInboxViewController.h"
#import "ZXingWidgetController.h"
#import "KZMainCashburiesViewController.h"

@implementation KZToolBarViewController

BOOL is_visible;

@synthesize navigationController, btn_snapit, btn_cards, btn_places, lbl_snapit, lbl_places, btn_inbox, btn_cashburies, lbl_inbox, lbl_cashburies;

- (void) touch_button:(UIButton*)_btn andLabel:(UILabel*)_lbl {
	[self.btn_snapit setSelected:NO];
	[self.btn_places setSelected:NO];
	[self.btn_cards setSelected:NO];
	[self.btn_inbox setSelected:NO];
	[self.btn_cashburies setSelected:NO];
	if (_btn != nil) [_btn setSelected:YES];
	if (_lbl != nil) [self animateLabel:_lbl];
}

- (void) showView:(UIViewController*)_vc {
	
	if ([self.navigationController.topViewController class] == [_vc class]) return;		// reopening the same appearing view
	if ([_vc class] == [ZXingWidgetController class]) {
		[self.navigationController setNavigationBarHidden:YES];
	} else {
		[[UIApplication sharedApplication] setStatusBarHidden:NO];
		[self.navigationController setNavigationBarHidden:NO];
	}
	if (self.navigationController.topViewController == nil) {							// there was no view controller before
		[self.navigationController pushViewController:_vc animated:YES];
		return;
	}
	
	BOOL bool_push = NO;
	BOOL bool_pop = NO;
	BOOL bool_pop_animated = NO;
	BOOL bool_push_animated = NO;
	
	if ([self.navigationController.topViewController class] == [ZXingWidgetController class]) {	// if snap screen is shown
		[KZSnapController cancel];
		bool_pop = YES;
	} else if ([self.navigationController.topViewController class] != [KZPlacesViewController class]) {
		bool_pop = YES;
	}
	if (_vc != nil) {	// if nil then do not push so we are going back to places screen
		if ([_vc class] != [KZPlacesViewController class]) {
			bool_push = YES;
		}
	}
	bool_pop_animated = (!bool_push && [self.navigationController.topViewController class] != [ZXingWidgetController class]);
	bool_push_animated = ([_vc class] != [ZXingWidgetController class] && [self.navigationController.topViewController class] != [ZXingWidgetController class]);
	if (bool_pop) [self.navigationController popViewControllerAnimated:bool_pop_animated];
	if (bool_push) [self.navigationController pushViewController:_vc animated:bool_push_animated];
	
}

- (IBAction) snapItAction {
	[self touch_button:self.btn_snapit andLabel:self.lbl_snapit];
	
	
	ZXingWidgetController* vc = [KZSnapController snapInPlace:nil];
	[self showView:vc];
}

- (IBAction) inboxAction {
	[self touch_button:self.btn_inbox andLabel:self.lbl_inbox];
	KZInboxViewController *vc = [[KZInboxViewController alloc] initWithNibName:@"KZInboxView" bundle:nil];
	[self showView:vc];
	[vc release];
}

- (IBAction) cashburiesAction {
	[self touch_button:self.btn_cashburies andLabel:self.lbl_cashburies];
	KZMainCashburiesViewController *vc = [[KZMainCashburiesViewController alloc] initWithNibName:@"KZMainCashburiesView" bundle:nil];
	[self showView:vc];
	[vc release];
}

- (IBAction) showCardsAction {
	[self touch_button:self.btn_cards andLabel:nil];
	
	KZCardsAtPlacesViewController* vc = [[KZCardsAtPlacesViewController alloc] initWithNibName:@"KZCardsAtPlaces" bundle:nil];
	[self showView:vc];
	[vc release];
}


- (IBAction) showPlacesAction {
	[self touch_button:self.btn_places andLabel:self.lbl_places];
	[self showView:nil];
}


- (void) showToolBar:(UINavigationController*)_vc {
	self.navigationController = _vc;
	UIButton* btn = nil;
	if ([self.navigationController.topViewController class] == [KZPlacesViewController class]) {
		btn = self.btn_places;
	} else if ([self.navigationController.topViewController class] == [KZCardsAtPlacesViewController class]) {
		btn = self.btn_cards;
	} else if ([self.navigationController.topViewController class] == [ZXingWidgetController class]) {
		btn = self.btn_snapit;	
	} else if ([self.navigationController.topViewController class] == [KZInboxViewController class]) {
		btn = self.btn_inbox;
	} else if ([self.navigationController.topViewController class] == [KZMainCashburiesViewController class]) {
		btn = self.btn_cashburies;
	}
	
	[self touch_button:btn andLabel:nil];
	
	if (is_visible) {
		return;
	}
	is_visible = YES;
	
	
	//[self.view removeFromSuperview];
	
	CGRect f = self.view.frame;
	f.origin.y = _vc.view.frame.size.height - self.view.frame.size.height;
	if ([_vc.navigationController isNavigationBarHidden] != YES) f.origin.y += _vc.navigationItem.titleView.frame.size.height;
	
	self.view.frame = f;
	[_vc.view addSubview:self.view];
}

- (void) hideToolBar {
	is_visible = NO;
	[self.view removeFromSuperview];
}

- (void) animateLabel:(UILabel*)_lbl {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[_lbl setAlpha:1.0];
	[UIView commitAnimations];
	[self performSelector:@selector(completeAnimateLabel:) withObject:_lbl afterDelay:2.0];
}

 - (void) completeAnimateLabel:(UILabel*)_lbl {
	 [UIView beginAnimations:nil context:NULL];
	 [UIView setAnimationDuration:0.5];
	 [_lbl setAlpha:0.0];
	 [UIView commitAnimations]; 
 }
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


@end
