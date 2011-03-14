//
//  KZRewardViewController.m
//  Cashbery
//
//  Created by Basayel Said on 3/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "KZRewardViewController.h"
#import "KZStampView.h"
#import "KZReward.h"
#import "KZPlaceInfoViewController.h"
#import "QRCodeReader.h"

@interface KZRewardViewController (PrivateMethods)
- (BOOL) userHasEnoughPoints;
- (void) didTapInfoButton:(id)theSender;
- (void) didUpdatePoints;
@end


@implementation KZRewardViewController

@synthesize businessNameLabel, rewardNameLabel, descriptionLabel, 
			pointsValueLabel, button, starImage, showToClaimLabel, 
			grantRewardLabel, gageBackground, pointsLabel, 
			stampView, reward, place;

//------------------------------------
// Init & dealloc
//------------------------------------

- (id) initWithReward:(KZReward*)theReward
{
    self = [super initWithNibName:@"KZRewardView" bundle:nil];
    
    if (self != nil)
    {
		self.reward = theReward;
        self.place = theReward.place;
        
        pointsArchive = [[KZApplication shared] pointsArchive];
        pointsArchive.delegate = self;
        
        earnedPoints = [pointsArchive pointsForBusinessIdentifier:self.place.businessIdentifier];
    }
    
    return self;    
}

- (void)dealloc
{
	[reward release];
	[place release];
	[businessNameLabel release];
	[rewardNameLabel release];
	[descriptionLabel release];
	[pointsValueLabel release];
	[button release];
	[starImage release];
	[showToClaimLabel release];
	[grantRewardLabel release];
	[gageBackground release];
	[pointsLabel release];
	[stampView release];
    
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
    scrollView.delegate = self;
	
    pageControl.numberOfPages = kNumberOfPages;
    pageControl.currentPage = 0;
	
    // pages are created on demand
    // load the visible page
    // load the page on either side to avoid flashes when the user starts scrolling
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
	 */
	//////////////////////////////////////////////////////
	
	
	stampView = [[KZStampView alloc] initWithFrame:CGRectMake(35, 156, 250, 18)
									numberOfStamps:reward.points
						   numberOfCollectedStamps:0];
	
	[self.view addSubview:stampView];
	
	[self didUpdatePoints];
	
    if (self.place != nil)
    {
        self.title = place.name;
        
        self.businessNameLabel.text = place.name;
        self.descriptionLabel.text = place.description;
        
        if (reward)
        {
            stampView = [[KZStampView alloc] initWithFrame:CGRectMake(35, 156, 250, 18)
                                            numberOfStamps:reward.points
                                   numberOfCollectedStamps:0];
            
            [self.view addSubview:stampView];
            
            [self didUpdatePoints];
        }
        
        //UIBarButtonItem *_infoButton = [[UIBarButtonItem alloc] initWithTitle:@"Info" style:UIBarButtonItemStylePlain target:self action:@selector(didTapInfoButton:)];          
        //self.navigationItem.rightBarButtonItem = _infoButton;
        //[_infoButton release];
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
    
    self.businessNameLabel = nil;
    self.rewardNameLabel = nil;
    self.descriptionLabel = nil;
    self.pointsLabel = nil;
    self.stampView = nil;
    self.button = nil;
    self.starImage = nil;
    self.showToClaimLabel = nil;
    self.grantRewardLabel = nil;
    self.gageBackground = nil;
    self.pointsValueLabel = nil;    
}

//------------------------------------
// ZXingDelegateMethods
//------------------------------------

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
// UIAlertViewDelegate methods
//------------------------------------
#pragma mark -
#pragma mark UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        ready = YES;
        
        [pointsArchive setPoints:(earnedPoints - reward.points) forBusiness:self.place.businessIdentifier];
    }
}


//------------------------------------
// KZPointsLibraryDelegate methods
//------------------------------------
#pragma mark -
#pragma mark KZPointsLibraryDelegate methods

