//
//  CBSavings.h
//  Cashbury
//
//  Created by Rami on 24/1/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KZURLRequest.h"

/**
 * Fired when the total savings are updated.
 *
 * The object carried in the NSNotification is an NSNumber
 * with a float value of the total savings.
 */
extern NSString * const CBTotalSavingsUpdateNotification;

@interface CBSavings : NSObject <KZURLRequestDelegate>
{
    NSNumber *totalSavings;
}

+ (CBSavings *) sharedInstance;

/**
 * Returns the current value of the total savings and triggers
 * an update. An CBTotalSavingsUpdateNotification is posted when
 * the value is updated.
 */
- (NSNumber *) totalSavings;

@end
