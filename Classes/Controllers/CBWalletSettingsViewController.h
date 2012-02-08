//
//  CBWalletSettingsViewController.h
//  Cashbury
//
//  Created by Rami on 22/5/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KZURLRequest.h"
#import "CBMagnifiableViewController.h"
#import "CBAsyncImageView.h"

@interface CBWalletSettingsViewController : CBMagnifiableViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UITextFieldDelegate, KZURLRequestDelegate>
{   
}

@property (retain, nonatomic) IBOutlet UIButton *backButton;
@property (retain, nonatomic) IBOutlet UIButton *logoutButton;

@property (retain, nonatomic) IBOutlet UITableView* tbl_view;
@property (retain, nonatomic) IBOutlet UITableViewCell* cell_balance;
@property (retain, nonatomic) IBOutlet UITableViewCell* cell_phone;

@property (retain, nonatomic) IBOutlet UITextField* txt_phone;

@property (retain, nonatomic) IBOutlet CBAsyncImageView *profileImage;
@property (retain, nonatomic) IBOutlet UILabel* lbl_name;
@property (retain, nonatomic) IBOutlet UIView* view_dropdown;
@property (retain, nonatomic) IBOutlet UILabel* lbl_business_name;
@property (retain, nonatomic) IBOutlet UIView* view_for_life;
@property (retain, nonatomic) IBOutlet UIView* view_for_work;

@property (retain, nonatomic) IBOutlet UIImageView* img_phone_field_bg;
@property (retain, nonatomic) NSString* phone_number;

- (IBAction) didTapWalkOutButton:(id)theSender;
- (IBAction) hideKeyBoard;
- (IBAction) didTapGoBackButton:(id)theSender;
- (IBAction) showCashierViews:(id) sender;
- (IBAction) showCustomerViews:(id) sender;

- (void) persistPhoneNumber:(NSString*)_phone_number;

- (NSString*) getPersistedPhoneNumber;
- (void) processPhoneNumber;
@end