- (void)didUpdatePointsForBusinessIdentifier:(NSString *)theBusinessIdentifier points:(NSUInteger)thePoints
{
    if (theBusinessIdentifier == self.place.businessIdentifier)
    {
        earnedPoints = thePoints;
        
        if (reward)
        {
            [self didUpdatePoints];
            
            if ([self userHasEnoughPoints])
            {
                UIAlertView *_alert = [[UIAlertView alloc] initWithTitle:@"Reward Unlocked"
                                                                 message:@"When ready to enjoy your reward, simply select it and click Enjoy"
                                                                delegate:nil
                                                       cancelButtonTitle:@"Woohoo"
                                                       otherButtonTitles:nil];
                [_alert show];
                [_alert release];
            }
        }
    }
}

//------------------------------------
// Actions
//------------------------------------
#pragma mark -
#pragma mark Actions

- (IBAction) didTapSnapButton:(id)theSender
{
    if ([self userHasEnoughPoints])
    {
        if (!ready)
        {
            UIAlertView *_alert = [[UIAlertView alloc] initWithTitle:@"Are you ready?"
                                                             message:@"You can redeem your award only once. Click when ready."
                                                            delegate:self
                                                   cancelButtonTitle:@"Cancel"
                                                   otherButtonTitles:@"Enjoy Now",nil];
            [_alert show];
            [_alert release];
        }
    }
    else
    {
		
        ZXingWidgetController *widController = [[ZXingWidgetController alloc] initWithDelegate:self showCancel:YES OneDMode:NO];
        QRCodeReader* qrcodeReader = [[QRCodeReader alloc] init];
        NSSet *readers = [[NSSet alloc ] initWithObjects:qrcodeReader,nil];
        [qrcodeReader release];
        widController.readers = readers;
        [readers release];
        widController.soundToPlay =
        [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"beep-beep" ofType:@"aiff"] isDirectory:NO];
        [self presentModalViewController:widController animated:YES];
        [widController release];
		 //*/
    }
}

//------------------------------------
// Private methods
//------------------------------------
#pragma mark -
#pragma mark Private methods

- (BOOL) userHasEnoughPoints
{
    NSUInteger _neededPoints = (reward) ? reward.points : 0;
    
    return (earnedPoints == _neededPoints);
}

- (void) didUpdatePoints
{
    NSUInteger _neededPoints = reward.points;
    
    self.rewardNameLabel.text = reward.name;
    self.businessNameLabel.text = place.name;
    
    if (ready)
    {
        self.stampView.hidden = YES;
        self.descriptionLabel.hidden = YES;
        self.grantRewardLabel.hidden = NO;
        self.showToClaimLabel.hidden = NO;
        self.button.hidden = YES;
        self.pointsValueLabel.hidden = YES;
        self.pointsLabel.hidden = YES;
        self.gageBackground.hidden = YES;
        self.starImage.hidden = YES;
    }
    else
    {
        self.stampView.hidden = NO;
        self.stampView.numberOfCollectedStamps = earnedPoints;
        self.descriptionLabel.hidden = NO;
        self.gageBackground.hidden = NO;
        
        if (earnedPoints == _neededPoints)
        {
            self.starImage.hidden = NO;
            self.pointsValueLabel.hidden = YES;
            self.pointsLabel.hidden = YES;
            [self.button setImage:[UIImage imageNamed:@"button-enjoy.png"] forState:UIControlStateNormal];
            
            self.descriptionLabel.text = @"This reward is ready to be enjoyed";
        }
        else
        {
            self.starImage.hidden = YES;
            self.pointsLabel.hidden = NO;
            self.pointsValueLabel.hidden = NO;
            self.pointsValueLabel.text = [NSString stringWithFormat:@"%d", earnedPoints];
            [self.button setImage:[UIImage imageNamed:@"button-snap.png"] forState:UIControlStateNormal];
            
            self.descriptionLabel.text = reward.description;
        }
    }
	
	if ([self userHasEnoughPoints])
	{
		UIAlertView *_alert = [[UIAlertView alloc] initWithTitle:@"Reward Unlocked"
														 message:@"When ready to enjoy your reward, simply select it and click Enjoy"
														delegate:nil
											   cancelButtonTitle:@"Woohoo"
											   otherButtonTitles:nil];
		[_alert show];
		[_alert release];
	}
	
}

- (void) didTapInfoButton:(id)theSender
{
    KZPlaceInfoViewController *_infoController = [[KZPlaceInfoViewController alloc] initWithNibName:@"KZPlaceInfoView" bundle:nil place:self.place];
    [self presentModalViewController:_infoController animated:YES];
    
    [_infoController release];
}

@end
