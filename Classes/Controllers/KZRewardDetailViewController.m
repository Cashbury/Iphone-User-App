    //
//  KZRewardDetailViewController.m
//  Kazdoor
//
//  Created by Rami on 27/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "KZRewardDetailViewController.h"
#import "KZPlace.h"
#import "KZAccount.h"

@implementation KZRewardDetailViewController

@synthesize reward;
@synthesize rewardTitle, placeName, statusLabel, progressView, redeemButton, grantedLabel, instructionLabel;

- (id)initWithReward:(KZReward*)theReward
{
    self = [super initWithNibName:@"KZRewardDetailView" bundle:nil];
    
    if (self != nil)
    {
        self.title = @"Offer Details";
        
        self.reward = theReward;
    }
    
    return self;    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.grantedLabel.hidden = YES;
    self.instructionLabel.hidden = YES;
    
    [self.redeemButton setTitle:@"Redeem Your Reward!" forState:UIControlStateNormal];
    self.rewardTitle.text = self.reward.name;
    
    KZPlace *_place = self.reward.place;
    NSLog(@"Place: %@", _place.name);
    self.placeName.text = _place.name;
    
    NSUInteger _earnedPoints = [[KZAccount getAccountBalanceByCampaignId:self.reward.campaign_id] intValue];
    NSLog(@"Earned points: %d", _earnedPoints);
    NSUInteger _neededPoints = self.reward.needed_amount;
    float _progress = ((float)_earnedPoints / (float)_neededPoints);
    
    self.progressView.progress = _progress;
    
    if (_earnedPoints < _neededPoints)
    {
        self.redeemButton.enabled = NO;
        self.statusLabel.text = [NSString stringWithFormat:@"Needed points: %d", (_neededPoints - _earnedPoints)];
    }
    else
    {
        self.redeemButton.enabled = YES;
        self.statusLabel.text = @"Status: Ready";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.reward = nil;
    
    self.rewardTitle = nil;
    self.placeName = nil;
    self.statusLabel = nil;
    self.progressView = nil;
    self.redeemButton = nil;
    self.grantedLabel = nil;
    self.instructionLabel = nil;
}


- (void)dealloc
{
    [reward release];
    
    [rewardTitle release];
    [placeName release];
    [statusLabel release];
    [progressView release];
    [redeemButton release];
    
    [grantedLabel release];
    [instructionLabel release];
    
    [super dealloc];
}

- (IBAction)didTapRedeemButton:(id)theSender
{
    KZPlace *_place = self.reward.place;
	NSUInteger _earnedPoints = [[KZAccount getAccountBalanceByCampaignId:self.reward.campaign_id] intValue];
    NSUInteger _neededPoints = self.reward.needed_amount;
    
    NSUInteger _newBalance = _earnedPoints - _neededPoints;
    
	NSNumber *num_balance = [[NSNumber alloc] initWithUnsignedInteger:_newBalance];
	[KZAccount updateAccountBalance:num_balance withCampaignId:self.reward.campaign_id];
	[num_balance release];
	 
    self.redeemButton.hidden = YES;
    self.statusLabel.hidden = YES;
    self.progressView.hidden = YES;
    
    self.grantedLabel.hidden = NO;
    self.instructionLabel.hidden = NO;
}


@end
