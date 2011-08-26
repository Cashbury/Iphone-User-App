//
//  KZReceiptHistory.m
//  Cashbery
//
//  Created by Basayel Said on 8/18/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#define CUSTOMER_REQUEST 1
#define CASHIER_REQUEST 2


#import "KZReceiptHistory.h"
#import "CWItemEngagement.h"
#import "CXMLElement+Helpers.h"
#import "TouchXML.h"
#import "KZApplication.h"
#import "KZUserInfo.h"


@interface KZReceiptHistory (Private)

+ (void) setDelegate:(id<KZReceiptHistoryDelegate>)_delegate;

@end

@implementation KZReceiptHistory

static KZReceiptHistory* shared = nil;

@synthesize delegate;


- (void) KZURLRequest:(KZURLRequest *)theRequest didFailWithError:(NSError*)theError {
	//NSLog(@"An Error has occured when requesting the User ID QRCode");
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Sorry a server error has occurred while getting your receipts. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alert show];
	[alert release];
	[theRequest release];
}

- (void) KZURLRequest:(KZURLRequest *)theRequest didSucceedWithData:(NSData*)theData {
	@try {	
		CXMLDocument *_document = [[[CXMLDocument alloc] initWithData:theData options:0 error:nil] autorelease];
		NSLog([_document description]);
		if (theRequest.identifier == CASHIER_REQUEST) {
			NSArray* _nodes = [_document nodesForXPath:@"/cashier_receipts/day" error:nil];
			
			//////////////TODO cashier receit history
			NSMutableArray* days = [[[NSMutableArray alloc] init] autorelease];		//<> 0
			
			for (CXMLElement* _day in _nodes) { 
//				if ([[_day nodesForXPath:@"receipts/receipt" error:nil] count] > 0) { 
					NSMutableDictionary* day_info = [[NSMutableDictionary alloc] init];		//< 1
					NSDateFormatter *df = [[NSDateFormatter alloc] init];
					[df setDateFormat:@"yyyy-MM-dd"];
					[day_info setObject:[df dateFromString:[[_day stringFromChildNamed:@"date"] stringByReplacingOccurrencesOfString:@"'" withString:@""]] forKey:@"date"];
					[df release];
					NSMutableArray* _receipts = [[NSMutableArray alloc] init];		//<2
					NSArray* _day_receipts_nodes = [_day nodesForXPath:@"./receipts/receipt" error:nil];
					for (CXMLElement* _receipt_node in _day_receipts_nodes) {
						NSMutableDictionary* _receipt = [[NSMutableDictionary alloc] init];	//<3
						
						[_receipt setObject:[_receipt_node stringFromChildNamed:@"current_balance"] forKey:@"current_balance"];
						[_receipt setObject:[_receipt_node stringFromChildNamed:@"earned_points"] forKey:@"earned_points"];
						[_receipt setObject:[_receipt_node stringFromChildNamed:@"spend_money"] forKey:@"spend_money"];
						[_receipt setObject:[_receipt_node stringFromChildNamed:@"fb_engagement_msg"] forKey:@"fb_engagement_msg"];
						[_receipt setObject:[_receipt_node stringFromChildNamed:@"receipt_text"] forKey:@"receipt_text"];
						[_receipt setObject:[_receipt_node stringFromChildNamed:@"receipt_type"] forKey:@"receipt_type"];
						[_receipt setObject:[_receipt_node stringFromChildNamed:@"transaction_id"] forKey:@"transaction_id"];
						[_receipt setObject:[_receipt_node stringFromChildNamed:@"date_time"] forKey:@"date_time"];
						[_receipt setObject:[_receipt_node stringFromChildNamed:@"place_name"] forKey:@"place_name"];
						[_receipt setObject:[_receipt_node stringFromChildNamed:@"brand_name"] forKey:@"brand_name"];
						[_receipt setObject:[_receipt_node stringFromChildNamed:@"currency_symbol"] forKey:@"currency_symbol"];
						[_receipt setObject:[_receipt_node stringFromChildNamed:@"brand_image_fb"] forKey:@"brand_image_fb"];
						[_receipt setObject:[_receipt_node stringFromChildNamed:@"customer_name"] forKey:@"customer_name"];
						[_receipt setObject:[_receipt_node stringFromChildNamed:@"customer_type"] forKey:@"customer_type"];
						[_receipt setObject:[_receipt_node stringFromChildNamed:@"customer_image_url"] forKey:@"customer_image_url"];
						
						
						// get engagements
						NSArray* _engs_nodes = [_receipt_node nodesForXPath:@"./engagements/engagement" error:nil];
						NSMutableArray* _engs = [[NSMutableArray alloc] init];		//<4
						for (CXMLElement* _eng_node in _engs_nodes) {
							NSMutableDictionary* _eng = [[NSMutableDictionary alloc] init];		//<5
							[_eng setObject:[_eng_node stringFromChildNamed:@"current_balance"] forKey:@"current_balance"];
							[_eng setObject:[_eng_node stringFromChildNamed:@"amount"] forKey:@"amount"];
							[_eng setObject:[_eng_node stringFromChildNamed:@"campaign_id"] forKey:@"campaign_id"];
							[_eng setObject:[_eng_node stringFromChildNamed:@"title"] forKey:@"title"];
							[_eng setObject:[_eng_node stringFromChildNamed:@"quantity"] forKey:@"quantity"];
							[_engs addObject:_eng];
							
							[_eng release];		//>5
						}
						[_receipt setObject:_engs forKey:@"engagements"];
						[_engs release];	//>4
						[_receipts addObject:_receipt];		// add the receipt to the list of receipts
						[_receipt release];		//>3
					}
					[day_info setObject:_receipts forKey:@"receipts"];	// add the receipts to the day info
					[_receipts release];			//>2
					[days addObject:day_info];	// add the day info to the days
					[day_info release];			//>1
				}
//			}
			[self.delegate gotCashierReceipts:days];
			
		} else if (theRequest.identifier == CUSTOMER_REQUEST) {
			NSArray* _nodes = [_document nodesForXPath:@"/customer_receipts/receipt" error:nil];
			
			//////////////TODO cashier receit history
			NSMutableArray* receipts = [[[NSMutableArray alloc] init] autorelease];		//<> 0
			

			for (CXMLElement* _receipt_node in _nodes) {
				NSLog(@"Loop....");
				NSMutableDictionary* _receipt = [[NSMutableDictionary alloc] init];	//<1
				
				[_receipt setObject:[_receipt_node stringFromChildNamed:@"current_balance"] forKey:@"current_balance"];
				[_receipt setObject:[_receipt_node stringFromChildNamed:@"earned_points"] forKey:@"earned_points"];
				[_receipt setObject:[_receipt_node stringFromChildNamed:@"spend_money"] forKey:@"spend_money"];
				[_receipt setObject:[_receipt_node stringFromChildNamed:@"fb_engagement_msg"] forKey:@"fb_engagement_msg"];
				[_receipt setObject:[_receipt_node stringFromChildNamed:@"receipt_text"] forKey:@"receipt_text"];
				[_receipt setObject:[_receipt_node stringFromChildNamed:@"receipt_type"] forKey:@"receipt_type"];
				[_receipt setObject:[_receipt_node stringFromChildNamed:@"transaction_id"] forKey:@"transaction_id"];
				[_receipt setObject:[_receipt_node stringFromChildNamed:@"date_time"] forKey:@"date_time"];
				[_receipt setObject:[_receipt_node stringFromChildNamed:@"place_name"] forKey:@"place_name"];
				[_receipt setObject:[_receipt_node stringFromChildNamed:@"brand_name"] forKey:@"brand_name"];
				[_receipt setObject:[_receipt_node stringFromChildNamed:@"currency_symbol"] forKey:@"currency_symbol"];
				[_receipt setObject:[_receipt_node stringFromChildNamed:@"brand_image_fb"] forKey:@"brand_image_fb"];
				
				
				// get engagements
				NSArray* _engs_nodes = [_receipt_node nodesForXPath:@"./engagements/engagement" error:nil];
				NSMutableArray* _engs = [[NSMutableArray alloc] init];		//<2
				for (CXMLElement* _eng_node in _engs_nodes) {
					NSMutableDictionary* _eng = [[NSMutableDictionary alloc] init];		//<3
					[_eng setObject:[_eng_node stringFromChildNamed:@"current_balance"] forKey:@"current_balance"];
					[_eng setObject:[_eng_node stringFromChildNamed:@"amount"] forKey:@"amount"];
					[_eng setObject:[_eng_node stringFromChildNamed:@"title"] forKey:@"title"];
					[_eng setObject:[_eng_node stringFromChildNamed:@"quantity"] forKey:@"quantity"];
					[_engs addObject:_eng];
					
					[_eng release];		//>3
				}
				[_receipt setObject:_engs forKey:@"engagements"];
				[_engs release];	//>2
				[receipts addObject:_receipt];		// add the receipt to the list of receipts
				[_receipt release];		//>1
			}

			NSLog(@"1:           %d", [receipts count]);
			[self.delegate gotCustomerReceipts:receipts];
			
		}
		[theRequest release];
	}@catch (NSException * e) {
		NSLog(@"%@", [e description]);
		[self KZURLRequest:theRequest didFailWithError:nil];
	}
}

