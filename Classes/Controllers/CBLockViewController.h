//
//  CBLockViewController.h
//  Cashbury
//
//  Created by Rami on 24/2/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBLockViewController;

@protocol CBLockViewControllerDelegate <NSObject>
- (void) lockViewController:(CBLockViewController *)theSender didEnterPIN:(NSString *)thePin;
@optional
- (void) cancelledLockViewController:(CBLockViewController *)theSender;
@end

@interface CBLockViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, assign) id<CBLockViewControllerDelegate> delegate;

@property (nonatomic, retain) IBOutlet UILabel *messageLabel;
@property (nonatomic, retain) IBOutlet UIButton *cancelButton;

@property (nonatomic, retain) IBOutlet UITextField *firstDigit;
@property (nonatomic, retain) IBOutlet UITextField *secondDigit;
@property (nonatomic, retain) IBOutlet UITextField *thirdDigit;
@property (nonatomic, retain) IBOutlet UITextField *fourthDigit;

- (void) clearAllFields;

- (IBAction) didTapCancel:(id)theSender;
- (IBAction) hideKeyboard:(id)theSender;

@end
