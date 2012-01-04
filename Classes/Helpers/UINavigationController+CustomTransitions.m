//
//  UINavigationController+CustomTransitions.m
//  NewspaperApp
//
//  Created by Rami on 5/4/11.
//  Copyright 2011 Knowledgeview Ltd. All rights reserved.
//

#import "UINavigationController+CustomTransitions.h"

//------------------------------------
// Category methods
//------------------------------------
#pragma mark - Category methods

@implementation UINavigationController (CustomTransitions)

- (void) pushViewController:(UIViewController *)theViewController
             transitionType:(NSString *)theType
          transitionSubType:(NSString *)theSubType
                   duration:(float)theDuration
{
    UIViewController *_vc = [theViewController retain];
    
    CATransition *_transition = [CATransition animation];
    _transition.duration = theDuration;
    _transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    _transition.type = theType;
    _transition.subtype = theSubType;
    
    [self.view.layer addAnimation:_transition forKey:kCATransition];
    
    [self pushViewController:_vc animated:NO];
    
    [_vc release];
}

- (UIViewController *) popViewControllerUsingTransition:(NSString *)theTransition
                                      transitionSubType:(NSString *)theSubType
                                               duration:(float)theDuration
{
    CATransition *_transition = [CATransition animation];
    _transition.duration = theDuration;
    _transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    _transition.type = theTransition;
    _transition.subtype = theSubType;
    
    [self.view.layer addAnimation:_transition forKey:kCATransition];
    
    return [self popViewControllerAnimated:NO];
}

@end
