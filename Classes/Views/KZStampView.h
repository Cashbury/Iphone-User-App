//
//  KZStampView.h
//  Kazdoor
//
//  Created by Rami on 7/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NAMultiColumnView;

@interface KZStampView : UIView
{
}

@property (readonly, assign) BOOL hasCompletedStamps;
@property (readonly, assign) NSUInteger numberOfStamps;
@property (nonatomic, assign) NSUInteger numberOfCollectedStamps;

- (id) initWithFrame:(CGRect)theFrame numberOfStamps:(NSUInteger)theStamps numberOfCollectedStamps:(NSUInteger)theCollectedStamps;

@end
