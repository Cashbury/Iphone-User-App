//
//  KZReceiptHistoryDelegate.h
//  Cashbery
//
//  Created by Basayel Said on 8/18/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol KZReceiptHistoryDelegate

	/**
	 Returns an array wit this form
	 [																		0
		{																	1
			"date": "yyyy-MM-dd", 
			"receipts": 
			[																2
				 {															3
					"current_balance": X, 
					"earned_points": X, 
					"spend_money": X, 
					"fb_engagement_msg": X, 
					"receipt_text": X, 
					"receipt_type": X, 
					"transaction_id": X, 
					"date_time": X, 
					"place_name": X, 
					"brand_name": X, 
					"currency_symbol": X, 
					"brand_image_fb": X, 
					"customer_name": X, 
					"customer_type": X, 
					"customer_image_url": X,
					"engagements": 
					[														4
						{													5
							"current_balance": X, 
							"amount": X, 
							"campaign_id": X, 
							"title": X, 
							"quantity": X
						}
					]
				 }
			 ]
		}, 
	 ...
	 ]
	 */
	- (void) gotCashierReceipts:(NSMutableArray*)_receipts;
	/*
	 [																2
		 {															3
			 "current_balance": X, 
			 "earned_points": X, 
			 "spend_money": X, 
			 "fb_engagement_msg": X, 
			 "receipt_text": X, 
			 "receipt_type": X, 
			 "transaction_id": X, 
			 "date_time": X, 
			 "place_name": X, 
			 "brand_name": X, 
			 "currency_symbol": X, 
			 "brand_image_fb": X, 
			 "customer_name": X, 
			 "customer_type": X, 
			 "customer_image_url": X,
			 "engagements": 
			 [														4
				 {													5
					 "current_balance": X, 
					 "amount": X, 
					 "campaign_id": X, 
					 "title": X, 
					 "quantity": X
				 }
			 ]
		 }
	 ]
	 */
	- (void) gotCustomerReceipts:(NSMutableArray*)_receipts;

	- (void) noReceiptsFound;

@end
