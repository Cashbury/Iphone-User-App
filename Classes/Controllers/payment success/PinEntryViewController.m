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
@synthesize billLabel;
@synthesize totalLabel;
@synthesize passcode1;
@synthesize passcode2;
@synthesize passcode3;
@synthesize passcode4;
@synthesize shopName;

@synthesize receiptObj;

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
    self.userImage.image        =   self.receiptObj.place.icon;
    
    
}

-(void)setRoundForView:(UIView*)getView{
    getView.layer.cornerRadius  =   5.0;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    isEntryTrue     =   FALSE;
    currentPosition =   0;

    pinEntryString      =   [[NSMutableString alloc]init];
    [self setUserLogoImage];
    self.shopName.text      =   self.receiptObj.place.name;
    self.billLabel.text     =   [NSString stringWithFormat:@"Bill:$%@ + Tip:$%@",self.receiptObj.billTotal,self.receiptObj.tipAmt];
    self.totalLabel.text    =   [NSString stringWithFormat:@"Total: $%.2f",[self.receiptObj.billTotal floatValue]+[self.receiptObj.tipAmt floatValue]];
    
    

    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    
    [self setUserImage:nil];
    [self setPinMesgLabel:nil];
    [self setBillLabel:nil];
    [self setTotalLabel:nil];

    [self setPasscode1:nil];
    [self setPasscode2:nil];
    [self setPasscode3:nil];
    [self setPasscode4:nil];
    [self setShopName:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)hidePasscodes{
    passcode1.hidden                =   TRUE;
    passcode2.hidden                =   TRUE;
    passcode3.hidden                =   TRUE;
    passcode4.hidden                =   TRUE;
    pinMesgLabel.text               =   @"Pin does not match, try again";
    pinMesgLabel.textColor          =   [UIColor colorWithRed:(CGFloat)178/255.0 green:(CGFloat)114/255.0 blue:(CGFloat)115/255.0 alpha:1.0];
}

- (IBAction)keyboardAction:(id)sender {
    
    UIButton *actionButton  =   (UIButton*)sender;
    if (actionButton.tag == 10) {
        // clear one item
        
        if (currentPosition >= 1) {
            UIImageView *currentImageView       =   (UIImageView*)[self.view viewWithTag:currentPosition+20];
            currentImageView.hidden             =   TRUE;
            currentPosition                     =   currentPosition-1;
            
        }
    }else {
        currentPosition                         =   currentPosition+1;
        UIImageView *currentImageView           =   (UIImageView*)[self.view viewWithTag:currentPosition+20];
        currentImageView.hidden                 =   FALSE;
        if ([pinEntryString length] == 0) {
            [pinEntryString appendFormat:@"%d",actionButton.tag];
        }else {
            [pinEntryString appendString:[NSString stringWithFormat:@"%d",actionButton.tag]];
        }
        
        if (currentPosition >= 4) {
            // go to paid cash
            
            if ([pinEntryString isEqualToString:CLIENT_PIN_NUMBER]) {
                PaymentSuccessViewController *successController =   [[PaymentSuccessViewController alloc]init];
                successController.receiptObject                 =   self.receiptObj;
                [self presentModalViewController:successController animated:TRUE];
                [successController release];
            }else {
                [self performSelector:@selector(hidePasscodes) withObject:nil afterDelay:0.2];
                currentPosition                 =   0;
                [pinEntryString setString:@""];
                
            } 
        }
    }
}

- (IBAction)goBack:(id)sender {
    [self dismissModalViewControllerAnimated:TRUE];
}

- (IBAction)clearItems:(id)sender {
    pinMesgLabel.text               =   @"Allow merchant to approve the charge";
    pinMesgLabel.textColor          =   [UIColor colorWithRed:(CGFloat)51/255.0 green:(CGFloat)51/255.0 blue:(CGFloat)51/255.0 alpha:1.0];
    currentPosition                 =   0;
    passcode1.hidden                =   TRUE;
    passcode2.hidden                =   TRUE;
    passcode3.hidden                =   TRUE;
    passcode4.hidden                =   TRUE;
    [pinEntryString setString:@""];
}
- (void)dealloc {
    [userImage release];
    [pinMesgLabel release];
    [pinEntryString release];
    [billLabel release];
    [totalLabel release];
    [receiptObj release];

    [passcode1 release];
    [passcode2 release];
    [passcode3 release];
    [passcode4 release];
    [shopName release];
    [super dealloc];
}
@end
