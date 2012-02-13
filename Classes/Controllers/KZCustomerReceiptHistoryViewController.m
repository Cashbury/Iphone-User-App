//
//  KZCustomerReceiptHistoryViewController.m
//  Cashbery
//
//  Created by Basayel Said on 8/25/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import "KZCustomerReceiptHistoryViewController.h"
#import "KZSpendReceiptViewController.h"

@implementation KZCustomerReceiptHistoryViewController

@synthesize titleLabel;

#pragma mark - View lifecycle

- (void)viewDidUnload
{
    [super viewDidUnload];

    self.titleLabel = nil;
}


- (void)dealloc
{
	[titleLabel release];
	
    [super dealloc];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//	NSDictionary* receipt = (NSDictionary*)[receipts objectAtIndex:indexPath.row];
//	
//	
//	KZSpendReceiptViewController* rec = 
//	[[KZSpendReceiptViewController alloc] initWithBusiness:  biz
//													amount: [receipt objectForKey:@"spend_money"]
//										   currency_symbol: [receipt objectForKey:@"currency_symbol"]
//												 date_time: [receipt objectForKey:@"date_time"]
//												place_name: [receipt objectForKey:@"place_name"]
//											  receipt_text: [receipt objectForKey:@"receipt_text"]
//											  receipt_type: [receipt objectForKey:@"receipt_type"]
//											transaction_id: [receipt objectForKey:@"transaction_id"]];
//	[self presentModalViewController:rec animated:YES];
//	[rec release];	
}

@end
