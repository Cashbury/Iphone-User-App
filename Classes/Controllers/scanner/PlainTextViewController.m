//
//  PlainTextViewController.m
//  Cashbury
//
//  Created by Mrithula Ancy on 6/21/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#import "PlainTextViewController.h"

@interface PlainTextViewController ()

@end

@implementation PlainTextViewController
@synthesize titleLabel;
@synthesize plainTextLabel,plainText,titleString;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self plainTextLabel] setText:plainText];
    [self.titleLabel setText:titleString];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setTitleLabel:nil];
    [self setPlainTextLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [titleLabel release];
    [plainTextLabel release];
    [plainText release];
    [titleString release];
    [super dealloc];
}
- (IBAction)goBack:(id)sender {
    
     [self.navigationController popViewControllerAnimated:TRUE];
}
@end
