//
//  KZReceiptHistory.h
//  Cashbery
//
//  Created by Basayel Said on 8/18/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KZReceiptHistoryDelegate.h"
#import "KZURLRequest.h"

@interface KZReceiptHistory : NSObject <KZURLRequestDelegate> {
	
}

@property (nonatomic, assign) id<KZReceiptHistoryDelegate> delegate;

+ (void) getCustomerReceiptsForBusinessId:(NSString*)_biz_id andDelegate:(id<KZReceiptHistoryDelegate>)_delegate;
+ (void) getCashierReceipts:(id<KZReceiptHistoryDelegate>)_delegate andDaysCount:(NSUInteger)_num_of_days;

@end
