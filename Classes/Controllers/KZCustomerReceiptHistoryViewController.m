//
//  KZCustomerReceiptHistoryViewController.m
//  Cashbery
//
//  Created by Basayel Said on 8/25/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import "KZCustomerReceiptHistoryViewController.h"
#import "KZSpendReceiptViewController.h"
#import "KZReceiptHistory.h"
#import "CBReceiptTableCell.h"
#import "NSBundle+Helpers.h"

@implementation KZCustomerReceiptHistoryViewController

@synthesize titleLabel, table;

#pragma mark - View lifecycle

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    [KZReceiptHistory getCustomerReceipts:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    receipts = nil;
    
    self.titleLabel = nil;
    self.table = nil;
}


- (void)dealloc
{
    [table release];
	[titleLabel release];
    [receipts release];
	
    [super dealloc];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [receipts count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *_receipt = (NSDictionary*) [receipts objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"ReceiptCell";
    CBReceiptTableCell *cell = (CBReceiptTableCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil)
    {
        cell = [[NSBundle mainBundle] loadObjectFromNibNamed:@"CBReceiptTableCell"
                                                       class:[CBReceiptTableCell class]
                                                       owner:self
                                                     options:nil];
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    NSString *_placeName = (NSString *) [_receipt objectForKey:@"brand_name"];
    NSString *_dateTime = (NSString *) [_receipt objectForKey:@"date_time"];
    NSString *_imageURL = (NSString *) [_receipt objectForKey:@"brand_image_fb"];
    NSString *_currencySymbol =  (NSString *) [_receipt objectForKey:@"currency_symbol"];
    NSString *_amount =  (NSString *) [_receipt objectForKey:@"spend_money"];
    
    cell.placeLabel.text = _placeName;
    cell.dateLabel.text = _dateTime;
    cell.amountLabel.text = [NSString stringWithFormat:@"%@%@", _currencySymbol, _amount];
    
    [cell.imageView loadImageWithAsyncUrl:[NSURL URLWithString:_imageURL]];
    
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSDictionary* receipt = (NSDictionary*)[receipts objectAtIndex:indexPath.row];
    
	KZSpendReceiptViewController* rec = 
	[[KZSpendReceiptViewController alloc] initWithBusiness: nil
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62;
}

#pragma mark -
#pragma mark KZReceiptHistoryDelegate

- (void) gotCustomerReceipts:(NSMutableArray*)_receipts
{
    NSArray *_oldReceipts = receipts;
    receipts = [_receipts retain];
    [_oldReceipts release];
    
    [self.table reloadData];
}

- (void) noReceiptsFound
{
    
}

@end
