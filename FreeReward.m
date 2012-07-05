//
//  FreeReward.m
//  Cashbury
//
//  Created by Mrithula Ancy on 7/5/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#import "FreeReward.h"
#import "RewardStarView.h"

@implementation FreeReward
@synthesize pointsNeededLabel;
@synthesize rewardNameLabel;
@synthesize detailsLabel;
@synthesize eButton;
@synthesize unLockView;
@synthesize crownImageView;
@synthesize placeImageView;
@synthesize lockedScroll;
@synthesize lockView;
@synthesize tapToEnjoy;
@synthesize placeObject,rewardObject;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    self.rewardNameLabel.text   =   self.rewardObject.rewardName;
    self.detailsLabel.text      =   [NSString stringWithFormat:@"@%@",self.placeObject.name];
    
    UILabel *stillLocked        =   (UILabel*)[unLockView viewWithTag:1];
    UILabel *scoreMore          =   (UILabel*)[unLockView viewWithTag:2];
    [placeImageView loadImageWithAsyncUrl:[NSURL URLWithString:self.placeObject.smallImgURL]];
    
    
    PlaceAccount *getAcc    =   [placeObject.accountsDict objectForKey:[NSString stringWithFormat:@"%d",self.rewardObject.campaignID]];
    if ([getAcc.amount intValue] >= [self.rewardObject.neededAmount intValue]) {
        //tap to enjoy
        self.unLockView.hidden      =   FALSE;
        self.lockView.hidden        =   TRUE;
        stillLocked.text            =   @"Your reward is ready to be enjoyed.";
        scoreMore.text              =   @"Come on in to enjoy anytime.";
        pointsNeededLabel.text      =   @"Ready to enjoy";
        crownImageView.highlighted  =   TRUE;
        tapToEnjoy.highlighted      =   TRUE;
    }else {
        //lock
        self.unLockView.hidden      =   TRUE;
        self.lockView.hidden        =   FALSE;
        pointsNeededLabel.text      =   [NSString stringWithFormat:@"+%d points needed to enjoy. Score: %d",[self.rewardObject.neededAmount intValue]- [getAcc.amount intValue],[getAcc.amount intValue]];
        
    }
    // set all view in lock
    CGFloat xValue                  =   50;
    NSInteger numSpend              =   [getAcc.amount intValue];
    
    for (int i = 0; i < [self.rewardObject.neededAmount intValue]/5; i ++) {
        NSArray* nibViews           =   [[NSBundle mainBundle] loadNibNamed:@"RewardStarView" owner:self options:nil];
        RewardStarView *starView    =   [nibViews objectAtIndex:0];
        if (i == 0) {
            
            UIImageView *crownView  =   (UIImageView*)[starView viewWithTag:6];
            crownView.hidden        =   FALSE;
            if ([getAcc.amount intValue] >= [self.rewardObject.neededAmount intValue]) {
                crownView.highlighted   =   TRUE;
            }
        }
        if (numSpend > 0) {
            for (int j = 1; j <=5 ; j ++) {
                if (j <= numSpend) {
                    UIImageView *smallStars =   (UIImageView*)[starView viewWithTag:j];
                    if ([getAcc.amount intValue] >= [self.rewardObject.neededAmount intValue]) {
                        [smallStars setImage:[UIImage imageNamed:@"Stamp-green"]];
                    }else {
                        smallStars.highlighted  =   TRUE;
                    }
                    
                }
            }
            numSpend                    =   numSpend-5;
        }
        
        starView.frame              =   CGRectMake(0, xValue, 296, 71.0);
        [self.lockedScroll addSubview:starView];
        xValue                      =   xValue + 71;
    }
    
    [self.lockedScroll setContentSize:CGSizeMake(self.lockedScroll.frame.size.width, xValue)];
    
}


- (IBAction)eButton:(id)sender {
    if ([lockView isHidden]) {
        // show locked
        [UIView transitionWithView:self duration:0.5 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
            self.lockView.hidden            =   FALSE;
            self.unLockView.hidden          =   TRUE;
            self.placeImageView.hidden      =   FALSE;
        }completion:^(BOOL finished){
        }];
    }else{
        //show unlocked
        [UIView transitionWithView:self duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            self.lockView.hidden            =   TRUE;
            self.placeImageView.hidden      =   TRUE;
            self.unLockView.hidden      =   FALSE;
        }completion:^(BOOL finished){
        }];
        
    }
}
- (void)dealloc {
    [pointsNeededLabel release];
    [rewardNameLabel release];
    [detailsLabel release];
    [eButton release];
    [unLockView release];
    [crownImageView release];
    [placeImageView release];
    [lockedScroll release];
    [placeObject release];
    [rewardObject release];
    [lockView release];
    [tapToEnjoy release];
    [super dealloc];
}
@end
