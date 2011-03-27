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

@synthesize scrollView, viewControllers, place;
//------------------------------------
// Init & dealloc
//------------------------------------

- (id) initWithPlace:(KZPlace*)thePlace
{
    self = [super initWithNibName:@"KZPlaceView" bundle:nil];
    
    if (self != nil)
    {
        self.place = thePlace;
        
        //pointsArchive = [[KZApplication shared] pointsArchive];
        //pointsArchive.delegate = self;
        
        //earnedPoints = [pointsArchive pointsForBusinessIdentifier:self.place.businessIdentifier];
		
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
	
    //////////////////////////////////////////////////////
	int count = [[self.place rewards] count];
	//NSLog(@"#viewDidLoad : Count : %@", [((KZReward*)[[self.place rewards] objectAtIndex:0]) description]);
	// view controllers are created lazily
    // in the meantime, load the array with placeholders which will be replaced on demand
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
	self.viewControllers = controllers;
	[controllers release];
	for (int i = 0; i < count; i++) {
		//NSLog(@"@@@@@@ %d : %@", i , [[[self.place rewards] objectAtIndex:i] description]);
		KZRewardViewController *vc = [[KZRewardViewController alloc] 
									  initWithReward:[[self.place rewards] objectAtIndex:i]];
		//KZRewardViewController *vc2 = [[KZRewardViewController alloc] 
		//							  initWithReward:[[self.place rewards] objectAtIndex:i]];
		
		[self.viewControllers addObject:vc];
		//[self.viewControllers addObject:vc2];
		
		[vc release];
		//[vc2 release];
	}
	//count = count + count;
    // a page is the width of the scroll view
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * count, 320);
	//NSLog(@"###$$$### %d   :   %d", self.view.bounds.size.height, scrollView.bounds.size.height);
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
        
		UIBarButtonItem *_infoButton = [[UIBarButtonItem alloc] initWithTitle:@"Info" style:UIBarButtonItemStyleBordered target:self action:@selector(didTapInfoButton:)];
		self.navigationItem.rightBarButtonItem = _infoButton;
		[_infoButton release];
		
        /*//
		UIBarButtonItem *_backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
		self.navigationItem.backBarButtonItem = _backButton;
		[_backButton release];
		//*/
    }
}


- (void)loadScrollViewWithPage:(int)page {
	NSLog(@"#Page: %d", page);
	if (self.viewControllers == nil) return; 
	int count = [self.viewControllers count];
	if (count <= 0) return; 
    if (page < 0) return;
    if (page >= count) return;
	
    // replace the placeholder if necessary
    KZRewardViewController *controller = [self.viewControllers objectAtIndex:page];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

//------------------------------------
// ZXingDelegateMethods
//------------------------------------
#pragma mark -
#pragma mark ZXingDelegateMethods

- (void)zxingController:(ZXingWidgetController*)controller didScanResult:(NSString *)result
{
    [self dismissModalViewControllerAnimated:NO];
    
    // TODO, enhance the QR code matching
    NSString *_filter = @"(http://www.spinninghats.com\?){1,}.*";
    
    NSPredicate *_predicate = [NSPredicate
                               predicateWithFormat:@"SELF MATCHES %@", _filter];
    
    if ([_predicate evaluateWithObject:result] == YES)
    {
        [pointsArchive addPoints:1 forBusiness:self.place.businessIdentifier];
        
        UIAlertView *_alert = [[UIAlertView alloc] initWithTitle:@"We got you!"
                                                         message:@"+1 point"
                                                        delegate:nil
                                               cancelButtonTitle:@"Great"
                                               otherButtonTitles:nil];
        
        [_alert show];
        [_alert release];
    }
    else
    {
        UIAlertView *_alert = [[UIAlertView alloc] initWithTitle:@"Invalid Stamp"
                                                         message:@"The stamp you're trying to snap does not appear to be a valid CashBerry stamp."
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
        
        [_alert show];
        [_alert release];
    }
}

- (void)zxingControllerDidCancel:(ZXingWidgetController*)controller
{
    [self dismissModalViewControllerAnimated:YES];
}

//------------------------------------
// KZPointsLibraryDelegate methods
//------------------------------------
/*
#pragma mark -
#pragma mark KZPointsLibraryDelegate methods

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

- (void) didTapInfoButton:(id)theSender {
	KZPlaceInfoViewController *_infoController = [[KZPlaceInfoViewController alloc] initWithNibName: @"KZPlaceInfoView" bundle: nil place: self.place];
    [self presentModalViewController:_infoController animated:YES];
    [_infoController release];
}

- (void) didPublish {
	NSLog(@"did publish");
}
@end
