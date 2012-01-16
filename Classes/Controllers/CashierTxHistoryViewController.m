//
//  CashierTxHistoryViewController.m
//  Cashbery
//
//  Created by Basayel Said on 8/21/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import "CashierTxHistoryViewController.h"
#import "UIButton+Helper.h"
#import "KZApplication.h"
#import "KZUserInfo.h"
#import "KZCashierSpendReceiptViewController.h"
#import "NSBundle+Helpers.h"
#import "CashierTxReceiptHistoryCell.h"

@interface CashierTxHistoryViewController (Private)
- (float) getDayReceiptsSum:(NSArray*)_receipts;
- (CWRingUpViewController *) parentController;
@end

@implementation CashierTxHistoryViewController

@synthesize lbl_title, view_menu, view_cover, img_menu_arrow, btn_ring_up, btn_receipts, btn_load_up;

+ (CashierTxHistoryHeaderView *) headerViewWithTitle:(NSString *)theTitle description:(NSString *)theDescription
{
    CashierTxHistoryHeaderView *_header = [[NSBundle mainBundle] loadObjectFromNibNamed:@"CashierTxHistoryHeaderView"
                                                                                  class:[CashierTxHistoryHeaderView class]
                                                                                  owner:nil
                                                                                options:nil];
    
    _header.title.text = theTitle;
    _header.description.text = theDescription;
    
    return _header;
}

- (id) initWithDaysArray:(NSMutableArray*)_days {
	if (self = [self initWithNibName:@"CashierTxHistoryView" bundle:nil]) {
		days_array = [_days retain];
		return self;
	}
	return nil;
}

#pragma mark -
#pragma mark Initialization

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:style])) {
    }
    return self;
}
*/


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

    
	[self.btn_ring_up setCustomStyle];
    [self.btn_load_up setCustomStyle];
	[self.btn_receipts setCustomStyle];
	
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background-receipts.png"]];
}

- (void) viewDidUnload
{
    [super viewDidUnload];
    
    self.btn_ring_up = nil;
    self.btn_receipts = nil;
    self.btn_load_up = nil;
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [days_array count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	
    NSInteger _receiptCount = [((NSMutableArray*)[((NSMutableDictionary*)[days_array objectAtIndex:section]) objectForKey:@"receipts"]) count];
    
    // Add one more row for the footer
    return _receiptCount + 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger _receiptCount = [((NSMutableArray*)[((NSMutableDictionary*)[days_array objectAtIndex:indexPath.section]) objectForKey:@"receipts"]) count];
    
    NSString *_cellIdentifier = @"Cell";
    
    if (indexPath.row == _receiptCount)
    {
        _cellIdentifier = @"FooterCell";
        
        UITableViewCell *_cell = [tableView dequeueReusableCellWithIdentifier:_cellIdentifier];
        
        if (_cell == nil)
        {
            _cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_cellIdentifier];
            _cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            _cell.bounds = CGRectMake(0, 0, tableView.frame.size.width, 10);
            
            UIImageView *_footer = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 10)] autorelease];
            
            _footer.image = [UIImage imageNamed:@"day_end.png"];
            
            [_cell addSubview:_footer];
        }
        
        return _cell;
    }
    else
    {
        CashierTxReceiptHistoryCell *cell = (CashierTxReceiptHistoryCell *) [tableView dequeueReusableCellWithIdentifier:_cellIdentifier];
        
        if (cell == nil)
        {
            cell = [[NSBundle mainBundle] loadObjectFromNibNamed:@"CashierTxReceiptHistoryCell" class:[CashierTxReceiptHistoryCell class] owner:nil options:nil];
        }
        
        // Configure the cell...
        NSDictionary* receipt = [((NSArray*)[((NSDictionary*)[days_array objectAtIndex:indexPath.section]) objectForKey:@"receipts"]) objectAtIndex:indexPath.row];
        
        cell.receipt = receipt;
        
        return cell;
    }
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
	NSDictionary* section_day = (NSDictionary*)[days_array objectAtIndex:indexPath.section];
	NSArray* receipts = (NSArray*)[section_day objectForKey:@"receipts"];
	NSDictionary* receipt = (NSDictionary*)[receipts objectAtIndex:indexPath.row];
	KZCashierSpendReceiptViewController* rec = 
	[[KZCashierSpendReceiptViewController alloc] initWithBusiness:[KZUserInfo shared].cashier_business 
														   amount:[receipt objectForKey:@"spend_money"]
												  currency_symbol:[receipt objectForKey:@"currency_symbol"]
													customer_name:[receipt objectForKey:@"customer_name"] 
													customer_type:[receipt objectForKey:@"customer_type"] 
											   customer_image_url:[receipt objectForKey:@"customer_image_url"]
												   transaction_id:[receipt objectForKey:@"transaction_id"]];
	[self presentModalViewController:rec animated:YES];
	[rec release];

}


