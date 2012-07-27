//
//  PaymentSuccessViewController.m
//  Cashbury
//
//  Created by jayanth S on 4/18/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#import "PaymentSuccessViewController.h"
#import "CWRingUpViewController.h"
#import "KZApplication.h"
#import "PlayViewController.h"
#import "PinEntryViewController.h"

@interface PaymentSuccessViewController ()

@end

@implementation PaymentSuccessViewController
@synthesize tag;
@synthesize spendMoreLabel;
@synthesize tounlockLabel;
@synthesize crownButton;
@synthesize earnedSpinLabel;
@synthesize spinWinAwesomeLabel;
@synthesize giveUrFriendsLabel;
@synthesize paidImageView;
@synthesize sayToCashierLabel;
@synthesize spin2WinButton;
@synthesize doneButton;
@synthesize billLabel;
@synthesize tipsLabel;
@synthesize totalAmtLabel;
@synthesize bottonBar;
@synthesize successScrollView;
@synthesize facebookButton;
@synthesize tweetButton;
@synthesize refundButton;
@synthesize shopnameLabel;
@synthesize addressLabel;
@synthesize timeStamplabel;
@synthesize receiptNumberLabel;
@synthesize authorizeView;
@synthesize youSavedLabel;
@synthesize paidView;
@synthesize receiptObject;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)animatePaidCard{
    
    self.successScrollView.hidden   =   FALSE;
    self.doneButton.hidden          =   FALSE;
    self.authorizeView.hidden       =   TRUE;
    self.paidView.frame    =   CGRectMake(self.paidView.frame.origin.x, 480.0, self.paidView.frame.size.width, self.paidView.frame.size.height);
    
    [UIView animateWithDuration:1.0f animations:^{
        self.paidView.hidden   =   FALSE;
        self.paidView.frame    =   CGRectMake(self.paidView.frame.origin.x, 10.0, self.paidView.frame.size.width, self.paidView.frame.size.height);
        
    }completion:^(BOOL finished){
        self.bottonBar.highlighted  =   TRUE;
        [self.successScrollView setContentOffset:CGPointMake(self.successScrollView.frame.origin.x, 65) animated:YES];
    }];
}

-(void)makeBorderForButton:(UIButton*)roundButton{
    roundButton.layer.borderWidth   =   1.0;
    roundButton.layer.borderColor   =   [UIColor colorWithRed:(CGFloat)204/255.0 green:(CGFloat)204/255.0 blue:(CGFloat)204/255.0 alpha:1.0].CGColor;
    roundButton.layer.cornerRadius  =   4.0;
}

-(void)setTimeStamp{
    NSDate *date                =   [NSDate date];
    NSDateFormatter *formatter  =   [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"mm:ss aa"];
    NSString *time              =   [formatter stringFromDate:date];
    
    [formatter setDateFormat:@"MMMM.dd.yyyy"];
    NSString *dateString        =   [formatter stringFromDate:date];
    self.timeStamplabel.text    =   [NSString stringWithFormat:@"%@ on %@",time,dateString];
    [formatter release];
    
}

-(void)setAllValues{
    

    self.shopnameLabel.text     =   receiptObject.place.name;
    
    self.billLabel.text         =   [NSString stringWithFormat:@"Bill total: $%@",self.receiptObject.billTotal];
    self.tipsLabel.text         =   [NSString stringWithFormat:@"Tips (%@): $%@", self.receiptObject.tipPercentage,self.receiptObject.tipAmt];
    float totalAmount           =   [self.receiptObject.billTotal floatValue] + [self.receiptObject.tipAmt floatValue];
    self.totalAmtLabel.text     =   [NSString stringWithFormat:@"Total Spend:$%.2f",totalAmount];
  
    
    self.addressLabel.text      =   self.receiptObject.place.address;
    [self setTimeStamp];
    [self makeBorderForButton:doneButton];
    [self makeBorderForButton:facebookButton];
    [self makeBorderForButton:tweetButton];
    [self makeBorderForButton:refundButton];
    
    if (self.tag == TAG_REFUND_VIEW) {
        self.successScrollView.scrollEnabled    =   FALSE;
        ((UIImageView*)[self.successScrollView viewWithTag:110]).hidden = TRUE;
        crownButton.hidden                      =   TRUE;
        earnedSpinLabel.hidden                  =   TRUE;
        spin2WinButton.hidden                   =   TRUE;
        spinWinAwesomeLabel.hidden              =   TRUE;
        tounlockLabel.hidden                    =   TRUE;
        spendMoreLabel.hidden                   =   TRUE;
        giveUrFriendsLabel.hidden               =   TRUE; 
        [self.successScrollView setContentOffset:CGPointMake(self.successScrollView.frame.origin.x, 65) animated:FALSE];
        self.totalAmtLabel.text                 =   [NSString stringWithFormat:@"Total: $%.2f",totalAmount];
        self.paidImageView.highlighted          =   TRUE;
        self.paidImageView.frame                =   CGRectMake(self.paidImageView.frame.origin.x, self.paidImageView.frame.origin.y - 10.0, self.paidImageView.frame.size.width, self.paidImageView.frame.size.height);
        youSavedLabel.frame                     =   CGRectMake(youSavedLabel.frame.origin.x, youSavedLabel.frame.origin.y, youSavedLabel.frame.size.width, 35.0);
        youSavedLabel.numberOfLines             =   0;
        youSavedLabel.text                      =   @"$9.00 and $2.00 credits refunded on 9:30 AM July 25 2012";
        self.sayToCashierLabel.text             =   @"'Refunding with Cashbury'";
        
    }
    
}

