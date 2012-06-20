//
//  CBGiftsViewController.m
//  Cashbury
//
//  Created by Rami on 14/2/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#import "CBGiftsViewController.h"
#import "CBLockViewController.h"
#import "KZUserInfo.h"

@implementation CBGiftsViewController
@synthesize codeSwitch;
@synthesize buttonDelegate;

- (void)dealloc {
    [codeSwitch release];
    [buttonDelegate release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setCodeSwitch:nil];
    [super viewDidUnload];
}

-(void)showLockScreen{
    
    CBLockViewController *_lockViewController = [[CBLockViewController alloc] initWithNibName:@"CBLockView" bundle:nil];
    _lockViewController.delegate = self;
    
    [self magnifyViewController:_lockViewController duration:0.3];
    
    _lockViewController.cancelButton.hidden = NO;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0)
    {
        KZUserInfo *_userInfo = [KZUserInfo shared];
        
        _userInfo.pinCode = @"";
        [_userInfo persistData];
        
        self.codeSwitch.on = NO;
    }
    else
    {
        self.codeSwitch.on = YES;
    }
    
}


- (void) resetPins
{
    firstPIN = @"";
    secondPIN = @"";
}

//------------------------------------
// CBLockViewControllerDelegate methods
//------------------------------------
#pragma mark - CBLockViewControllerDelegate

- (void) lockViewController:(CBLockViewController *)theSender didEnterPIN:(NSString *)thePin
{
    if ([firstPIN isEqualToString:@""])
    {
        firstPIN = [thePin copy];
        
        theSender.messageLabel.text = @"Confirm your PIN Code";
        [theSender clearAllFields];
    }
    else
    {
        secondPIN = [thePin copy];
        
        if ([secondPIN isEqualToString:firstPIN])
        {
            KZUserInfo *_userInfo = [KZUserInfo shared];
            
            _userInfo.pinCode = thePin;
            [_userInfo persistData];
            
            UIAlertView *_alert = [[[UIAlertView alloc] initWithTitle:@"Cashbury"
                                                              message:@"Your PIN Code has been saved."
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil] autorelease];
            
            [_alert show];
            
            [self resetPins];
            
            [self diminishViewController:theSender duration:0.3];
        }
        else
        {
            UIAlertView *_alert = [[[UIAlertView alloc] initWithTitle:@"Cashbury"
                                                              message:@"Your PIN Codes don't match."
                                                             delegate:nil
                                                    cancelButtonTitle:@"Try again"
                                                    otherButtonTitles:nil] autorelease];
            [_alert show];
            
            [self resetPins];
            
            theSender.messageLabel.text = @"Enter your PIN Code";
            
            [theSender clearAllFields];
        }
    }
}

- (void) cancelledLockViewController:(CBLockViewController *)theSender
{
    [self resetPins];
    
    [self diminishViewController:theSender duration:0.3];
    
    [theSender release];
    
    self.codeSwitch.on = NO;
     
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.codeSwitch.on = [[KZUserInfo shared] hasPINCode];
    
    [self resetPins];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [buttonDelegate changeLockButtonState];
}
- (IBAction)switchChanged:(id)sender {
    UISwitch *cSwitch    =   (UISwitch*)sender;
    if (cSwitch.on)
    {
        [self showLockScreen];
    }
    else
    {
        UIAlertView *_alert = [[[UIAlertView alloc] initWithTitle:@"Cashbury"
                                                          message:@"Are you sure you want to clear your PIN code?"
                                                         delegate:self
                                                cancelButtonTitle:@"YES"
                                                otherButtonTitles:@"NO",nil] autorelease];
        [_alert show];
    }
}

- (IBAction)goBack:(id)sender {
    
    [self diminishViewController:self duration:0.35];
}
@end
