//
//  PayementEntryViewController.m
//  Cashbury
//
//  Created by jayanth S on 4/25/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#import "PayementEntryViewController.h"
#import "PinEntryViewController.h"
#import "PaymentSuccessViewController.h"
#import "KZUtils.h"
#import "FileSaver.h"
#import "KZUserInfo.h"

@interface PayementEntryViewController ()

@end

@implementation PayementEntryViewController
@synthesize toastCafeBg;
@synthesize userLogo;
@synthesize enterBillLbl;
@synthesize amountlabel;
@synthesize keyBoardView;
@synthesize tipsLabel;
@synthesize billsTipsLabel;
@synthesize activityIndicator;
@synthesize shopNameLabel;
@synthesize tipsSelectedArrow;
@synthesize payButton;
@synthesize scrollView;
@synthesize cancelButton;
@synthesize addTipButton;

CGFloat selectedX;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)setUserLogoImage{
    self.userLogo.contentMode = UIViewContentModeScaleAspectFill;
    self.userLogo.layer.masksToBounds = YES;
    self.userLogo.layer.cornerRadius = 3.0;
    self.userLogo.layer.borderWidth = 1.0;
    self.userLogo.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.userLogo.cropNorth = YES;
    
    NSString *_imagePath = [FileSaver getFilePathForFilename:@"facebook_user_image"];
    
    if ([KZUtils isStringValid:_imagePath])
    {
        UIImage *_profileImage = [UIImage imageWithContentsOfFile:_imagePath];
        
        self.userLogo.image = _profileImage;
    }
    else
    {
        NSURL *_profileURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=normal", [KZUserInfo shared].facebookID]];
        [self.userLogo loadImageWithAsyncUrl:_profileURL];
        
    }
}

-(void)showshopBg{
    self.toastCafeBg.hidden     =   FALSE;
    [self.activityIndicator stopAnimating];
    self.shopNameLabel.hidden   =   TRUE;
}

#pragma mark ScrollViewDelegates
- (void)scrollViewDidEndDragging:(UIScrollView *)mscrollView willDecelerate:(BOOL)decelerate{
    CGFloat scrollX     =   mscrollView.contentOffset.x;
    selectedX           =   0;
    if (scrollX <= 40) {// no tip
        selectedX       =   0;
        
    }else if(scrollX > 40 && scrollX <= 120){ // 5per
        selectedX       =   80;
        
    }else if(scrollX > 120 && scrollX <= 200){//10per
        selectedX       =   160;
        
    }else if(scrollX > 200 && scrollX <= 280){//15 per
        selectedX       =   240;
        
    }else if(scrollX > 280 && scrollX <= 360){// 20 per
        selectedX       =   320;
        
    }
    else if(scrollX > 360 && scrollX <= 440){// 25 per
        selectedX       =   400;
        
    }
    else if(scrollX > 440 && scrollX <= 520){// 30 per
        selectedX       =   480;
        
    }
    
    [UIView animateWithDuration:0.5f animations:^{
        [mscrollView setContentOffset:CGPointMake(selectedX, mscrollView.contentOffset.y)];
    }completion:^(BOOL finished){
        [self tipsAction:selectedX];
    }];
    
    
   // NSLog(@"x %f",scrollX);

}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)mscrollView{
  
    CGFloat scrollX     =   mscrollView.contentOffset.x;
    selectedX           =   0;
    if (scrollX <= 40) {// no tip
        selectedX       =   0;
        
    }else if(scrollX > 40 && scrollX <= 120){ // 5per
        selectedX       =   80;
        
    }else if(scrollX > 120 && scrollX <= 200){//10per
        selectedX       =   160;
        
    }else if(scrollX > 200 && scrollX <= 280){//15 per
        selectedX       =   240;
        
    }else if(scrollX > 280 && scrollX <= 360){// 20 per
        selectedX       =   320;
        
    }
    else if(scrollX > 360 && scrollX <= 440){// 25 per
        selectedX       =   400;
        
    }
    else if(scrollX > 440 && scrollX <= 520){// 30 per
        selectedX       =   480;
        
    }
    
    [UIView animateWithDuration:0.5f animations:^{
        [mscrollView setContentOffset:CGPointMake(selectedX, mscrollView.contentOffset.y)];
    }completion:^(BOOL finished){
        [self tipsAction:selectedX];
    }];

}

