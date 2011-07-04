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

@implementation KZToolBarViewController

BOOL is_visible;

@synthesize navigationController, btn_snapit, btn_cards, btn_places, lbl_snapit, lbl_cards, lbl_places;

- (IBAction) snapItAction {
	[self animateLabel:self.lbl_snapit];
	[self.btn_snapit setSelected:YES];
	[self.btn_places setSelected:NO];
	[self.btn_cards setSelected:NO];
	
	[self.navigationController setNavigationBarHidden:YES];
	if ([self.navigationController.topViewController class] == [KZPlacesViewController class]) {
		[KZSnapController snapInPlace:nil];
	} else if ([self.navigationController.topViewController class] == [KZCardsAtPlacesViewController class]) {
		[self.navigationController popViewControllerAnimated:NO];
		[KZSnapController snapInPlace:nil];
	}
}

- (IBAction) showCardsAction {
	[self animateLabel:self.lbl_cards];
	[self.btn_snapit setSelected:NO];
	[self.btn_places setSelected:NO];
	[self.btn_cards setSelected:YES];
	
	[[UIApplication sharedApplication] setStatusBarHidden:NO];
	[self.navigationController setNavigationBarHidden:NO];
	if ([self.navigationController.topViewController class] != [KZCardsAtPlacesViewController class]) {
		KZCardsAtPlacesViewController* vc = [[KZCardsAtPlacesViewController alloc] initWithNibName:@"KZCardsAtPlaces" bundle:nil];
		if ([self.navigationController.topViewController class] != [KZPlacesViewController class]) {	// if snap screen is shown
			
			[self.navigationController popViewControllerAnimated:NO];
			[self.navigationController pushViewController:vc animated:NO];
			
		} else {
			[self.navigationController pushViewController:vc animated:YES];
		}
		[vc release];
	}
}


- (IBAction) showPlacesAction {
	[self animateLabel:self.lbl_places];
	[self.btn_snapit setSelected:NO];
	[self.btn_places setSelected:YES];
	[self.btn_cards setSelected:NO];
	
	[[UIApplication sharedApplication] setStatusBarHidden:NO];
	[self.navigationController setNavigationBarHidden:NO];
	if ([self.navigationController.topViewController class] != [KZPlacesViewController class]) {
		BOOL animated = YES;
		if ([self.navigationController.topViewController class] != [KZCardsAtPlacesViewController class]) animated = NO;
		[self.navigationController popViewControllerAnimated:animated];
	}
}


- (void) showToolBar:(UINavigationController*)_vc {
	self.navigationController = _vc;
	[self.btn_snapit setSelected:NO];
	[self.btn_places setSelected:NO];
	[self.btn_cards setSelected:NO];
	if ([self.navigationController.topViewController class] == [KZPlacesViewController class]) {
		[self.btn_places setSelected:YES];
	} else if ([self.navigationController.topViewController class] == [KZCardsAtPlacesViewController class]) {
		[self.btn_cards setSelected:YES];
	} else {
		[self.btn_snapit setSelected:YES];	
	}
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
