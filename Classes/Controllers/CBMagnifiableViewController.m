//
//  CBMagnifiableViewController.m
//  Cashbury
//
//  Created by Rami Khawandi on 5/1/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#import "CBMagnifiableViewController.h"

@implementation UIViewController (CBMagnifiableViewController)

- (void) magnifyViewController:(CBMagnifiableViewController *)theViewController duration:(NSTimeInterval)theDuration
{
    UIView *_v = theViewController.view;
    CGRect _frame = _v.frame;
    
    theViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	theViewController.view.frame = CGRectMake(0, 0,  _frame.size.width, _frame.size.height);
    
    [self.view insertSubview:_v atIndex:1];
	[self.view bringSubviewToFront:_v];
    
    _v.transform = CGAffineTransformMakeScale(0.1, 0.1);
    _v.alpha = 0;
    
    [UIView animateWithDuration:theDuration
                     animations:^{
                         CGAffineTransform transformBig = CGAffineTransformMakeScale(1, 1);
                         transformBig = CGAffineTransformTranslate(transformBig, 0, 0);	
                         _v.transform = transformBig;
                         
                         _v.alpha = 1;
                     }
                     completion:^(BOOL finished){
                     }];
}

- (void) diminishViewController:(CBMagnifiableViewController *)theViewController duration:(NSTimeInterval)theDuration
{
    UIView *_v = theViewController.view;
    
    theViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    _v.transform = CGAffineTransformMakeScale(1, 1);
    _v.alpha = 1;
    
   	[UIView animateWithDuration:theDuration
                     animations:^{
                         CGAffineTransform transformBig = CGAffineTransformMakeScale(0.1, 0.1);
                         transformBig = CGAffineTransformTranslate(transformBig, 0, 0);	
                         _v.transform = transformBig;
                         
                         _v.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         [_v removeFromSuperview];
                     }];
}

@end

@implementation CBMagnifiableViewController

@synthesize delegate;

- (IBAction) didTapToCloseView:(id)theSender
{
    [self.delegate dismissViewController:self];
}
@end
