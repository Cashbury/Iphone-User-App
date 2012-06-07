//
//  ScannerHistoryViewController.m
//  Cashbury
//
//  Created by Mrithula Ancy on 5/9/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#import "ScannerHistoryViewController.h"
#import "PlayViewController.h"

@interface ScannerHistoryViewController ()

@end

@implementation ScannerHistoryViewController

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
    self.navigationController.navigationBar.hidden  =   TRUE;
    
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

- (IBAction)goBackToScanner:(id)sender {
    [self.navigationController popViewControllerAnimated:TRUE];
}
@end
