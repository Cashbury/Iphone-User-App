//
//  KZCashierSpendReceiptViewController.h
//  Cashbery
//
//  Created by Basayel Said on 8/7/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KZBusiness.h" 


@interface KZCashierSpendReceiptViewController : UIViewController {
	NSString *fb_image_url;
	KZBusiness *business;
	NSString *address;
	NSMutableArray *details_lines;
	NSMutableArray *cells_heights;
	BOOL is_loaded;
	
	NSString* amount;
	NSString* currency_symbol;
	NSString* customer_name;
	NSString* customer_type;
	NSString* customer_image_url;
	NSString* transaction_id;
}

- (IBAction) clear_btn:(id)sender;
- (IBAction) share_btn:(id)sender;

@property (nonatomic, retain) NSString *actionString;

@property (nonatomic, retain) IBOutlet UILabel *lblBusinessName;
@property (nonatomic, retain) IBOutlet UILabel *lblBranchAddress;
@property (nonatomic, retain) IBOutlet UILabel *lblTime;
@property (nonatomic, retain) IBOutlet UILabel *lblTitle;
@property (nonatomic, retain) IBOutlet UILabel *lblTransactionId;

@property (nonatomic, retain) IBOutlet UILabel *lblCustomerName;
@property (nonatomic, retain) IBOutlet UILabel *lblCustomerType;
@property (nonatomic, retain) IBOutlet UIImageView *imgCustomerImage;

@property (nonatomic, retain) IBOutlet UIView *viewReceipt;
@property (nonatomic, retain) IBOutlet UITableView *tbl_body;
@property (nonatomic, retain) IBOutlet UITableViewCell *cell_top;
@property (nonatomic, retain) IBOutlet UITableViewCell *cell_middle;
@property (nonatomic, retain) IBOutlet UITableViewCell *cell_bottom;
@property (nonatomic, retain) IBOutlet UIImageView *img_register;
@property (nonatomic, retain) NSString *share_string;

- (id) initWithBusiness: (KZBusiness*)_biz 
				 amount: (NSString*)_amount
		currency_symbol: (NSString*)_currency_symbol
		  customer_name: (NSString*)_customer_name
		  customer_type: (NSString*)_customer_type
	 customer_image_url: (NSString*)_customer_image_url 
		 transaction_id: (NSString*)_transaction_id;

- (void) addLineDetail:(NSString*)_detail;
- (void) setMainTitle:(NSString*)_title;
- (void) setFacebookMessage:(NSString*)_fb_message andIcon:(NSString*)_image_url;

@end
