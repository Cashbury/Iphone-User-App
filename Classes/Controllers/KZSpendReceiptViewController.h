//
//  KZSpendReceiptViewController.h
//  Cashbery
//
//  Created by Basayel Said on 8/7/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KZBusiness.h"

@interface KZSpendReceiptViewController : UIViewController {
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
	
	NSString* date_time;
	NSString* place_name;
	NSString* receipt_text;
	NSString* receipt_type;
	NSString* transaction_id;
}

- (IBAction) clear_btn:(id)sender;
- (IBAction) share_btn:(id)sender;

@property (nonatomic, retain) IBOutlet UILabel *lblBusinessName;
@property (nonatomic, retain) IBOutlet UILabel *lblBranchAddress;
@property (nonatomic, retain) IBOutlet UILabel *lblTime;
@property (nonatomic, retain) IBOutlet UILabel *lblTitle;

@property (nonatomic, retain) IBOutlet UILabel *lblSpendText;

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
			  date_time: (NSString*)_date_time
			 place_name: (NSString*)_place_name
		   receipt_text: (NSString*)_receipt_text
		   receipt_type: (NSString*)_receipt_type
		 transaction_id: (NSString*)_transaction_id;

- (void) addLineDetail:(NSString*)_detail;

@end
