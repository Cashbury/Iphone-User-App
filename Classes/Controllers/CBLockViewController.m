//
//  CBLockViewController.m
//  Cashbury
//
//  Created by Rami on 24/2/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#import "CBLockViewController.h"

@interface CBLockViewController (PrivateMethods)
- (void) alertDelegate;
@end

@implementation CBLockViewController
@synthesize delegate, messageLabel, cancelButton, firstDigit, secondDigit, thirdDigit, fourthDigit;

//------------------------------------
// Init & dealloc
//------------------------------------
#pragma mark - Init & dealloc

- (void) dealloc
{
    [messageLabel release];
    [cancelButton release];
    
    [firstDigit release];
    [secondDigit release];
    [thirdDigit release];
    [fourthDigit release];
    
    [super dealloc];
}

//------------------------------------
// View lifecycle
//------------------------------------
#pragma mark - View lifecycle

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void) viewDidAppear:(BOOL)isAnimated
{
    [super viewDidAppear:isAnimated];
    
    [self clearAllFields];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.messageLabel = nil;
    self.cancelButton = nil;
    
    self.firstDigit = nil;
    self.secondDigit = nil;
    self.thirdDigit = nil;
    self.fourthDigit = nil;
}

//------------------------------------
// UITextFieldDelegate methods
//------------------------------------
#pragma mark - UITextFieldDelegate methods

- (BOOL)textField:(UITextField *)theTextField shouldChangeCharactersInRange:(NSRange)theRange replacementString:(NSString *)theString
{
    theTextField.text = theString;
    
    if (theTextField == firstDigit)
    {
        //self.secondDigit.text = @"";
        [secondDigit becomeFirstResponder];
    }
    else if (theTextField == secondDigit)
    {
        //self.thirdDigit.text = @"";
        [thirdDigit becomeFirstResponder];
    }
    else if (theTextField == thirdDigit)
    {
        //self.fourthDigit.text = @"";
        [fourthDigit becomeFirstResponder];
    }
    else
    {
        [fourthDigit resignFirstResponder];
        [self alertDelegate];
    }
    
    return NO;
}

//------------------------------------
// Public methods
//------------------------------------
#pragma mark - Public methods

- (void) clearAllFields
{
    self.firstDigit.text = @"";
    self.secondDigit.text = @"";
    self.thirdDigit.text = @"";
    self.fourthDigit.text = @"";
    
    [self.firstDigit becomeFirstResponder];
}

//------------------------------------
// Private methods
//------------------------------------
#pragma mark - Private methods

- (void) alertDelegate
{
    NSString *_pinString = self.firstDigit.text;
    
    _pinString = [_pinString stringByAppendingString:self.secondDigit.text];
    _pinString = [_pinString stringByAppendingString:self.thirdDigit.text];
    _pinString = [_pinString stringByAppendingString:self.fourthDigit.text];
    
    if ([_pinString length] == 4)
    {
        [self.delegate lockViewController:self didEnterPIN:_pinString];
    }
}

//------------------------------------
// Actions
//------------------------------------
#pragma mark - Actions

- (IBAction) hideKeyboard:(id)theSender
{
    [self.firstDigit resignFirstResponder];
    [self.secondDigit resignFirstResponder];
    [self.thirdDigit resignFirstResponder];
    [self.fourthDigit resignFirstResponder];
}

- (IBAction) didTapCancel:(id)theSender
{
    if ([delegate respondsToSelector:@selector(cancelledLockViewController:)])
    {
        [delegate cancelledLockViewController:self];
    }
}

@end
