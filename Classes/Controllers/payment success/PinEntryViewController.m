//
//  PinEntryViewController.m
//  Cashbury
//
//  Created by jayanth S on 4/18/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//
#define CLIENT_PIN_NUMBER   @"1234"
#import "PinEntryViewController.h"
#import "FileSaver.h"
#import "KZUtils.h"
#import "KZUserInfo.h"
#import "KZApplication.h"

@interface PinEntryViewController ()

@end

@implementation PinEntryViewController
@synthesize userImage;
@synthesize pinMesgLabel;
@synthesize firstTickImgView;
@synthesize secTickImgView;
@synthesize thirdTickImgView;
@synthesize fourthTickImgView;
@synthesize billString;
@synthesize billLabel;
@synthesize tipsLabel;
@synthesize totalLabel;
@synthesize tipString;

BOOL isEntryTrue;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)setUserLogoImage{
    self.userImage.contentMode = UIViewContentModeScaleAspectFill;
    self.userImage.layer.masksToBounds = YES;
    self.userImage.layer.cornerRadius = 3.0;
    self.userImage.layer.borderWidth = 1.0;
    self.userImage.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.userImage.cropNorth = YES;
    
    NSString *_imagePath = [FileSaver getFilePathForFilename:@"facebook_user_image"];
    
    if ([KZUtils isStringValid:_imagePath])
    {
        UIImage *_profileImage = [UIImage imageWithContentsOfFile:_imagePath];
        
        self.userImage.image = _profileImage;
    }
    else
    {
        NSURL *_profileURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=normal", [KZUserInfo shared].facebookID]];
        [self.userImage loadImageWithAsyncUrl:_profileURL];
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    isEntryTrue     =   FALSE;
    currentPosition =   0;
    [self setUserLogoImage];
    self.billLabel.text =   [NSString stringWithFormat:@"bill: $%@",billString];
    self.tipsLabel.text =   [NSString stringWithFormat:@"tips: $%@",tipString];
    self.totalLabel.text    =   [NSString stringWithFormat:@"total :$%.2f",[billString floatValue]+[tipString floatValue]];
    
    

    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    
    [self setUserImage:nil];
    [self setPinMesgLabel:nil];
    [self setFirstTickImgView:nil];
    [self setSecTickImgView:nil];
    [self setThirdTickImgView:nil];
    [self setFourthTickImgView:nil];
    [self setBillLabel:nil];
    [self setTipsLabel:nil];
    [self setTotalLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)keyboardAction:(id)sender {
    UIButton *actionButton  =   (UIButton*)sender;
    if (actionButton.tag == 10) {
        // clear one item
    if (isEntryTrue) {// true
      
    }else {
        UIImageView *currentImageView       =   (UIImageView*)[self.view viewWithTag:currentPosition+1];
        currentImageView.hidden             =   TRUE;
        pinMesgLabel.text               =   @"merchant :: enter your pin to confirm the charge";
        pinMesgLabel.textColor          =   [UIColor colorWithRed:(CGFloat)98/255.0 green:(CGFloat)148/255.0 blue:(CGFloat)91/255.0 alpha:1.0];

    }
    }else {
        
        
        int character           =   [CLIENT_PIN_NUMBER characterAtIndex:currentPosition];
        NSString *subStr        =   [NSString stringWithFormat:@"%c",character];
        UIImageView *currentImageView       =   (UIImageView*)[self.view viewWithTag:currentPosition+1];
        currentImageView.hidden             =   FALSE;
        if ([subStr intValue] == actionButton.tag) {
            isEntryTrue                     =   TRUE;
            currentImageView.highlighted    =   FALSE;
            currentPosition                 =   currentPosition+1;
            pinMesgLabel.text               =   @"merchant :: enter your pin to confirm the charge";
            pinMesgLabel.textColor          =   [UIColor colorWithRed:(CGFloat)98/255.0 green:(CGFloat)148/255.0 blue:(CGFloat)91/255.0 alpha:1.0];
        }else {
            isEntryTrue                     =   FALSE;
            currentImageView.highlighted    =   TRUE;
            pinMesgLabel.text               =   @"pin does not match, try again";
            pinMesgLabel.textColor          =   [UIColor colorWithRed:(CGFloat)178/255.0 green:(CGFloat)114/255.0 blue:(CGFloat)115/255.0 alpha:1.0];
            
        }
        if (currentPosition >= 4) {
            // go to paid cash
            
            PaymentSuccessViewController *successController =   [[PaymentSuccessViewController alloc]init];
            successController.billAmount                    =   [self.billString stringByReplacingOccurrencesOfString:@"$" withString:@""];
            successController.tipsAmount                    =   [self.tipString stringByReplacingOccurrencesOfString:@"$" withString:@""];
            [self presentModalViewController:successController animated:TRUE];
            [successController release];

        }
    }
}

- (IBAction)goBack:(id)sender {
    [self dismissModalViewControllerAnimated:TRUE];
}

- (IBAction)clearItems:(id)sender {
    pinMesgLabel.text               =   @"merchant :: enter your pin to confirm the charge";
    pinMesgLabel.textColor          =   [UIColor colorWithRed:(CGFloat)98/255.0 green:(CGFloat)148/255.0 blue:(CGFloat)91/255.0 alpha:1.0];
    firstTickImgView.hidden =   TRUE;
    secTickImgView.hidden   =   TRUE;
    thirdTickImgView.hidden =   TRUE;
    fourthTickImgView.hidden    =   TRUE;
    currentPosition =   0;
}
- (void)dealloc {
    [userImage release];
    [pinMesgLabel release];
    [firstTickImgView release];
    [secTickImgView release];
    [thirdTickImgView release];
    [fourthTickImgView release];
    [tipString release];
    [billString release];
    if (pinEntryString) {
        [pinEntryString release];
        pinEntryString  =   nil;
    }
    [billLabel release];
    [tipsLabel release];
    [totalLabel release];
    [super dealloc];
}
@end
