//
//  KZOpenHours.m
//  Cashbury
//
//  Created by Basayel Said on 5/4/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import "KZOpenHours.h"


@implementation KZOpenHours

@synthesize day, from_time, to_time;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (id) initWithDay:(NSString*)_day andFromTime:(NSString*)_from_time andToTime:(NSString*)_to_time {
		if (self = [super init]) {
			day = [_day retain];
			from_time = [_from_time retain];
			to_time = [_to_time retain];
			return self;
		}
}
/*
- (void) dealloc {
	NSLog(@"DEALLOCED...");
	[super dealloc];
}
*/
@end
