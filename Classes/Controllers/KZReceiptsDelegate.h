//
//  KZReceiptsDelegate.h
//  Cashbery
//
//  Created by Basayel Said on 8/10/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol KZReceiptsDelegate

- (void) gotReceipts;
- (void) noReceiptsFound;
- (void) noMoreReceipts;

@end
