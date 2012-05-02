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
@synthesize timeDateLabel;
@synthesize billLabel;
@synthesize tipsLabel;
@synthesize totalAmtLabel;
@synthesize bottonBar;
@synthesize successScrollView;
@synthesize userLogo;
@synthesize billAmount;
@synthesize tipsAmount;
@synthesize paidView;

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
    }];
}

-(void)setAllValues{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm a"];
    NSString *time              =   [formatter stringFromDate:[NSDate date]];
    
    [formatter setDateFormat:@"MM.dd.yy"];
    NSString *date              =   [formatter stringFromDate:[NSDate date]];
    [formatter release];
    
    self.timeDateLabel.text     =   [NSString stringWithFormat:@"%@ - %@",time,date];
    self.userLogo.layer.cornerRadius    =   2.0;
    self.userLogo.layer.borderWidth     =   1.0;
    self.userLogo.layer.borderColor     =   [UIColor whiteColor].CGColor;
    
    
    
    self.billLabel.text  =   [NSString stringWithFormat:@"bill total: $%@",self.billAmount];
    self.tipsLabel.text  =   [NSString stringWithFormat:@"tips: $%@", self.tipsAmount];
    float totalAmount   =   [self.billAmount floatValue] + [self.tipsAmount floatValue];
    self.totalAmtLabel.text =   [NSString stringWithFormat:@"$%.2f",totalAmount];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor   =   [UIColor blackColor];
    self.paidView.hidden   =   TRUE;
    [self.successScrollView setContentSize:CGSizeMake(300.0, 400.0)];
    [self setAllValues];
    
    
    [self performSelector:@selector(animatePaidCard) withObject:nil afterDelay:0.4f];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setTimeDateLabel:nil];
    [self setBillLabel:nil];
    [self setTipsLabel:nil];
    [self setTotalAmtLabel:nil];
    [self setPaidView:nil];
    [self setBottonBar:nil];
    [self setSuccessScrollView:nil];
    [self setUserLogo:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [billAmount release];
    [tipsAmount release];
    [timeDateLabel release];
    [billLabel release];
    [tipsLabel release];
    [totalAmtLabel release];
    [paidView release];
    [bottonBar release];
    [successScrollView release];
    [userLogo release];
    [super dealloc];
}
- (IBAction)goBack:(id)sender {
    

    
    UIViewController *presentingController  =   self.presentingViewController;
    if ([presentingController isKindOfClass:[PinEntryViewController class]]) {
        //pincode
        UIViewController *paymentSucces     =   presentingController.presentingViewController;
        [(PayementEntryViewController*)paymentSucces diminishViewController:presentingController duration:0.0f];
       // [presentingController dismissModalViewControllerAnimated:TRUE];
        
        UIView *_v = self.view;
        
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        _v.transform = CGAffineTransformMakeScale(1, 1);
        _v.alpha = 1;
        
        BOOL _isAnimated = (0.35 > 0);
        
        if (!IS_IOS_5_OR_NEWER)
        {
            [self viewWillDisappear:_isAnimated];
        }
        
        [UIView animateWithDuration:0.35f
                         animations:^{
                             CGAffineTransform transformBig = CGAffineTransformMakeScale(0.1, 0.1);
                             transformBig = CGAffineTransformTranslate(transformBig, 0, 0);	
                             _v.transform = transformBig;
                             
                             _v.alpha = 0;
                         }
                         completion:^(BOOL finished){
                             if (!IS_IOS_5_OR_NEWER)
                             {
                                 [self viewDidDisappear:_isAnimated];
                             }
                             
                             [_v removeFromSuperview];
                         }];
        
        
    }else if ([presentingController isKindOfClass:[PayementEntryViewController class]]) {//payment entry
        [(PayementEntryViewController*)presentingController diminishViewController:presentingController duration:0.0f];
        UIView *_v = self.view;
        
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        _v.transform = CGAffineTransformMakeScale(1, 1);
        _v.alpha = 1;
        
        BOOL _isAnimated = (0.35 > 0);
        
        if (!IS_IOS_5_OR_NEWER)
        {
            [self viewWillDisappear:_isAnimated];
        }
        
        [UIView animateWithDuration:0.35f
                         animations:^{
                             CGAffineTransform transformBig = CGAffineTransformMakeScale(0.1, 0.1);
                             transformBig = CGAffineTransformTranslate(transformBig, 0, 0);	
                             _v.transform = transformBig;
                             
                             _v.alpha = 0;
                         }
                         completion:^(BOOL finished){
                             if (!IS_IOS_5_OR_NEWER)
                             {
                                 [self viewDidDisappear:_isAnimated];
                             }
                             
                             [_v removeFromSuperview];
                         }];
       
        
  
    }

    //[self dismissModalViewControllerAnimated:TRUE]; 
    
    
}

- (IBAction)doneClicked:(id)sender {
}

- (IBAction)spinToWin:(id)sender {
    PlayViewController *playController  =   [[PlayViewController alloc]init];
    playController.tag                  =   FROM_BILLVIEW;
    [self magnifyViewController:playController duration:0.35f];
}
@end
