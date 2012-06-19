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

@interface PaymentSuccessViewController ()

@end

@implementation PaymentSuccessViewController
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
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor       =   [UIColor blackColor];
    self.paidView.hidden            =   TRUE;
    self.successScrollView.delegate =   self;
    [self.successScrollView setContentSize:CGSizeMake(300.0, 790.0)];
    [self setAllValues];
    
    
    [self performSelector:@selector(animatePaidCard) withObject:nil afterDelay:0.4f];
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
@end
