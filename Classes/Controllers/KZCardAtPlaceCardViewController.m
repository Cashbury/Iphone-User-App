    //
//  KZCardAtPlaceCardViewController.m
//  Cashbery
//
//  Created by Basayel Said on 8/28/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import "KZCardAtPlaceCardViewController.h"
#import "KZCardPanelViewController.h"
#import "KZPlaceGrandCentralViewController.h"
#import "KZApplication.h"
#import "UIButton+Helper.h"

@interface KZCardAtPlaceCardViewController (Private)
	- (void) getBrandImage;
@end

@implementation KZCardAtPlaceCardViewController


@synthesize img_logo, lbl_brand_name, btn_info;


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithBusiness:(KZBusiness *)_biz{
    if ((self = [super initWithNibName:@"KZCardAtPlaceCardView" bundle:nil])) {
		biz = [_biz retain];
    }
    return self;
}


/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.lbl_brand_name.text = biz.name;
	[self performSelectorInBackground:@selector(getBrandImage) withObject:nil];
	[self.btn_info setCustomStyle];
}

- (void) getBrandImage {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	UIImage* img = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:biz.image_url]]];
	[self.img_logo setImage:img];
	self.img_logo.layer.masksToBounds = YES;
	self.img_logo.layer.cornerRadius = 5.0;
	self.img_logo.layer.borderWidth = 1.0;
	self.img_logo.layer.borderColor = [UIColor whiteColor].CGColor;

	
	[img release];
	[pool release];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


- (IBAction) didTapInfo {	
	KZPlaceGrandCentralViewController* vc = [[[KZPlaceGrandCentralViewController alloc] initWithPlace:[[biz getPlaces] objectAtIndex:0]] autorelease];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.35];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:[KZApplication getAppDelegate].navigationController.view cache:NO];
	[[KZApplication getAppDelegate].navigationController popViewControllerAnimated:NO];
	[[KZApplication getAppDelegate].navigationController pushViewController:vc animated:NO];
	[UIView commitAnimations];
}


- (IBAction) didTapCard {
	KZCardPanelViewController* vc = [[[KZCardPanelViewController alloc] initWithBusiness:biz] autorelease];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:[KZApplication getAppDelegate].navigationController.view cache:NO];
	[[KZApplication getAppDelegate].navigationController pushViewController:vc animated:NO];
	[UIView commitAnimations];
}

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
