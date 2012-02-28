//
//  CBMultiTaskingNavigationController.m
//  Cashbury
//
//  Created by Rami on 28/2/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#import "KazdoorAppDelegate.h"
#import "CBMultiTaskingNavigationController.h"

@implementation CBMultiTaskingNavigationController

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(becameActive:) 
                                                 name:CashburyApplicationDidBecomeActive 
                                               object:nil];
}

- (void) viewDidUnload
{
    [super viewDidUnload];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CashburyApplicationDidBecomeActive object:nil];
}

- (void) viewDidBecomeActive
{
    
}

- (void) becameActive:(NSNotification *)theNotification
{
    if(self.view.superview)
    {
        [self viewDidBecomeActive];
    }
}

@end
