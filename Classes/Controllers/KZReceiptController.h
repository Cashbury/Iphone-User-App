//
//  KZReceiptController.h
//  Cashbery
//
//  Created by Basayel Said on 8/9/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSMutableArray+Queue.h"
#import "KZReceiptsDelegate.h"
#import "KZSpendReceiptViewController.h"
#import "KZURLRequest.h"

@interface KZReceiptController : NSObject <KZURLRequestDelegate> {
	
}

@property (nonatomic, retain) NSMutableArray* queue;
@property (nonatomic, retain) id<KZReceiptsDelegate> delegate;

+ (void) getAllReceiptsWithDelegate:(id<KZReceiptsDelegate>)_delegate;

+ (KZSpendReceiptViewController*) getNextReceipt;

@end
