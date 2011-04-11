//
//  NSMutableArray+Helper.m
//  Cashbury
//
//  Created by Basayel Said on 3/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSMutableArray+Helper.h"


@implementation NSMutableArray (Helper)


- (NSMutableArray *) initWithNulls:(NSUInteger) count {
	self = [self init];
	for (int i = 0; i < count; i++) {
		[self addObject:[NSNull null]];
	}
	return self;
}


@end
