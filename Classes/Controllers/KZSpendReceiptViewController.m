    //
//  KZSpendReceiptViewController.m
//  Cashbery
//
//  Created by Basayel Said on 8/7/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import "KZSpendReceiptViewController.h"
#import "KZApplication.h"
#import "FacebookWrapper.h"
#import "KZRewardViewController.h"
#import "KZReceiptController.h"

@implementation KZSpendReceiptViewController

@synthesize lblBusinessName,
lblBranchAddress, 
lblTime, 
lblTitle, 
viewReceipt, 
cell_top, 
cell_middle, 
cell_bottom, 
tbl_body, 
img_register, 
share_string,
lblSpendText;


- (id) initWithBusiness: (KZBusiness*)_biz 
				 amount: (NSString*)_amount
		currency_symbol: (NSString*)_currency_symbol
			  date_time:(NSString*)_date_time
			 place_name:(NSString*)_place_name
		   receipt_text:(NSString*)_receipt_text
		   receipt_type:(NSString*)_receipt_type
		 transaction_id:(NSString*)_transaction_id
{
	self = [super initWithNibName:@"KZSpendReceiptView" bundle:nil];
	if (self != nil) {
		is_loaded = NO;
		business = [_biz retain];
		
		amount = [_amount retain];
		currency_symbol = [_currency_symbol retain];
		
		date_time = [_date_time retain];
		place_name = [_place_name retain];
		receipt_text = [_receipt_text retain];
		receipt_type = [_receipt_type retain];
		transaction_id = [_transaction_id retain];

		
		details_lines = [[NSMutableArray alloc] init];
		cells_heights = [[NSMutableArray alloc] init];
	}
	return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	[self.viewReceipt setHidden:YES];
	self.lblBusinessName.text = business.name;
	self.lblBranchAddress.text = address;
	[self.navigationController setNavigationBarHidden:YES];
	self.lblSpendText.text = [NSString stringWithFormat:@"%@%@ Spent", currency_symbol, amount];
	self.lblTitle.text = [NSString stringWithFormat:@"Receipt %@", transaction_id];
	
	// set time and date
	NSDate* date = [NSDate date];
	NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
	[formatter setDateFormat:@"hh:mm:ss a MM.dd.yyyy"];
	NSString* str = [formatter stringFromDate:date];
	self.lblTime.text = str;
	is_loaded = YES;
}

- (void) viewDidAppear:(BOOL)animated {
	CGRect frame = self.view.frame;
	CGPoint origin;
	int old_y = self.viewReceipt.center.y; 
	origin.x = self.viewReceipt.center.x;
	origin.y = self.viewReceipt.center.y*3;
	[self.viewReceipt setCenter:origin];
	[self.viewReceipt setHidden:NO];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1];
	origin.y = old_y;
	[self.viewReceipt setCenter:origin];
	[UIView commitAnimations];
	[self performSelector:@selector(animationDone) withObject:nil afterDelay:1.0];
}

- (void) animationDone {
	[self.img_register setImage:[UIImage imageNamed:@"bottom_receipt_g.png"]];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
	self.img_register = nil;
	self.share_string = nil;
	[business release];
	
	[amount release];
	[currency_symbol release];
	[date_time release];
	[place_name release];
	[receipt_text release];
	[receipt_type release];
	[transaction_id release];
	
	[details_lines release];
	[cells_heights release];
    [super dealloc];
}


- (IBAction) clear_btn:(id)sender {
	//UINavigationController *nav = [KZApplication getAppDelegate].navigationController;
	//[nav setToolbarHidden:NO animated:NO];
	//[nav setNavigationBarHidden:NO animated:NO];
	//[nav popViewControllerAnimated:YES];
	
	
	KZSpendReceiptViewController* receipt = [KZReceiptController getNextReceipt];
	if (receipt != nil) {
		[self dismissModalViewControllerAnimated:NO];
		[[KZApplication getAppDelegate].navigationController presentModalViewController:receipt animated:YES];
	} else {
		[self dismissModalViewControllerAnimated:YES];
	}
}


