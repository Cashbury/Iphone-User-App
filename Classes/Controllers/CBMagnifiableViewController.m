//
//  CBMagnifiableViewController.m
//  Cashbury
//
//  Created by Rami Khawandi on 5/1/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#import "CBMagnifiableViewController.h"

@implementation CBMagnifiableViewController

@synthesize delegate;

- (IBAction) didTapToCloseView:(id)theSender
{
    [self.delegate dismissViewController:self];
}
@end