-(void)setAllTipViews:(NSInteger)viewtag{
    
    for (int i = 1; i <= 7; i++) {
        UIView *nowView =   (UIView*)[self.scrollView viewWithTag:i];
        UILabel *numlabel   =   (UILabel*)[nowView viewWithTag:10];
        UILabel *perlabel  =   (UILabel*)[nowView viewWithTag:20];
       
        if (i == viewtag) {
            [numlabel setTextColor:[UIColor whiteColor]];
            [numlabel setShadowOffset:CGSizeMake(2.0, 2.0)];
            [numlabel setShadowColor:[UIColor colorWithRed:(CGFloat)124/255 green:(CGFloat)124/255 blue:(CGFloat)124/255 alpha:1.0]];
            if (perlabel) {
                [perlabel setTextColor:[UIColor whiteColor]];
                [perlabel setShadowOffset:CGSizeMake(2.0, 2.0)];
                [perlabel setShadowColor:[UIColor colorWithRed:(CGFloat)124/255 green:(CGFloat)124/255 blue:(CGFloat)124/255 alpha:1.0]];
            }
            
        }else {
            [numlabel setTextColor:[UIColor colorWithRed:(CGFloat)105/255 green:(CGFloat)104/255 blue:(CGFloat)104/255 alpha:1.0]];
            [numlabel setShadowOffset:CGSizeMake(0.0, 0.0)];
            if (perlabel) {
                [perlabel setTextColor:[UIColor colorWithRed:(CGFloat)105/255 green:(CGFloat)104/255 blue:(CGFloat)104/255 alpha:1.0]];
                [perlabel setShadowOffset:CGSizeMake(0.0, 0.0)];
            }
            
             
        }
    }
}

-(void)animateAddTip{
    //self.addTipButton.frame =   CGRectMake(330.0, self.addTipButton.frame.origin.y, self.addTipButton.frame.size.width, self.addTipButton.frame.size.height);
    [UIView animateWithDuration:0.5f animations:^{
        
        self.addTipButton.hidden    =   FALSE;
        self.addTipButton.frame =   CGRectMake(240.0, self.addTipButton.frame.origin.y, self.addTipButton.frame.size.width, self.addTipButton.frame.size.height);

                
    }completion:^(BOOL finished){
        
        [UIView animateWithDuration:0.1f animations:^{
             self.addTipButton.frame =   CGRectMake(246.0, self.addTipButton.frame.origin.y, self.addTipButton.frame.size.width, self.addTipButton.frame.size.height);
        }completion:^(BOOL finished){
            [UIView animateWithDuration:0.1f animations:^{
                self.addTipButton.frame =   CGRectMake(242.0, self.addTipButton.frame.origin.y, self.addTipButton.frame.size.width, self.addTipButton.frame.size.height);
            }completion:^(BOOL finished){
                [UIView animateWithDuration:0.1f animations:^{
                    self.addTipButton.frame =   CGRectMake(245.0, self.addTipButton.frame.origin.y, self.addTipButton.frame.size.width, self.addTipButton.frame.size.height);
                }completion:^(BOOL finished){
                    [UIView animateWithDuration:0.05f animations:^{
                        self.addTipButton.frame =   CGRectMake(243.0, self.addTipButton.frame.origin.y, self.addTipButton.frame.size.width, self.addTipButton.frame.size.height);
                    }completion:^(BOOL finished){
                        [UIView animateWithDuration:0.01f animations:^{
                            self.addTipButton.frame =   CGRectMake(244.0, self.addTipButton.frame.origin.y, self.addTipButton.frame.size.width, self.addTipButton.frame.size.height);
                        }completion:^(BOOL finished){
                            
                        }];
                    }];

                }];
            }];
        }];
        
    }];
}

