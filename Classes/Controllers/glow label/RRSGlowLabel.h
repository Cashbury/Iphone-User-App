//
//  RRSGlowLabel.h
//  TextGlowDemo
//
//  Created by QuintetSolutions on 7/05/2011.
//  Copyright 2010 QuintetSolutions. All rights reserved.
//


@interface RRSGlowLabel : UILabel {
    CGSize glowOffset;
    UIColor *glowColor;
    CGFloat glowAmount;

    CGColorSpaceRef colorSpaceRef;
    CGColorRef glowColorRef;
}

@property (nonatomic, assign) CGSize glowOffset;
@property (nonatomic, assign) CGFloat glowAmount;
@property (nonatomic, retain) UIColor *glowColor;

@end
