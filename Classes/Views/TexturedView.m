//
//  TexturedView.m
//  Cashbury
//
//  Created by Basayel Said on 3/15/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import "TexturedView.h"


@implementation TexturedView


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		UIImage *backgroundTile = [UIImage imageNamed: @"button-snap.png"];
		UIColor *backgroundPattern = [[UIColor alloc] initWithPatternImage:backgroundTile];
		[self setBackgroundColor:backgroundPattern];
		[backgroundPattern release];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    [super dealloc];
}


@end
