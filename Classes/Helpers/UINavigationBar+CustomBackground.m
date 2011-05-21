//
//  UINavigationBar+CustomBackground.m
//  KVRapidBrowser
//
//  Created by Rami on 29/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UINavigationBar+CustomBackground.h"


@implementation UINavigationBar (CustomNavBar)

- (void) drawRect:(CGRect)theRect
{
    UIImage *_background = [UIImage imageNamed:@"navbar-background.png"];
    [_background drawInRect:theRect];
}

@end
