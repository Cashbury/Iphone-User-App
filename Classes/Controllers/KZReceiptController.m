//
//  KZReceiptController.m
//  Cashbery
//
//  Created by Basayel Said on 8/9/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import "KZReceiptController.h"
#import "KZSpendReceiptViewController.h"
#import "CXMLElement+Helpers.h"
#import "TouchXML.h"
#import "KZApplication.h"
#import "KZUserInfo.h"
#import "KZAccount.h"


@implementation KZReceiptController

static KZReceiptController* shared = nil;

@synthesize queue, delegate;

 
+ (void) getAllReceiptsWithDelegate:(id<KZReceiptsDelegate>)_delegate {
	if (shared == nil) {
		shared = [[KZReceiptController alloc] init];
		shared.queue = [[[NSMutableArray alloc] init] autorelease];
	}
	shared.delegate = _delegate;

	NSMutableDictionary *_headers = [[NSMutableDictionary alloc] init];
	[_headers setValue:@"application/xml" forKey:@"Accept"];
	KZURLRequest* req = [[KZURLRequest alloc] initRequestWithString:
						 [NSString stringWithFormat:@"%@/users/receipts/pending-receipts.xml?auth_token=%@", 
						  API_URL, [KZUserInfo shared].auth_token]
														  andParams:nil delegate:shared headers:_headers andLoadingMessage:@"Loading..."];
	[_headers release];
}


- (void) KZURLRequest:(KZURLRequest *)theRequest didFailWithError:(NSError*)theError {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Sorry a server error has occurred. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alert show];
	[alert release];
	[theRequest release];
}

- (void) KZURLRequest:(KZURLRequest *)theRequest didSucceedWithData:(NSData*)theData {
	CXMLDocument *_document = [[[CXMLDocument alloc] initWithData:theData options:0 error:nil] autorelease];
	NSLog([_document description]);
	NSArray *_nodes = [_document nodesForXPath:@"//receipts/receipt" error:nil];
	KZSpendReceiptViewController* receipt;
	for (CXMLElement *_node in _nodes) {
		KZBusiness* biz = [KZBusiness getBusinessWithIdentifier:[_node stringFromChildNamed:@"business-id"] 
														andName:[_node stringFromChildNamed:@"brand-name"] 
													andImageURL:nil];
		
		// update spend based account balance
		NSNumber * new_balance = [NSNumber numberWithFloat:[[_node stringFromChildNamed:@"current-balance"] floatValue]];
		[KZAccount updateAccountBalance:new_balance withCampaignId:[_node stringFromChildNamed:@"campaign-id"]];
		
		
		receipt = [[KZSpendReceiptViewController alloc] initWithBusiness:biz
																  amount:[_node stringFromChildNamed:@"spend-money"]
														 currency_symbol:[_node stringFromChildNamed:@"currency-symbol"] 
															   date_time:[_node stringFromChildNamed:@"date-time"] 
															  place_name:[_node stringFromChildNamed:@"place-name"] 
															receipt_text:[_node stringFromChildNamed:@"receipt-text"] 
															receipt_type:[_node stringFromChildNamed:@"receipt-type"] 
														  transaction_id:[_node stringFromChildNamed:@"transaction-id"]];
		
		// fix the facebook message and replace the spend amount with the real spend amount
		NSString* fb_message = [_node stringFromChildNamed:@"fb-engagement-msg"];
		fb_message = [fb_message stringByReplacingOccurrencesOfString:@"{spend}" withString:[NSString stringWithFormat:@"%0.0lf", [[_node stringFromChildNamed:@"earned-points"] floatValue]]];
		
		
		[receipt setFacebookMessage:fb_message andIcon:[_node stringFromChildNamed:@"brand-image-fb"]];
		
		
		
		NSArray *engagements_nodes = [_node nodesForXPath:@"engagements/engagement" error:nil];
		for (CXMLElement* _eng in engagements_nodes) {
			// update buyX campaigns accounts balances
			NSNumber * eng_new_balance = [NSNumber numberWithFloat:[[_eng stringFromChildNamed:@"current-balance"] floatValue]];
			[KZAccount updateAccountBalance:eng_new_balance withCampaignId:[_eng stringFromChildNamed:@"campaign-id"]];
			
			[receipt addLineDetail:[NSString stringWithFormat:@"%@    Quantity:%0.0lf", 
									[_eng stringFromChildNamed:@"title"], 
									[[_eng stringFromChildNamed:@"quantity"] floatValue]]];
		}
		[self.queue enqueue:receipt];
		[receipt release];
	}
	if ([self.queue count] > 0) {
		[self.delegate gotReceipts];
	} else {
		[self.delegate noReceiptsFound];
		self.delegate = nil;
	}
	[theRequest release];
}

+ (KZSpendReceiptViewController*) getNextReceipt {
	KZSpendReceiptViewController* receipt = (KZSpendReceiptViewController*)[shared.queue dequeue];
	if (receipt == nil) {
		[shared.delegate noMoreReceipts];
		shared.delegate = nil;
	}
	return receipt;
}



@end