#pragma mark -
#pragma mark Memory management
/*
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

*/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger _receiptCount = [((NSMutableArray*)[((NSMutableDictionary*)[days_array objectAtIndex:indexPath.section]) objectForKey:@"receipts"]) count];
    
    return (indexPath.row == _receiptCount) ? 10 : 75;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 58;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSDictionary* section_day = (NSDictionary*)[days_array objectAtIndex:section];
	NSArray* receipts = (NSArray*)[section_day objectForKey:@"receipts"];
	NSUInteger count = [receipts count];
	float sum = [self getDayReceiptsSum:receipts];
    NSString *_sumString = [NSString stringWithFormat:@"%0.0lf %@", sum, [KZUserInfo shared].currency_code];
    
    NSString *_titleLabel = nil;
    
    if (section == 0)
    {
        _titleLabel = [NSString stringWithFormat:@"Today, %@", _sumString];
    }
    else if (section == 1)
    {
        _titleLabel = [NSString stringWithFormat:@"Yesterday, %@", _sumString];
    }
    else
    {
        NSDate* section_date = [section_day objectForKey:@"date"];
        NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
        [formatter setDateFormat:@"EEEE"];
        
        _titleLabel = [NSString stringWithFormat:@"%@, %@", [formatter stringFromDate:section_date], _sumString];
    }
    
    NSString *_description = [NSString stringWithFormat:@"%d receipts", count];
    
    return [CashierTxHistoryViewController headerViewWithTitle:_titleLabel description:_description];
}

- (void)dealloc {
	[days_array release];
    [super dealloc];
}




- (IBAction) openCloseMenu {
	CGRect current_position = self.view_menu.frame;
	if (is_menu_open) {	// then close
		current_position.origin.y -= 200;
	} else {	// then open
		current_position.origin.y += 200;
	}
	is_menu_open = !is_menu_open;
	[self.view_cover setHidden:NO];
	[self.view_cover setOpaque:NO];
	[UIView animateWithDuration:0.5 
					 animations:^(void){
						 if (is_menu_open) {
							 [self.view_cover setAlpha:0.8];
						 } else {
							 [self.view_cover setAlpha:0.0];
						 }
						 self.view_menu.frame = current_position;
					 } 
					 completion:^(BOOL finished){	
						 if (is_menu_open) {
							 [self.lbl_title setHighlighted:YES];
							 [self.img_menu_arrow setHighlighted:YES];
						 } else {
							 [self.lbl_title setHighlighted:NO];
							 [self.img_menu_arrow setHighlighted:NO];
						 }
					 }
	 ];
	
}





- (IBAction) showTransactionHistory {
	[self openCloseMenu];
}

- (CWRingUpViewController *) parentController
{
    if (IS_IOS_5_OR_NEWER)
    {
        return (CWRingUpViewController *) self.presentingViewController;
    }
    else
    {
        return (CWRingUpViewController *) self.parentViewController;
    }
}

- (IBAction) showRingUp
{
    CWRingUpViewController *_parent = [self parentController];
    
    if (_parent)
    {
        _parent.action = CWRingUpViewControllerActionCharge;
    }
    
    [self openCloseMenu];
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction) showLoadUp
{
    CWRingUpViewController *_parent = [self parentController];
    
    if (_parent)
    {
        _parent.action = CWRingUpViewControllerActionLoad;
    }
    
    [self openCloseMenu];
	[self dismissModalViewControllerAnimated:YES];
}


- (IBAction) goBackToSettings:(id)sender {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view.superview cache:NO];	
	[self dismissModalViewControllerAnimated:NO];
	NSArray* views = [KZApplication getAppDelegate].window.subviews;
	UIView* top_view = (UIView*)[views objectAtIndex:[views count]-1];
	[top_view removeFromSuperview];
	[UIView commitAnimations];
}

- (float) getDayReceiptsSum:(NSArray*)_receipts {
	float sum = 0.0;
	for (NSDictionary* receipt in _receipts) {
		///////////TODO
		sum += [((NSString*)[receipt objectForKey:@"spend_money"]) floatValue];
	}
	return sum;
}

@end

