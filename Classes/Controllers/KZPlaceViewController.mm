//
//  KZPlaceViewController.m
//  Kazdoor
//
//  Created by Rami on 13/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "KZPlaceViewController.h"
#import "KZStampView.h"
#import "KZReward.h"
#import "NSMutableArray+Helper.h"
#import "KZRewardViewController.h"
#import "KZPlaceInfoViewController.h"
#import "FacebookWrapper.h"
#import "KZApplication.h"

@class KZRewardViewController;

@implementation KZPlaceViewController

@synthesize scrollView, viewControllers, place, place_btn, other_btn;
//------------------------------------
// Init & dealloc
//------------------------------------

- (id) initWithPlace:(KZPlace*)thePlace
{
    self = [super initWithNibName:@"KZPlaceView" bundle:nil];
    
    if (self != nil)
    {
        self.place = thePlace;
    }
    
    return self;    
}

- (void)dealloc
{
	[scrollView release];
	[viewControllers release];
	[place release];
    [pageControl release];
	
    [super dealloc];
}

//------------------------------------
// UIViewController methods
//------------------------------------

- (void)viewDidLoad
{
    [super viewDidLoad];
	[KZApplication setPlaceScrollView:self.view];
	[self.navigationController setNavigationBarHidden:YES];
    //////////////////////////////////////////////////////
	
	// order the buttons on the toolbar
	UIFont *myFont = [UIFont boldSystemFontOfSize:22.0];	
	CGSize size = [place.businessName sizeWithFont:myFont forWidth:190.0 lineBreakMode:UILineBreakModeTailTruncation];
	[self.place_btn setTitle:place.businessName forState:UIControlStateNormal];
	CGRect other_frame = self.other_btn.frame;
	other_frame.origin.x = 50 + size.width;
	CGRect place_frame = self.place_btn.frame;
	place_frame.size.width = size.width;
	self.other_btn.frame = other_frame;
	self.place_btn.frame = place_frame;
	
	//////////////////////////////////////////////////////
	int count = [[self.place rewards] count];

	// view controllers are created lazily
    // in the meantime, load the array with placeholders which will be replaced on demand
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
	self.viewControllers = controllers;
	[controllers release];
	for (int i = 0; i < count; i++) {
		KZRewardViewController *vc = [[KZRewardViewController alloc] 
									  initWithReward:[[self.place rewards] objectAtIndex:i]];		
		[self.viewControllers addObject:vc];
		
		[vc release];
	}

    // a page is the width of the scroll view
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * count, 320);
    scrollView.showsHorizontalScrollIndicator = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
	
    pageControl.numberOfPages = count;
    pageControl.currentPage = 0;
	
    // pages are created on demand
    // load the visible page
    // load the page on either side to avoid flashes when the user starts scrolling
	[self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];

	//////////////////////////////////////////////////////
	
    if (self.place != nil)
    {
        self.title = place.name;
        
		//UIBarButtonItem *_infoButton = [[UIBarButtonItem alloc] initWithTitle:@"Info" style:UIBarButtonItemStyleBordered target:self action:@selector(didTapInfoButton:)];
		//self.navigationItem.rightBarButtonItem = _infoButton;
		//[_infoButton release];
		
        /*//
		//UIBarButtonItem *_backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
		//self.navigationItem.backBarButtonItem = _backButton;
		//[_backButton release];
		//*/
    }
}


- (void)loadScrollViewWithPage:(int)page {
	if (self.viewControllers == nil) return; 
	int count = [self.viewControllers count];
	if (count <= 0) return; 
    if (page < 0) return;
    if (page >= count) return;
	
    // replace the placeholder if necessary
    KZRewardViewController *controller = [self.viewControllers objectAtIndex:page];
	controller.place_view_controller = self;
    if ((NSNull *)controller == [NSNull null]) {
        controller = [[KZRewardViewController alloc] 
					initWithReward:[[self.place rewards] objectAtIndex:page]];
        [self.viewControllers replaceObjectAtIndex:page withObject:controller];
        [controller release];
    }
	
    // add the controller's view to the scroll view
    if (nil == controller.view.superview) {
        CGRect frame = scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        [scrollView addSubview:controller.view];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    ready = NO;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
}
//------------------------------------
//------------------------------------
/*
#pragma mark -

- (void)didUpdatePointsForBusinessIdentifier:(NSString *)theBusinessIdentifier points:(NSUInteger)thePoints {
    if (theBusinessIdentifier == self.place.businessIdentifier)
    {
        earnedPoints = thePoints;
        int count = [self.viewControllers count];
		for (int i = 0 ; i < count ; i++) {
			if ((NSNull *)[self.viewControllers objectAtIndex:i] != [NSNull null]) {
				[((KZRewardViewController*)[self.viewControllers objectAtIndex:i]) didUpdatePoints];
			}
		}
    }
}
*/
//------------------------------------
// Private methods
//------------------------------------

- (IBAction) didTapInfoButton:(id)theSender {
	KZPlaceInfoViewController *_infoController = [[KZPlaceInfoViewController alloc] initWithNibName: @"KZPlaceInfoView" bundle: nil place: self.place];
    [self presentModalViewController:_infoController animated:YES];
	[_infoController release];
}

- (IBAction) goBack:(id)theSender {
	[self.navigationController popViewControllerAnimated:YES];
}

- (void) didPublish {
	NSLog(@"did publish to Facebook");
}

@end
