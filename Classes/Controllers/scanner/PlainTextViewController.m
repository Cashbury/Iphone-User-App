//
//  PlainTextViewController.m
//  Cashbury
//
//  Created by Mrithula Ancy on 7/9/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#import "PlainTextViewController.h"

@interface PlainTextViewController ()

@end

@implementation PlainTextViewController
@synthesize barImgView;
@synthesize containerView;
@synthesize titleLabel;
@synthesize plainTextView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)showContainerView{
    self.containerView.frame        =   CGRectMake(self.containerView.frame.origin.x, 480.0, self.containerView.frame.size.width, self.containerView.frame.size.height);
    [UIView animateWithDuration:0.5 animations:^{
        self.containerView.hidden    =   FALSE;
        self.containerView.frame    =   CGRectMake(self.containerView.frame.origin.x, 6.0, self.containerView.frame.size.width, self.containerView.frame.size.height);
    }completion:^(BOOL f){
        self.barImgView.highlighted     =   TRUE;
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self performSelector:@selector(showContainerView) withObject:nil afterDelay:0.5];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setBarImgView:nil];
    [self setContainerView:nil];
    [self setTitleLabel:nil];
    [self setPlainTextView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [barImgView release];
    [containerView release];
    [titleLabel release];
    [plainTextView release];
    [super dealloc];
}
- (IBAction)goBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:TRUE];
}
@end