- (IBAction) share_btn:(id)sender {
	[FacebookWrapper setPublishDelegate:self];
	[[FacebookWrapper shared] publishStreamWithText:self.share_string andCaption:self.lblBusinessName.text andImage:business.image_url];
}


- (void) didPublish {
	NSLog(@"Published");
}

- (void) addLineDetail:(NSString*)_detail {
	[details_lines addObject:_detail];
	if (is_loaded) {
		[self.tbl_body reloadData];
	}
	/*
	 UILabel *lbl = [[UILabel alloc] init];
	 lbl.lineBreakMode = UILineBreakModeWordWrap;
	 lbl.adjustsFontSizeToFitWidth = NO;
	 lbl.font = [UIFont fontWithName:@"Arial" size:17.0];
	 lbl.opaque = NO;
	 lbl.numberOfLines = 0;
	 lbl.text = _detail;
	 CGRect frm = lbl.frame;
	 frm.size.width = 280;
	 frm.origin.x = 20;
	 frm.origin.y = offset;
	 frm.size.height = 50;
	 lbl.frame = frm;
	 lbl.backgroundColor = [UIColor clearColor];
	 [self.scrollView addSubview:lbl];
	 NSLog(@"@@@@@@@@ %ld", lbl.frame.size.height);
	 int increment = lbl.frame.size.height;
	 offset += increment;
	 
	 CGRect frame;
	 frame = self.img_line.frame; frame.origin.y = frame.origin.y + increment; self.img_line.frame = frame;
	 frame = self.img_facebook.frame; frame.origin.y = frame.origin.y + increment; self.img_facebook.frame = frame;
	 frame = self.btn_facebook_share.frame; frame.origin.y = frame.origin.y + increment; self.btn_facebook_share.frame = frame;
	 */
}

- (void) setMainTitle:(NSString*)_title {
	self.lblTitle.text = _title;
}

- (void) setFacebookMessage:(NSString*)_fb_message andIcon:(NSString*)_image_url {
	self.share_string = _fb_message;
	[fb_image_url release];
	fb_image_url = [_image_url retain];
}



#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [details_lines count] + 2;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell;
	NSUInteger row = [indexPath row];
	NSUInteger count = [details_lines count] + 2;
	
	if (row == 0) {
		cell = self.cell_top;
	} else if (row == count - 1) {
		cell = self.cell_bottom;
	} else {
		cell = [tableView dequeueReusableCellWithIdentifier:@"detail_cell"];
		if (cell == nil) {
			NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:self.cell_middle];
			cell = [NSKeyedUnarchiver unarchiveObjectWithData:archivedData];
			//cell = self.cell_middle;
		}
		NSString *str = (NSString*)[details_lines objectAtIndex:row-1];
		CGSize theSize = [str sizeWithFont:[UIFont fontWithName:@"Arial" size:14.0] 
						 constrainedToSize:CGSizeMake(250.0f, FLT_MAX) lineBreakMode:UILineBreakModeWordWrap];
		UILabel *lbl = (UILabel*)[cell viewWithTag:111];
		CGRect frame = lbl.frame;
		frame.size.height = theSize.height;
		lbl.frame = frame;
		lbl.text = str;
		frame = cell.frame;
		frame.size.height = lbl.frame.size.height + 10;
		cell.frame = frame;
	}
	[cells_heights addObject:[NSNumber numberWithInt:cell.frame.size.height]];
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	int row = [indexPath row];
	NSUInteger count = [details_lines count] + 2;
	if (row == 0) {
		return self.cell_top.frame.size.height;
	} else if (row == count - 1) {
		return self.cell_bottom.frame.size.height;
	} else {
		NSString *str = (NSString*)[details_lines objectAtIndex:row-1];
		CGSize theSize = [str sizeWithFont:[UIFont fontWithName:@"Arial" size:14.0] 
						 constrainedToSize:CGSizeMake(250.0f, FLT_MAX) lineBreakMode:UILineBreakModeWordWrap];
		return theSize.height + 10;
	}
}

@end
