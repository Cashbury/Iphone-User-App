//
//  UIViewController+CBMaginfyViewController.h
//  Cashbury
//
//  Created by Rami Khawandi on 5/1/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (CBMaginfyViewController)
- (void) magnifyViewController:(UIViewController *)theViewController duration:(NSTimeInterval)theDuration;
- (void) diminishViewController:(UIViewController *)theViewController duration:(NSTimeInterval)theDuration;
@end
