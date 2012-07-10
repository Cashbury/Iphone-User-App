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
#import "KZUserInfo.h"


@implementation KZCustomerReceiptHistoryViewController

@synthesize titleLabel, table, place;

#pragma mark Request & Response

-(void)sendRequestForCustomerREceipts{
    NSMutableDictionary *_headers = [[NSMutableDictionary alloc] init];
    [_headers setValue:@"application/xml" forKey:@"Accept"];
    [[[KZURLRequest alloc] initRequestWithString:[NSString stringWithFormat:@"%@/users/receipts/receipts-customer.xml?business_id=%d&auth_token=%@", API_URL, place.businessID, [KZUserInfo shared].auth_token] andParams:nil delegate:self headers:_headers andLoadingMessage:@"Loading..."] autorelease];
    [_headers release];
}

#pragma mark -
#pragma mark NSURLConnectionDelegate methods



-(void)KZURLRequest:(KZURLRequest *)theRequest didSucceedWithData:(NSData *)theData{
    
}


-(void) KZURLRequest:(KZURLRequest *)theRequest didFailWithError:(NSError *)theError{
    
}



#pragma mark - View lifecycle

- (void) viewDidLoad
{
    [super viewDidLoad];
    receiptDict =   [[NSMutableDictionary alloc] init];  
    [self sendRequestForCustomerREceipts];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    self.titleLabel = nil;
    self.table = nil;
}


- (void)dealloc
{
    [table release];
	[titleLabel release];
    [receiptDict release];
    [place release];
	
    [super dealloc];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [receiptDict count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *_receipt; //= (NSDictionary*) [receipts objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"ReceiptCell";
    CBReceiptTableCell *cell = (CBReceiptTableCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil)
    {
        cell = [[NSBundle mainBundle] loadObjectFromNibNamed:@"CBReceiptTableCell"
                                                       class:[CBReceiptTableCell class]
                                                       owner:self
                                                     options:nil];
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSString *_placeName = (NSString *) [_receipt objectForKey:@"brand_name"];
    NSString *_dateTime = (NSString *) [_receipt objectForKey:@"date_time"];
    NSString *_currencySymbol =  (NSString *) [_receipt objectForKey:@"currency_symbol"];
    NSString *_amount =  (NSString *) [_receipt objectForKey:@"earned_points"];
    NSString *_receiptType =  (NSString *) [_receipt objectForKey:@"receipt_type"];
    
    // TODO: remove once the receipts return a proper amount
    if (_amount.length == 0)
    {
        _amount = @"11.11";
    }
    
    cell.placeLabel.text = _placeName;
    cell.dateLabel.text = _dateTime;
    cell.typeLabel.text = _receiptType;
    
    if ([_receiptType isEqualToString:@"load"])
    {
        cell.amountLabel.text = [NSString stringWithFormat:@"+ %@%@", _currencySymbol, _amount];
    }
    else if ([_receiptType isEqualToString:@"spend"])
    {
        cell.amountLabel.text = [NSString stringWithFormat:@"- %@%@", _currencySymbol, _amount];
    }
    
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
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
	[rec release];	*/
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62;
}


- (IBAction)goBack:(id)sender {
    [self diminishViewController:self duration:0.35];
}
@end
