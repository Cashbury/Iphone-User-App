//
//  NSMutableArray+Queue.h
//  Cashbery
//
//  Created by Basayel Said on 8/9/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSMutableArray (Queue)

- (id) dequeue;

- (void) enqueue:(id)entry;

@end
