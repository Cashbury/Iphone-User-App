//
//  CashierTxHistoryViewController.m
//  Cashbery
//
//  Created by Basayel Said on 8/21/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import "CashierTxHistoryViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface CashierTxHistoryViewController (Private)
	- (void) setMyStyleForButton:(UIButton*)_btn;
@end


@implementation CashierTxHistoryViewController


@synthesize lbl_title, view_menu, img_menu_arrow, btn_back;

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

    
	[self setMyStyleForButton:self.btn_back];
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
	
    return [((NSMutableArray*)[((NSMutableDictionary*)[days_array objectAtIndex:section]) objectForKey:@"receipts"]) count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    NSDictionary* receipt = [((NSArray*)[((NSDictionary*)[days_array objectAtIndex:indexPath.section]) objectForKey:@"receipts"]) objectAtIndex:indexPath.row];
	cell.text = [NSString stringWithFormat:@"%@ : %@", [receipt objectForKey:@"transaction_id"], [receipt objectForKey:@"customer_name"]];
    return cell;
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
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
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
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	NSDate* section_date = (NSString*)[((NSDictionary*)[days_array objectAtIndex:section]) objectForKey:@"date"];
	
	return [section_date description];
}

- (void)dealloc {
	[days_array release];
    [super dealloc];
}

- (IBAction) backAction {
	[self dismissModalViewControllerAnimated:YES];
}


- (void) setMyStyleForButton:(UIButton*)_btn {
	[_btn setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"CWR_pattern.png"]]];
	
	
	_btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
	_btn.layer.borderWidth = 1.0;
	
	
	_btn.layer.cornerRadius = 5.0;
	
	_btn.layer.shadowColor = [UIColor redColor].CGColor;
	//_btn.layer.shadowOpacity = 1.0;
	_btn.layer.shadowRadius = 1.0;
	_btn.layer.shadowOffset = CGSizeMake(0.0, 1.0);
	_btn.layer.masksToBounds = YES;
}


@end

