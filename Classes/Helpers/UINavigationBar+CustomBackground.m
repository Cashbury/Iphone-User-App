//
//  UINavigationBar+CustomBackground.m
//  KVRapidBrowser
//
//  Created by Rami on 29/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UINavigationBar+CustomBackground.h"


@implementation UINavigationBar (CustomNavBar)

+ (void) setCustomBackgroundImage
{
    // Only works in iOS5
    if([self instancesRespondToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        UIImage *_background = [UIImage imageNamed:@"navbar-background.png"];
        [[self appearance] setBackgroundImage:_background forBarMetrics:UIBarMetricsDefault];    
    }
}

- (void) drawRect:(CGRect)theRect
{
    UIImage *_background = [UIImage imageNamed:@"navbar-background.png"];
    [_background drawInRect:theRect];
}

@end
