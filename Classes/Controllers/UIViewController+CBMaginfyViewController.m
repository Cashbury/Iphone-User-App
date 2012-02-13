//
//  UIViewController+CBMaginfyViewController.m
//  Cashbury
//
//  Created by Rami Khawandi on 5/1/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#import "UIViewController+CBMaginfyViewController.h"

@implementation UIViewController (CBMaginfyViewController)

- (void) magnifyViewController:(UIViewController *)theViewController duration:(NSTimeInterval)theDuration
{
    UIView *_v = theViewController.view;
    
    theViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	theViewController.view.frame = CGRectMake(0, 0,  self.view.frame.size.width, self.view.frame.size.height);
    
    [self.view insertSubview:_v atIndex:1];
	[self.view bringSubviewToFront:_v];
    
    _v.transform = CGAffineTransformMakeScale(0.1, 0.1);
    _v.alpha = 0;
    
    BOOL _isAnimated = (theDuration > 0);
    
    if (!IS_IOS_5_OR_NEWER)
    {
        [theViewController viewWillAppear:_isAnimated];
    }
    
    [UIView animateWithDuration:theDuration
                     animations:^{
                         CGAffineTransform transformBig = CGAffineTransformMakeScale(1, 1);
                         transformBig = CGAffineTransformTranslate(transformBig, 0, 0);	
                         _v.transform = transformBig;
                         
                         _v.alpha = 1;
                     }
                     completion:^(BOOL finished){
                         
                         if (!IS_IOS_5_OR_NEWER)
                         {
                             [theViewController viewDidAppear:_isAnimated];
                         }
                     }];
}

- (void) diminishViewController:(UIViewController *)theViewController duration:(NSTimeInterval)theDuration
{
    UIView *_v = theViewController.view;
    
    theViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    _v.transform = CGAffineTransformMakeScale(1, 1);
    _v.alpha = 1;
    
    BOOL _isAnimated = (theDuration > 0);
    
    if (!IS_IOS_5_OR_NEWER)
    {
        [theViewController viewWillDisappear:_isAnimated];
    }
    
   	[UIView animateWithDuration:theDuration
                     animations:^{
                         CGAffineTransform transformBig = CGAffineTransformMakeScale(0.1, 0.1);
                         transformBig = CGAffineTransformTranslate(transformBig, 0, 0);	
                         _v.transform = transformBig;
                         
                         _v.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         if (!IS_IOS_5_OR_NEWER)
                         {
                             [theViewController viewDidDisappear:_isAnimated];
                         }
                         
                         [_v removeFromSuperview];
                     }];
}

@end
