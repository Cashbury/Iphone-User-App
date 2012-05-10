//
//  ReceiptViewController.m
//  Cashbury
//
//  Created by jayanth S on 5/9/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#import "ReceiptViewController.h"


@interface ReceiptViewController ()

@end

@implementation ReceiptViewController
@synthesize qrCodeLabel;
@synthesize qrCode;

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
    [self.qrCodeLabel setText:self.qrCode];

    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setQrCodeLabel:nil];
    [self setQrCode:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [qrCodeLabel release];
    [qrCodeLabel release];
    [super dealloc];
}
- (IBAction)doneButtonClicked:(id)sender {
    [self diminishViewController:self duration:0.35f];
}
@end
