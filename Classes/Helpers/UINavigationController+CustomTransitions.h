//
//  UINavigationController+CustomTransitions.h
//  NewspaperApp
//
//  Created by Rami on 5/4/11.
//  Copyright 2011 Knowledgeview Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface UINavigationController (CustomTransitions)

- (void) pushViewController:(UIViewController *)theViewController transitionType:(NSString *)theType transitionSubType:(NSString *)theSubType duration:(float)theDuration;
- (UIViewController *) popViewControllerUsingTransition:(NSString *)theTransition transitionSubType:(NSString *)theSubType duration:(float)theDuration;

@end