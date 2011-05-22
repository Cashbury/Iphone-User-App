//
//  KZRewardViewController.m
//  Cashbury
//
//  Created by Basayel Said on 3/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "KZRewardViewController.h"
#import "KZStampView.h"
#import "KZReward.h"
#import "KZPlaceInfoViewController.h"
#import "FacebookWrapper.h"
#import "GrantViewController.h"
#import "LegalTermsViewController.h"
#import "KZAccount.h"
#import "UIView+Utils.h"

@interface KZRewardViewController (PrivateMethods)
- (BOOL) userHasEnoughPoints;
- (void) didTapInfoButton:(id)theSender;
- (void) didUpdatePoints;
@end


@implementation KZRewardViewController

@synthesize lbl_brand_name, lbl_reward_name, img_reward_image, 
			lbl_heading1, lbl_heading2, lbl_legal_terms, 
			lbl_needed_points, tbl_table_view, cell1_snap_to_win, 
			cell2_headings, cell3_stamps, cell4_terms, cell5_bottom, 
			redeem_request, stampView, reward, place;


- (id) initWithReward:(KZReward*)theReward {
    self = [super initWithNibName:@"KZRewardView" bundle:nil];
    if (self != nil) {
		self.reward = theReward;
        self.place = theReward.place;
        earnedPoints = [[KZAccount getAccountBalanceByCampaignId:reward.campaign_id] intValue];
		tile = [[UIImage imageNamed:@"card-bg_center.png"] retain];
    }
    return self;    
}



- (void) dealloc {
	[tile release];
	[super dealloc];
}

//------------------------------------
// UIViewController methods
//------------------------------------

- (void)viewDidLoad
{
    [super viewDidLoad];
    //////////////////////////////////////////////////////
	/*
	// view controllers are created lazily
    // in the meantime, load the array with placeholders which will be replaced on demand
    NSMutableArray *controllers = [[NSMutableArray alloc] initWithNulls:kNumberOfPages];
    
	self.viewControllers = controllers;
	[controllers release];
	
    // a page is the width of the scroll view
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * kNumberOfPages, scrollView.frame.size.height);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
	
    pageControl.numberOfPages = kNumberOfPages;
    pageControl.currentPage = 0;
	
    // pages are created on demand
    // load the visible page
    // load the page on either side to avoid flashes when the user starts scrolling
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
	 
	self.stampView = [[KZStampView alloc] initWithFrame:CGRectMake(35, 156, 250, 18)
														numberOfStamps:reward.needed_amount
														numberOfCollectedStamps:5];
	
	[self.view addSubview:stampView];
	*/
	self.lbl_reward_name.text = self.reward.name;
	self.lbl_needed_points.text = [NSString stringWithFormat:@"%d", self.reward.needed_amount];
	self.lbl_brand_name.text = [NSString stringWithFormat:@"@%@", self.place.businessName];
	self.lbl_heading1.text = self.reward.heading1;
	self.lbl_heading2.text = self.reward.heading2;
	self.lbl_legal_terms.text = self.reward.legal_term;
	if (self.reward.reward_image != nil && [self.reward.reward_image isEqual:@""] != YES) { 
		// set the logo image
		req = [[KZURLRequest alloc] initRequestWithString:self.reward.reward_image 
									andParams:nil delegate:self headers:nil andLoadingMessage:nil];
	}
        /*
        if (reward)
        {
            self.stampView = [[[KZStampView alloc] initWithFrame:CGRectMake(35, 156, 250, 18)
                                            numberOfStamps:reward.points
                                   numberOfCollectedStamps:0] autorelease];
            [self.view addSubview:stampView];
			
            //[self didUpdatePoints];
        }
        */
        //UIBarButtonItem *_infoButton = [[UIBarButtonItem alloc] initWithTitle:@"Info" style:UIBarButtonItemStylePlain target:self action:@selector(didTapInfoButton:)];          
        //self.navigationItem.rightBarButtonItem = _infoButton;
        //[_infoButton release];
    
	//[self didUpdatePoints];
    
    [self.img_reward_image roundCornersUsingRadius:5 borderWidth:0 borderColor:nil];
}
/*
- (void)viewDidAppear:(BOOL)animated
{
	NSLog(@"### %@", self.reward.name);
	//[self didUpdatePoints];
}

*/

- (void)viewDidUnload
{
	[req release];
    [super viewDidUnload];
	
}



#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 5;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell;
	NSUInteger row = [indexPath row];
	if (row == 0) {
		cell = self.cell1_snap_to_win;
	} else if (row == 1) {
		cell = self.cell2_headings;
	} else if (row == 2) {
		cell = self.cell3_stamps;
	} else if (row == 3) {
		cell = self.cell4_terms;
	} else {
		cell = self.cell5_bottom;
	}
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	if (row < 4) {
		UIView *v = [[UIView alloc] init];
		v.backgroundColor = [UIColor colorWithPatternImage:tile];
		cell.backgroundColor = [UIColor whiteColor];
		v.opaque = NO;
		cell.backgroundView = v;
	}
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell;
	NSUInteger row = [indexPath row];
	if (row == 0) {
		cell = self.cell1_snap_to_win;
	} else if (row == 1) {
		cell = self.cell2_headings;
	} else if (row == 2) {
		cell = self.cell3_stamps;
	} else if (row == 3) {
		cell = self.cell4_terms;
	} else {
		cell = self.cell5_bottom;
	}
	return cell.frame.size.height;
}


- (void) KZURLRequest:(KZURLRequest *)theRequest didFailWithError:(NSError*)theError {
	///DO NOTHING
}

- (void) KZURLRequest:(KZURLRequest *)theRequest didSucceedWithData:(NSData*)theData {
	UIImage *img = [UIImage imageWithData: theData];
	CGRect image_frame = self.img_reward_image.frame;
	image_frame.size = img.size;
	self.img_reward_image.frame = image_frame;
	[self.img_reward_image setImage:img];
}

/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {}
*/

@end
