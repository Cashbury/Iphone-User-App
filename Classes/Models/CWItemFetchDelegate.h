//
//  CWItemFetchDelegate.h
//  Cashbery
//
//  Created by Basayel Said on 7/18/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CWItemFetchDelegate

	- (void) gotItems:(NSArray*)_items;

	- (void) itemsFetchError:(NSString*)_error;

@end
