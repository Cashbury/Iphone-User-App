//
//  CBWalletSettingsViewController.h
//  Cashbury
//
//  Created by Rami on 22/5/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CBWalletSettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UITextFieldDelegate>
{   
}
@property (retain, nonatomic) IBOutlet UITableView* tbl_view;
@property (retain, nonatomic) IBOutlet UITableViewCell* cell_balance;
@property (retain, nonatomic) IBOutlet UITableViewCell* cell_phone;
@property (retain, nonatomic) IBOutlet UITableViewCell* cell_bottom;

@property (retain, nonatomic) IBOutlet UITextField* txt_phone;
@property (retain, nonatomic) IBOutlet UILabel* lbl_name;
@property (retain, nonatomic) IBOutlet UIImageView* img_phone_field_bg;
@property (retain, nonatomic) IBOutlet UIImageView* img_facebook;
@property (retain, nonatomic) NSString* phone_number;

- (IBAction) didTapWalkOutButton:(id)theSender;
- (IBAction) hideKeyBoard;
- (IBAction) didTapGoBackButton:(id)theSender;

- (void) persistPhoneNumber:(NSString*)_phone_number;

- (NSString*) getPersistedPhoneNumber;
- (void) processPhoneNumber;
@end
