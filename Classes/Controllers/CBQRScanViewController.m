//
//  CBQRScanViewController.m
//  Cashbury
//
//  Created by ramikhawandi on 21/3/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#import "CBQRScanViewController.h"
#import "KZApplication.h"

@implementation CBQRScanViewController

@synthesize typeLabel, descriptionLabel, actionButton;

- (void) viewDidUnload
{
    [super viewDidUnload];
    
    self.typeLabel = nil;
    self.descriptionLabel = nil;
    self.actionButton = nil;
}

- (void) dealloc
{
    [typeLabel release];
    [descriptionLabel release];
    [actionButton release];
    
    [super dealloc];
}

- (IBAction) didTapClear:(id)theSender
{
    UINavigationController *nav = [KZApplication getAppDelegate].navigationController;
    [nav dismissModalViewControllerAnimated:YES];
}

- (IBAction) didTapAction:(id)theSender
{
    if ([typeLabel.text isEqualToString:@"URL"])
    {
        NSURL *_webURL = [NSURL URLWithString:descriptionLabel.text];
        [[UIApplication sharedApplication] openURL:_webURL];
    }
    else
    {
        NSString *_phoneURLString = [NSString stringWithFormat:@"tel:%@", descriptionLabel.text];
        NSURL *_phoneURL = [NSURL URLWithString:_phoneURLString];
        [[UIApplication sharedApplication] openURL:_phoneURL];
    }
}

@end
