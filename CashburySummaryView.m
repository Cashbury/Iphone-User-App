//
//  CashburySummaryView.m
//  Cashbury
//
//  Created by Mrithula Ancy on 7/6/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#import "CashburySummaryView.h"
#import "SummaryStarsView.h"

@implementation CashburySummaryView
@synthesize cashBackLabel;
@synthesize downLabel;
@synthesize enjoyButton;
@synthesize startAmtLabel;
@synthesize slider;
@synthesize endAmtLabel;
@synthesize cashBackView;
@synthesize starView;
@synthesize placeView;
@synthesize reward;
@synthesize starScrollView;
@synthesize type;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setStarViewToScroll{
    PlaceAccount *getAcc            =   [placeView.accountsDict objectForKey:[NSString stringWithFormat:@"%d",self.reward.campaignID]];
    NSInteger numSpend              =   [getAcc.amount intValue];
    NSInteger neededAmount          =   [self.reward.neededAmount intValue];
    NSInteger tCount ;
    if ([self.reward.neededAmount intValue]%6 == 0) {
        tCount                      =   [self.reward.neededAmount intValue]/6;
    }else {
        tCount                      =   ([self.reward.neededAmount intValue]/6) + 1;
    }
    CGFloat xValue                  =   0;
    
    for (int i = 0; i < tCount; i ++) {
        NSArray* nibViews               =   [[NSBundle mainBundle] loadNibNamed:@"SummaryStarsView" owner:self options:nil];
        SummaryStarsView *sumView       =   [nibViews objectAtIndex:0];
        sumView.frame                   =   CGRectMake(xValue, 0, 310, 36);
        for (int j =0; j < 6; j ++) {
            if (j + 1 <= neededAmount) {
                UIImageView *imgView        =   (UIImageView*)[sumView viewWithTag:j + 10];
                imgView.hidden              =   FALSE;
                if (j +1 <= numSpend) {
                    imgView.highlighted     =   TRUE;
                } 
                if (j == 5) {
                   UIImageView *arrowView   =   (UIImageView*)[sumView viewWithTag:16]; 
                    arrowView.hidden        =   FALSE;
                    
                }
            }
              
        }
        [self.starScrollView addSubview:sumView];
        xValue  =   xValue + 310;
        numSpend = numSpend-6;  
        neededAmount    =   neededAmount - 6;
    }
     [self.starScrollView setContentSize:CGSizeMake(tCount * 310, 36.0)];
    
    
    /*
    CGFloat xValue  =   15;
    for (int i = 0; i < [self.reward.neededAmount intValue]; i++) {
        UIImageView *starImge   =   [[UIImageView alloc] initWithFrame:CGRectMake(xValue, 1, 34.0, 34.0)];
        starImge.image          =   [UIImage imageNamed:@"roundstar"];
        starImge.highlightedImage   =   [UIImage imageNamed:@"roundstar_yellow"];
        
        if (i < numSpend) {
            starImge.highlighted    =   TRUE;
        }
        
        [self.starScrollView addSubview:starImge];
        [starImge release];
        xValue                  =   xValue + 34 + 9;
        
        
        
    }
    [self.starScrollView setContentSize:CGSizeMake(xValue, 36.0)];*/
    
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    PlaceAccount *getAcc        =   [placeView.accountsDict objectForKey:[NSString stringWithFormat:@"%d",self.reward.campaignID]];
    // Drawing code
    switch (type) {
        case CASHBURY_SUMMARY_CASHBACK:
            self.starView.hidden        =   TRUE;
            
            float remaining_money       = (([reward.neededAmount floatValue] - [getAcc.amount floatValue]) / [reward.spendExchangeRule floatValue]);
            downLabel.text              =   [NSString stringWithFormat:@"Spend %@%0.0lf more to unlock this reward", self.reward.rewardCurrency, remaining_money];
            
            break;
        case CASHBURY_SUMMARY_STARVIEW:
            [self setStarViewToScroll];
            self.cashBackView.hidden    =   TRUE;
            self.starView.hidden        =   FALSE;
            downLabel.text              =   [NSString stringWithFormat:@"Buy %d more to enjoy a free drink on this house.",[self.reward.neededAmount intValue]- [getAcc.amount intValue]];
            break;
        case CASHBURY_SUMMARY_TAPTOENJOY:
            self.starView.hidden        =   TRUE;
            self.cashBackView.hidden    =   TRUE;
            self.enjoyButton.hidden     =   FALSE;
            downLabel.text              =   @"Thank you for your loyalty!";
            break;
            
        default:
            break;
    }
    self.cashBackLabel.text             =   self.reward.rewardName;
    [self.slider setThumbImage:[[[UIImage alloc] init] autorelease] forState:UIControlStateNormal];
    UIImage *stetchLeftTrack			=		[[UIImage imageNamed:@"carryterm_slider_small.png"]stretchableImageWithLeftCapWidth:5.0 topCapHeight:0.0];
    [self.slider setMinimumTrackImage:stetchLeftTrack forState:UIControlStateNormal];

    
    
    
}


- (void)dealloc {
    [cashBackLabel release];
    [downLabel release];
    [enjoyButton release];
    [startAmtLabel release];
    [slider release];
    [endAmtLabel release];
    [cashBackView release];
    [starView release];
    [placeView release];
    [reward release];
    [starScrollView release];
    [super dealloc];
}
- (IBAction)tapToEnjoyButton:(id)sender {
}
@end
