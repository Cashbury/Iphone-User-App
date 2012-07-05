//
//  CashRewardView.m
//  Cashbury
//
//  Created by Mrithula Ancy on 7/5/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#import "CashRewardView.h"

@implementation CashRewardView
@synthesize pointsNeededLabel;
@synthesize rewardObject,placeObject;
@synthesize lockedView;
@synthesize unLockedView;
@synthesize lockedScrollView;
@synthesize heading2Label;
@synthesize spendMoreLabel;
@synthesize spendUntilLabel;
@synthesize coinnImageView;
@synthesize eButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        
    }
    return self;
}

-(void)updateSpendUntilLabel{
    //spend until
    if ([self.rewardObject.spendUntil length] > 0) {
        
		NSDateFormatter *df     =   [[NSDateFormatter alloc] init];
        NSDate *getDate         =   [[NSDate alloc] init];
        [df setDateFormat:@"yyyy-MM-dd"];
        getDate                 =   [df dateFromString:self.rewardObject.spendUntil];
		[df setDateFormat:@"MMMM, d"];
        
		spendUntilLabel.text    =   [NSString stringWithFormat:@"valid until %@", [df stringFromDate:getDate]];
		[df release];
        //[getDate release];
	} else {
		spendUntilLabel.text    =   @"to spend any time";
	}
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    appDelegate             =   [[UIApplication sharedApplication] delegate];
    
    //set all labels
    UILabel *rNameLabel     =   (UILabel*)[self viewWithTag:1];
    rNameLabel.text         =   self.rewardObject.rewardName;

    UILabel *heading2       =   (UILabel*)[lockedScrollView viewWithTag:3];
    heading2.text           =   rewardObject.heading2;
    
    UILabel *spendmore      =   (UILabel*)[lockedScrollView viewWithTag:4];
    spendmore.text          =   @"Spend more ";
    
    [self.lockedScrollView setContentSize:CGSizeMake(self.lockedScrollView.frame.size.width, 300)];
    
    
    UILabel *rewardLocked   =   (UILabel*)[unLockedView viewWithTag:3];
    
    UILabel *scoreMore      =   (UILabel*)[unLockedView viewWithTag:4];
    
    PlaceAccount *getAcc    =   [placeObject.accountsDict objectForKey:[NSString stringWithFormat:@"%d",self.rewardObject.campaignID]];
    if ([getAcc.amount intValue] >= [self.rewardObject.neededAmount intValue]) {
        //unlock
        unLockedView.hidden             =   FALSE;
        lockedView.hidden               =   TRUE;
        scoreMore.text                  =   @"Come on in to enjoy anytime.";
        rewardLocked.text               =   @"Your reward is ready to be enjoyed.";
        self.pointsNeededLabel.text     =   @"Ready to enjoy";
        self.coinnImageView.highlighted =   TRUE;
        eButton.selected                =   TRUE;
    }else {
        //lock
        unLockedView.hidden             =   TRUE;
        lockedView.hidden               =   FALSE;
        rewardLocked.text               =   @"Your reward is still locked.";
        scoreMore.text                  =   @"Score some more to unlock it.";
        self.coinnImageView.highlighted =   FALSE;
    }
    
    //spend until
    [self updateSpendUntilLabel];
    
    NSMutableString* str        =   [[NSMutableString alloc] init];
    float remaining_money       = (([rewardObject.neededAmount floatValue] - [getAcc.amount floatValue]) / [rewardObject.spendExchangeRule floatValue]);
    [str appendFormat:@"Spend %@%0.0lf more to unlock this reward", self.rewardObject.rewardCurrency, remaining_money];
    
    if ([self.rewardObject.spendUntil length] > 0) { 
        NSDateFormatter *df     =   [[NSDateFormatter alloc] init];
        NSDate *getDate         =   [[NSDate alloc] init];
        [df setDateFormat:@"yyyy-MM-dd"];
        getDate                 =   [df dateFromString:self.rewardObject.spendUntil];
        
        NSTimeInterval secondsBetween = [getDate timeIntervalSinceDate:[NSDate date]];
        
        int numberOfDays = secondsBetween / 86400;
        
        if (numberOfDays > 0) [str appendFormat:@"\nOffer expires in %d days.", numberOfDays];
        [df release];
    }
    self.spendMoreLabel.text   =   str;
    [str release]; 
}


- (void)dealloc {
    [lockedView release];
    [lockedScrollView release];
    [heading2Label release];
    [spendMoreLabel release];
    [unLockedView release];
    [placeObject release];
    [rewardObject release];
    [pointsNeededLabel release];
    [spendUntilLabel release];
    [coinnImageView release];
    [eButton release];
    [super dealloc];
}
- (IBAction)turnOver:(id)sender {
    
    if ([lockedView isHidden]) {
        // show locked
        [UIView transitionWithView:self duration:0.5 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
            self.lockedView.hidden              =   FALSE;
            self.unLockedView.hidden            =   TRUE;
            [self updateSpendUntilLabel];
        }completion:^(BOOL finished){
        }];
    }else{
        //show unlocked
        [UIView transitionWithView:self duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            self.lockedView.hidden              =   TRUE;
            self.unLockedView.hidden            =   FALSE;
            self.spendUntilLabel.text           =   [NSString stringWithFormat:@"@%@",self.placeObject.name];
        }completion:^(BOOL finished){
        }];
        
    }
}
@end
