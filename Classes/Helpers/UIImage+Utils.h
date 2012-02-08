//
//  UIImage+Utils.h
//  Cashbury
//
//  Created by Rami Khawandi on 4/11/11.
//  Copyright (c) 2011 __MyCompanyName__ Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Utils)

- (UIImage *) imageByScalingProportionallyToFillSize:(CGSize)theSize upscale:(BOOL)shouldUpscale;

@end