- (void) dealloc {
	
	[super dealloc];
}


+ (void) setDelegate:(id<KZReceiptHistoryDelegate>)_delegate {
	if (shared == nil) {
		shared = [[KZReceiptHistory alloc] init];
	}
	shared.delegate = _delegate;
}


+ (void) getCustomerReceiptsForBusinessId:(NSString*)_biz_id andDelegate:(id<KZReceiptHistoryDelegate>)_delegate {
	[KZReceiptHistory setDelegate:_delegate];
	NSMutableDictionary *_headers = [[NSMutableDictionary alloc] init];
	[_headers setValue:@"application/xml" forKey:@"Accept"];
	KZURLRequest* req = [[KZURLRequest alloc] initRequestWithString:[NSString stringWithFormat:@"%@/users/receipts/receipts-customer.xml?business_id=%@&auth_token=%@", 
												 API_URL, _biz_id, [KZUserInfo shared].auth_token]
									  andParams:nil 
									   delegate:shared 
										headers:_headers 
							  andLoadingMessage:@"Loading..."];
	req.identifier = CUSTOMER_REQUEST;
	[_headers release];
}


+ (void) getCashierReceipts:(id<KZReceiptHistoryDelegate>)_delegate andDaysCount:(NSUInteger)_num_of_days {
	[KZReceiptHistory setDelegate:_delegate];
	NSMutableDictionary *_headers = [[NSMutableDictionary alloc] init];
	[_headers setValue:@"application/xml" forKey:@"Accept"];
	KZURLRequest* req = [[KZURLRequest alloc] initRequestWithString:[NSString stringWithFormat:@"%@/users/cashiers/receipts-merchant.xml?auth_token=%@&no_of_days=%d", 
												 API_URL, [KZUserInfo shared].auth_token, _num_of_days]
									  andParams:nil 
									   delegate:shared 
										headers:_headers 
							  andLoadingMessage:@"Loading..."];
	req.identifier = CASHIER_REQUEST;
	[_headers release];
}

@end
