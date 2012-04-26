//
//  CBGoToViewController.m
//  Cashbury
//
//  Created by jayanth S on 4/25/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#import "CBGoToViewController.h"

@interface CBGoToViewController ()

@end

@implementation CBGoToViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)goBack:(id)sender {
    [self diminishViewController:self duration:0.35f];
}
@end
