//
//  FreeReward.m
//  Cashbury
//
//  Created by Mrithula Ancy on 7/5/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#import "FreeReward.h"
#import "RewardStarView.h"
#import "TBXML.h"

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
@synthesize njoyButton;
@synthesize placeObject,rewardObject,freeDelegate;

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
        njoyButton.userInteractionEnabled   =   TRUE;
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
    [njoyButton release];
    [freeDelegate release];
    [super dealloc];
}

- (void)redeem_reward {
	NSMutableDictionary *_headers = [[NSMutableDictionary alloc] init];
	[_headers setValue:@"application/xml" forKey:@"Accept"];
	[[[KZURLRequest alloc] initRequestWithString:
           [NSString stringWithFormat:@"%@/users/rewards/%d/claim.xml?auth_token=%@", 
            API_URL, self.rewardObject.rewardID, [KZUserInfo shared].auth_token] 
                                            andParams:nil delegate:self headers:_headers andLoadingMessage:@"Loading..."] autorelease];
	[_headers release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self redeem_reward];
    }
}
- (IBAction)tapToEnjoyButtonClicked:(id)sender {
    
    
    UIAlertView *_alert = [[UIAlertView alloc] initWithTitle:@"Ready to Enjoy?"
                                                     message:@"To enjoy your reward you must flash the grant my reward screen to a staff at the store."
                                                    delegate:self
                                           cancelButtonTitle:@"Cancel"
                                           otherButtonTitles:@"Enjoy Now",nil];
    [_alert show];
    [_alert release];
}


- (void) KZURLRequest:(KZURLRequest *)theRequest didFailWithError:(NSError*)theError {
	UIAlertView *_alert = [[UIAlertView alloc] initWithTitle:@"Sorry"
													 message:@"An error has occured while you were claiming your reward. Please Try again later."
													delegate:nil
										   cancelButtonTitle:@"OK"
										   otherButtonTitles:nil];
	[_alert show];
	[_alert release];
}

/// redeem reward HTTP Callback
- (void) KZURLRequest:(KZURLRequest *)theRequest didSucceedWithData:(NSData*)theData {
	
	NSString *dataString    =   [[NSString alloc] initWithData:theData encoding:NSASCIIStringEncoding];
    NSLog(@"DatString %@",dataString);
    
    TBXML *head             =   [[TBXML alloc]initWithXMLData:theData];
    if (head) {
        TBXMLElement *rootXML   =   head.rootXMLElement;
        if (rootXML) {
            TBXMLElement *redeem    =   [TBXML childElementNamed:@"redeem" parentElement:rootXML];
            if (redeem) {
                NSInteger rewardID  =   [[TBXML textForElement:[TBXML childElementNamed:@"reward-id" parentElement:redeem]] integerValue];
                for (int i = 0; i < [self.placeObject.rewardsArray count]; i ++) {
                    PlaceReward *pReward    =   [placeObject.rewardsArray objectAtIndex:i];
                    
                    if (pReward.rewardID == rewardID) {
                        [freeDelegate showGrantView:pReward];
                        PlaceAccount *getAcc    =   [placeObject.accountsDict objectForKey:[NSString stringWithFormat:@"%d",pReward.campaignID]];
                        getAcc.amount           =   @"0.00";
                        break;
                    }
                } 
            }
        }
    }
    
}

@end
