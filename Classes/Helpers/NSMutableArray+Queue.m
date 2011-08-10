//
//  NSMutableArray+Queue.m
//  Cashbery
//
//  Created by Basayel Said on 8/9/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import "NSMutableArray+Queue.h"

/**
 Not thread safe
 */
@implementation NSMutableArray (Queue)

- (id) dequeue {
	id headObject;
	@synchronized(self) {
		if ([self count] == 0) return nil; // to avoid raising exception (Quinn)
		headObject = [self objectAtIndex:0];
		if (headObject != nil) {
			[[headObject retain] autorelease]; // so it isn't dealloc'ed on remove
			[self removeObjectAtIndex:0];
		}
	}
    return headObject;
}

// Add to the tail of the queue (no one likes it when people cut in line!)
- (void) enqueue:(id)entry {
	@synchronized(self) {
		[self addObject:entry];
	}
}

@end