-(void)animateAuthorizingDown{
    
    [UIView animateWithDuration:0.6f animations:^{
        self.paidView.frame    =   CGRectMake(self.paidView.frame.origin.x, 480.0, self.paidView.frame.size.width, self.paidView.frame.size.height);
        
    }completion:^(BOOL f){
        [self animatePaidCard];
    }];
    
}
-(void)animateAuthorizing{
    
    self.paidView.frame    =   CGRectMake(self.paidView.frame.origin.x, 480.0, self.paidView.frame.size.width, self.paidView.frame.size.height);
    
    [UIView animateWithDuration:0.6f animations:^{
        self.paidView.hidden   =   FALSE;
        self.paidView.frame    =   CGRectMake(self.paidView.frame.origin.x, 265.0, self.paidView.frame.size.width, self.paidView.frame.size.height);
        
    }completion:^(BOOL f){
        [self performSelector:@selector(animateAuthorizingDown) withObject:nil afterDelay:3.0f];
    }];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor       =   [UIColor blackColor];
    self.paidView.hidden            =   TRUE;
    self.successScrollView.hidden   =   TRUE;
    self.doneButton.hidden          =   TRUE;
    self.successScrollView.delegate =   self;
    [self.successScrollView setContentSize:CGSizeMake(300.0, 790.0)];
    [self setAllValues];
    
    [self performSelector:@selector(animateAuthorizing) withObject:nil afterDelay:0.4f];
    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark ScrollView




- (void)viewDidUnload
{
    [self setBillLabel:nil];
    [self setTipsLabel:nil];
    [self setTotalAmtLabel:nil];
    [self setPaidView:nil];
    [self setBottonBar:nil];
    [self setSuccessScrollView:nil];
    [self setDoneButton:nil];
    [self setFacebookButton:nil];
    [self setTweetButton:nil];
    [self setRefundButton:nil];
    [self setShopnameLabel:nil];
    [self setAddressLabel:nil];
    [self setTimeStamplabel:nil];
    [self setReceiptNumberLabel:nil];
    [self setAuthorizeView:nil];
    [self setSpendMoreLabel:nil];
    [self setTounlockLabel:nil];
    [self setSpin2WinButton:nil];
    [self setCrownButton:nil];
    [self setEarnedSpinLabel:nil];
    [self setSpinWinAwesomeLabel:nil];
    [self setGiveUrFriendsLabel:nil];
    [self setPaidImageView:nil];
    [self setYouSavedLabel:nil];
    [self setSayToCashierLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {

    [billLabel release];
    [tipsLabel release];
    [totalAmtLabel release];
    [paidView release];
    [bottonBar release];
    [successScrollView release];
    [doneButton release];
    [facebookButton release];
    [tweetButton release];
    [refundButton release];
    [receiptObject release];
    [shopnameLabel release];
    [addressLabel release];
    [timeStamplabel release];
    [receiptNumberLabel release];
    [authorizeView release];
    [spendMoreLabel release];
    [tounlockLabel release];
    [spin2WinButton release];
    [crownButton release];
    [earnedSpinLabel release];
    [spinWinAwesomeLabel release];
    [giveUrFriendsLabel release];
    [paidImageView release];
    [youSavedLabel release];
    [sayToCashierLabel release];
    [super dealloc];
}
- (IBAction)goBack:(id)sender {
    
    UIView *_v = self.view;
    
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    _v.transform = CGAffineTransformMakeScale(1, 1);
    _v.alpha = 1;
    
    BOOL _isAnimated = (0.35 > 0);
    
    if (!IS_IOS_5_OR_NEWER)
    {
        [self viewWillDisappear:_isAnimated];
    }
    
    [UIView animateWithDuration:0.35f animations:^{
        CGAffineTransform transformBig = CGAffineTransformMakeScale(0.1, 0.1);
        transformBig = CGAffineTransformTranslate(transformBig, 0, 0);	
        _v.transform = transformBig;
        
        _v.alpha = 0;
        
    }completion:^(BOOL finished){
        if (!IS_IOS_5_OR_NEWER)
        {
            [self viewDidDisappear:_isAnimated];
        }
        
        [_v removeFromSuperview];
        
    }];
    
}

- (IBAction)doneClicked:(id)sender {
}

- (IBAction)spinToWin:(id)sender {
    PlayViewController *playController  =   [[PlayViewController alloc]init];
    playController.tag                  =   FROM_BILLVIEW;
    [self magnifyViewController:playController duration:0.35f];
}

- (IBAction)refundClicked:(id)sender {
    
    PinEntryViewController *entryController =   [[PinEntryViewController alloc]init];
    entryController.receiptObj              =   receiptObject;
    entryController.tag                     =   TAG_REFUND_VIEW;
    [self presentModalViewController:entryController animated:TRUE];
    [entryController release];
}
@end