-(void)animateAndHideAddTip{
    [UIView animateWithDuration:0.5f animations:^{
        self.addTipButton.frame =   CGRectMake(330.0, self.addTipButton.frame.origin.y, self.addTipButton.frame.size.width, self.addTipButton.frame.size.height); 
    }];
    
}


-(void)setTipsScrollView{

    [self.scrollView setContentSize:CGSizeMake(800, 87)];
    [self.scrollView setDelegate:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    amtCurrency     =   [[NSMutableString alloc]init];
    amountString    =   [[NSMutableString alloc]init];
    tipsString      =   @"0.00";
    [tipsString retain];
    [self setUserLogoImage];
    [self setTipsScrollView];
    [self.activityIndicator startAnimating];
    [self performSelector:@selector(showshopBg) withObject:nil afterDelay:2.0f];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setToastCafeBg:nil];
    [self setUserLogo:nil];
    [self setEnterBillLbl:nil];
    [self setAmountlabel:nil];
    [self setKeyBoardView:nil];
    [self setTipsLabel:nil];
    [self setBillsTipsLabel:nil];
    [self setActivityIndicator:nil];
    [self setShopNameLabel:nil];
    [self setTipsSelectedArrow:nil];
    [self setPayButton:nil];
    [self setScrollView:nil];
    [self setCancelButton:nil];
    [self setAddTipButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [toastCafeBg release];
    [userLogo release];
    [enterBillLbl release];
    [amountlabel release];
    [keyBoardView release];
    [tipsLabel release];
    [billsTipsLabel release];
    [activityIndicator release];
    [shopNameLabel release];
    [tipsSelectedArrow release];
    [payButton release];
    [amtCurrency release];
    [amountString release];
    [scrollView release];
    [cancelButton release];
    [addTipButton release];
    [super dealloc];
}

#pragma mark - Keyboard functions
- (void) keyTouched:(NSString*)string {
	if ([string isEqual:@""]) {
		if (amountString == nil || [amountString isEqual:@""]) return;
		NSRange r = NSMakeRange([amountString length]-1, 1);
        if (r.location == 0) {
            self.payButton.userInteractionEnabled   =   FALSE;
            self.payButton.selected                 =   FALSE;
        }
		[amountString deleteCharactersInRange:r];
	} else {
		[amountString appendString:string];
	}
    
	if (amtCurrency == nil) {
		amtCurrency = [[NSMutableString alloc] init];
	} else {
		[amtCurrency deleteCharactersInRange:NSMakeRange(0, [amtCurrency length])];
	}
	
	
	if ([amountString length] < 3) {
		[amtCurrency appendString:@"$0."];	//$
		for (NSUInteger i = [amountString length]; i < 2; i++) {
			[amtCurrency appendString:@"0"];
		}
		[amtCurrency appendString:amountString];
		
	} else {
		NSRange starting = NSMakeRange(0, [amountString length]-2);
        if (starting.length == 2) {// first unit place
            if (self.addTipButton.frame.origin.x > 320) {
                [self animateAddTip];
            }
        }else if(starting.length < 2){
            if (self.addTipButton.frame.origin.x < 320) {
                [self animateAndHideAddTip];
            } 
        }
		NSRange last_2 = NSMakeRange([amountString length]-2, 2);
		[amtCurrency appendString:@"$"];
		[amtCurrency appendString:[amountString substringWithRange:starting]];
		[amtCurrency appendString:@"."];
		[amtCurrency appendString:[amountString substringWithRange:last_2]];
	}
	self.amountlabel.text = amtCurrency;
}
- (IBAction)keyBoardAction:(id)sender {
    if (!self.billsTipsLabel.hidden) {
        return;
    }
    int tag = [((UIButton*)sender) tag];
	if (tag >= 0 && tag <= 9) {
		[self keyTouched:[NSString stringWithFormat:@"%d", tag]];
        if (!self.payButton.userInteractionEnabled) {
            self.payButton.userInteractionEnabled   =   TRUE;
            self.payButton.selected                 =   TRUE;
        }
	} else if (tag == 11) {	// backspace
		[self keyTouched:@""];
	}
}

- (IBAction)clearButton:(id)sender {
    self.payButton.userInteractionEnabled   =   FALSE;
    self.payButton.selected                 =   FALSE;
    [amountString setString:@""];
    if (tipsString != nil) {
        [tipsString release];
        tipsString  =   nil;
    }
    [amtCurrency setString:@"$0.00"];
    tipsString                          =   @"0.00";
    [tipsString retain];
	self.amountlabel.text = @"$0.00";	//$
    if (!self.billsTipsLabel.hidden) {
        self.billsTipsLabel.hidden  =   TRUE;
        addTipButton.selected       =   FALSE;
        addTipButton.hidden         =   FALSE;
    }
    [self animateAndHideAddTip];
}

- (IBAction)exitButton:(id)sender {
    [self diminishViewController:self duration:0.35f];
}

- (IBAction)payButton:(id)sender {
    float amount                =   [[amtCurrency stringByReplacingOccurrencesOfString:@"$" withString:@""] floatValue];
    float tip                   =   [tipsString floatValue];
    
    if ((amount + tip) > 10) {
        PinEntryViewController *entryController =   [[PinEntryViewController alloc]init];
        entryController.billString              =   [amtCurrency stringByReplacingOccurrencesOfString:@"$" withString:@""];
        entryController.tipString               =   tipsString;
        
        [self presentModalViewController:entryController animated:TRUE];
        [entryController release];
    }else {
        //go to 
        
        PaymentSuccessViewController *successController =   [[PaymentSuccessViewController alloc]init];
        successController.billAmount            =   [amtCurrency stringByReplacingOccurrencesOfString:@"$" withString:@""];
        successController.tipsAmount            =   tipsString;
        [self presentModalViewController:successController animated:TRUE];
        [successController release];
    }
}

-(void)dismissEntryController{
    [self diminishViewController:self duration:0.35f];
}

- (IBAction)addTip:(id)sender {
    UIButton *addTip    =   (UIButton*)sender;
    if (addTip.selected) {
        addTip.selected                     =   FALSE;
        self.scrollView.hidden              =   TRUE;
        self.cancelButton.hidden            =   TRUE;
        self.tipsSelectedArrow.hidden       =   TRUE;
        //change bg
        addTip.hidden                       =   TRUE;
        self.tipsLabel.hidden               =   TRUE;
        
        self.billsTipsLabel.hidden          =   FALSE;
        self.billsTipsLabel.text            =   [NSString stringWithFormat:@"bill:%@ tips:$%@",amtCurrency,tipsString];
        float amount                        =   [[amtCurrency stringByReplacingOccurrencesOfString:@"$" withString:@""] floatValue];
        float tip                           =   [tipsString floatValue];
        self.amountlabel.text               =   [NSString stringWithFormat:@"$%.2f",amount+tip];
        self.enterBillLbl.text              =   @"total amount";
        UIImageView *overlay                =   (UIImageView*)[self.keyBoardView viewWithTag:15];
        overlay.hidden                      =   TRUE;
        self.keyBoardView.userInteractionEnabled    =   TRUE;
        if ([amountString length] > 0) {
            self.payButton.userInteractionEnabled   =   TRUE;
            self.payButton.selected                 =   TRUE;
        }
        
        
        
        
    }else {
        self.payButton.userInteractionEnabled   =   FALSE;
        self.payButton.selected                 =   FALSE;
        self.scrollView.hidden          =   FALSE;
        self.cancelButton.hidden        =   FALSE;
        UIImageView *overlay            =   (UIImageView*)[self.keyBoardView viewWithTag:15];
        overlay.hidden                  =   FALSE;
        self.keyBoardView.userInteractionEnabled    =   FALSE;
        [self.scrollView setContentOffset:CGPointMake(0, self.scrollView.contentOffset.y)];
        addTip.selected                 =   TRUE;
        self.tipsSelectedArrow.hidden   =   FALSE;
        self.tipsLabel.hidden   =   FALSE;
        [self.scrollView setContentOffset:CGPointMake(240, scrollView.contentOffset.y)];
        [self tipsAction:240];
        
        
    }
}

- (void)tipsAction:(NSInteger)stopX{
    
    NSString *amount    =   [amtCurrency stringByReplacingOccurrencesOfString:@"$" withString:@""];
    float getAmt        =   [amount floatValue];
    
    float actualTip     =   0;
    self.tipsLabel.hidden   =   FALSE;
    if (tipsString != nil) {
        [tipsString release];
        tipsString  =   nil;
    }
    
    switch (stopX) {
        case 0:// no tips
            self.tipsLabel.text             =   [NSString stringWithString:@"tips: 0% = $0.00"];
            [self setAllTipViews:1];
            break;
        case 80:// 5 tips

            actualTip                       =   (getAmt * 5)/100;
            self.tipsLabel.text             =   [NSString stringWithFormat:@"tips: 5%% = $%.2f",actualTip];
            [self setAllTipViews:2];
            break;
        case 160:// 10 tips
            actualTip                       =   (getAmt * 10)/100;
            self.tipsLabel.text             =   [NSString stringWithFormat:@"tips: 10%% = $%.2f",actualTip];

            [self setAllTipViews:3];
            
            break;
        case 240:// 15 tips
            actualTip                       =   (getAmt * 15)/100;
            self.tipsLabel.text             =   [NSString stringWithFormat:@"tips: 15%% = $%.2f",actualTip];
            [self setAllTipViews:4];
            break;
            
        case 320:// 20 tips
            actualTip                       =   (getAmt * 20)/100;
            self.tipsLabel.text             =   [NSString stringWithFormat:@"tips: 20%% = $%.2f",actualTip];
            [self setAllTipViews:5];
            break;
            
        case 400:// 25 tips
            actualTip                       =   (getAmt * 25)/100;
            self.tipsLabel.text             =   [NSString stringWithFormat:@"tips: 25%% = $%.2f",actualTip];
            [self setAllTipViews:6];
            break;
            
        case 480:// 30 tips
            actualTip                       =   (getAmt * 30)/100;
            self.tipsLabel.text             =   [NSString stringWithFormat:@"tips: 30%% = $%.2f",actualTip];
            [self setAllTipViews:7];
            break;
            
        default:
            break;
    }
    tipsString          =   [NSString stringWithFormat:@"%.2f",actualTip];
    [tipsString retain];
}

- (IBAction)cancelButtonClicked:(id)sender {
    if (tipsString != nil) {
        [tipsString release];
        tipsString  =   nil;
    }
    UIImageView *overlay            =   (UIImageView*)[self.keyBoardView viewWithTag:15];
    overlay.hidden                  =   TRUE;
    self.keyBoardView.userInteractionEnabled    =   TRUE;
    if ([amountString length] > 0) {
        self.payButton.userInteractionEnabled   =   TRUE;
        self.payButton.selected                 =   TRUE;
    }
    tipsString                          =   @"0.00";
    [tipsString retain];
    self.scrollView.hidden              =   TRUE;
    self.cancelButton.hidden            =   TRUE;
    self.tipsSelectedArrow.hidden       =   TRUE;
    self.addTipButton.selected          =   FALSE;
    self.tipsLabel.hidden               =   TRUE;
}
@end
