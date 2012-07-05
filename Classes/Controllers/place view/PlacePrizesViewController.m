//
//  PlacePrizesViewController.m
//  Cashbury
//
//  Created by Mrithula Ancy on 7/4/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#import "PlacePrizesViewController.h"
#import "CashRewardView.h"
#import "FreeReward.h"


@interface PlacePrizesViewController ()

@end

@implementation PlacePrizesViewController
@synthesize titleName;
@synthesize scrollView;
@synthesize placeObject;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)setScrollViewForPrizes{
//cashburies_starter.png
    self.scrollView.delegate    =   self;
    self.titleName.text         =   self.placeObject.name;
    [self.scrollView setContentSize:CGSizeMake(([self.placeObject.rewardsArray count] +1) * 320, self.scrollView.frame.size.height)];
    CGFloat xValue              =   320+10;
    for (int i = 0; i < [placeObject.rewardsArray count]; i ++) {
        PlaceReward *reward     =   (PlaceReward*)[placeObject.rewardsArray objectAtIndex:i];
        if (reward.isSpend) {
            //cash
            NSArray* nibViews           =   [[NSBundle mainBundle] loadNibNamed:@"CashRewardView" owner:self options:nil];
            CashRewardView *cashView    =   [nibViews objectAtIndex:0];
            cashView.frame              =   CGRectMake(xValue, 13, 299, 389);
            cashView.rewardObject       =   reward;
            cashView.placeObject        =   self.placeObject;
            
            [scrollView addSubview:cashView];
            //[cashView release];
            
            
            
        }else {
            //free
            NSArray* nibViews           =   [[NSBundle mainBundle] loadNibNamed:@"FreeReward" owner:self options:nil];
            FreeReward *freeView        =   [nibViews objectAtIndex:0];
            freeView.frame              =   CGRectMake(xValue, 13, 299, 389);
            freeView.rewardObject       =   reward;
            freeView.placeObject        =   self.placeObject;
            [scrollView addSubview:freeView];
        }
        xValue      =   xValue+320;
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setScrollViewForPrizes];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setTitleName:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [titleName release];
    [scrollView release];
    [placeObject release];
    [super dealloc];
}
- (IBAction)goBack:(id)sender {
    
    [self diminishViewController:self duration:0.35];
}
@end
