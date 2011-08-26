    //
//  KZCustomerReceiptHistoryViewController.m
//  Cashbery
//
//  Created by Basayel Said on 8/25/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import "KZCustomerReceiptHistoryViewController.h"
#import "KZSpendReceiptViewController.h"
#import "KZApplication.h"

@interface KZCustomerReceiptHistoryViewController (Private)
	- (UILabel*) copy_label:(UILabel*)_lbl;
@end

@implementation KZCustomerReceiptHistoryViewController

@synthesize lbl_title, lbl_balance, lbl_money, lbl_date_time, lbl_place_name, lbl_R;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id) initWithCustomerRceipts:(NSArray*)_receipts andBusiness:(KZBusiness*)_biz {
    if ((self = [super initWithNibName:@"KZCustomerReceiptHistoryView" bundle:nil])) {
        receipts = [_receipts retain];
		biz = [_biz retain];
    }
    return self;
}


/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.lbl_title.text = biz.name;
	UIButton *_settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _settingsButton.frame = CGRectMake(0, 0, 320, 44);
    [_settingsButton addTarget:self action:@selector(didTapSettingsButton:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = _settingsButton;
	
	[self.navigationItem setLeftBarButtonItem:[[[UIBarButtonItem alloc] initWithCustomView:[[UIView new] autorelease]] autorelease]];	
}


- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
	[[KZApplication getAppDelegate].tool_bar_vc showToolBar:self.navigationController];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
/*
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
*/

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[receipts release];
	[biz release];
	
    [super dealloc];
}




#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section	
	NSLog(@">>>>>>>>>>>> COUNT: %d", [receipts count]);
    return [receipts count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    // Configure the cell...
    /////////////// prepare labels
	UILabel* lbl_cell_money = [self copy_label:self.lbl_money];
	UILabel* lbl_cell_date_time = [self copy_label:self.lbl_date_time];
	UILabel* lbl_cell_place_name = [self copy_label:self.lbl_place_name];
	UILabel* lbl_cell_R = [self copy_label:self.lbl_R];
	[cell addSubview:lbl_cell_money];

	//[cell addSubview:lbl_cell_place_name];
	[cell addSubview:lbl_cell_date_time];
	[cell addSubview:lbl_cell_R];
	//////////////////////////
	NSDictionary* receipt = (NSDictionary*)[receipts objectAtIndex:indexPath.row];
	
	lbl_cell_money = [NSString stringWithFormat:@"%@%@", [receipt objectForKey:@"currency_symbol"], [receipt objectForKey:@"spend_money"]];
	
	// show date time
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	[df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSDate* date = [df dateFromString:[[receipt objectForKey:@"date_time"] substringToIndex:19]];
	NSMutableString* str_date_time = [[NSMutableString alloc] init];
	[df setDateFormat:@"M/d/yyyy"];
	[str_date_time appendFormat:@"On %@ ", [df stringFromDate:date]];
	[df setDateFormat:@"hh:mm a"];
	[str_date_time appendFormat:@"at %@", [df stringFromDate:date]];
	lbl_cell_date_time.text = str_date_time;
	[df release];
	[str_date_time release];

	//lbl_cell_place_name.text = [receipt objectForKey:@"place_name"];	//////NOT WORKING FOR NOW so it is hidden
    return cell;
}

- (UILabel*) copy_label:(UILabel*)_lbl {
	UILabel* newlabel = [[[UILabel alloc] initWithFrame:_lbl.frame] autorelease];
	newlabel.font = _lbl.font;
	newlabel.textColor = _lbl.textColor;
	newlabel.textAlignment = _lbl.textAlignment;
	newlabel.text = _lbl.text;
	return newlabel;
}
/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSDictionary* receipt = (NSDictionary*)[receipts objectAtIndex:indexPath.row];
	
	
	KZSpendReceiptViewController* rec = 
	[[KZSpendReceiptViewController alloc] initWithBusiness:  biz
													amount: [receipt objectForKey:@"spend_money"]
										   currency_symbol: [receipt objectForKey:@"currency_symbol"]
												 date_time: [receipt objectForKey:@"date_time"]
												place_name: [receipt objectForKey:@"place_name"]
											  receipt_text: [receipt objectForKey:@"receipt_text"]
											  receipt_type: [receipt objectForKey:@"receipt_type"]
											transaction_id: [receipt objectForKey:@"transaction_id"]];
	[self presentModalViewController:rec animated:YES];
	[rec release];
	
}



- (IBAction) goBack {
	[[KZApplication getAppDelegate].navigationController popViewControllerAnimated:YES];
}

- (IBAction) goBackToPlaces {
	[UIView beginAnimations:@"trans" context:nil];
	[UIView setAnimationDuration:0.35];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:[KZApplication getAppDelegate].navigationController.view cache:NO];	
	[[KZApplication getAppDelegate].navigationController popViewControllerAnimated:NO];
	[[KZApplication getAppDelegate].navigationController popViewControllerAnimated:NO];
	[[KZApplication getAppDelegate].navigationController popViewControllerAnimated:NO];	
	[UIView commitAnimations];
}

- (IBAction) goBackToCards {
	[UIView beginAnimations:@"trans" context:nil];
	[UIView setAnimationDuration:0.35];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:[KZApplication getAppDelegate].navigationController.view cache:NO];	
	[[KZApplication getAppDelegate].navigationController popViewControllerAnimated:NO];
	[[KZApplication getAppDelegate].navigationController popViewControllerAnimated:NO];
	[UIView commitAnimations];
} 


@end
