//
//  CardViewController.m
//  Cashbury
//
//  Created by Mrithula Ancy on 6/8/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#import "CardViewController.h"
#import "KZUserInfo.h"
#import "KZUtils.h"
#import "FileSaver.h"
#import "CBWalletSettingsViewController.h"
#import "KZCustomerReceiptHistoryViewController.h"


@interface CardViewController ()

@end

@implementation CardViewController
@synthesize userIconImage;
@synthesize usernameLabel;
@synthesize msgNotiIconImage;
@synthesize containerView;
@synthesize cardView;
@synthesize scrollView;
@synthesize lockButton;
@synthesize controlPanelView;
@synthesize pageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - CBMagnifiableViewControllerDelegate methods
- (void) dismissViewController:(CBMagnifiableViewController *)theController
{
    UIViewController *_controllerToRemove = theController;
    
    if (theController.navigationController)
    {
        _controllerToRemove = theController.navigationController;
    }
    
    [self diminishViewController:_controllerToRemove duration:0.35];
    
    [_controllerToRemove release];
}

#pragma mark - Scroll View
-(void)setScrollViewSize{
    [self.scrollView setContentSize:CGSizeMake(504.0, self.scrollView.frame.size.height)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //set usre name
    self.usernameLabel.text     =   [[KZUserInfo shared] getShortName];
    [self setScrollViewSize];
    
    //set msg icon
    CGSize labelSize            =   [self.usernameLabel.text sizeWithFont:self.usernameLabel.font];
    
    if (labelSize.width <= self.usernameLabel.frame.size.width) {
        
        self.msgNotiIconImage.frame     =   CGRectMake(self.usernameLabel.frame.origin.x+labelSize.width+5.0, self.msgNotiIconImage.frame.origin.y, self.msgNotiIconImage.frame.size.width, self.msgNotiIconImage.frame.size.height);
    }else {
        self.msgNotiIconImage.frame     =   CGRectMake(235.0, self.msgNotiIconImage.frame.origin.y, self.msgNotiIconImage.frame.size.width, self.msgNotiIconImage.frame.size.height);
    }
    
    // set icon image
    self.userIconImage.contentMode              =   UIViewContentModeScaleAspectFill;
    self.userIconImage.layer.masksToBounds      =   YES;
    self.userIconImage.layer.cornerRadius       =   5.0;
    self.userIconImage.layer.borderWidth        =   2.0;
    self.userIconImage.layer.borderColor        =   [UIColor whiteColor].CGColor;
    
    self.userIconImage.cropNorth                =   YES;
    
    NSString *_imagePath                        =   [FileSaver getFilePathForFilename:@"facebook_user_image"];
    
	if ([KZUtils isStringValid:_imagePath])
    {
		UIImage *_profileImage                  =   [UIImage imageWithContentsOfFile:_imagePath];
        
		self.userIconImage.image                =   _profileImage;
	}
    else
    {
        NSURL *_profileURL                      =   [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=normal", [KZUserInfo shared].facebookID]];
        [self.userIconImage loadImageWithAsyncUrl:_profileURL];
    }
    
    //set gestures
    UITapGestureRecognizer *gesture             =   [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(flipCard:)];
    [userIconImage addGestureRecognizer:gesture];
    [cardView addGestureRecognizer:gesture];
    [gesture release];
    
}

- (void)viewDidUnload
{
    [self setUserIconImage:nil];
    [self setUsernameLabel:nil];
    [self setMsgNotiIconImage:nil];
    [self setContainerView:nil];
    [self setCardView:nil];
    [self setScrollView:nil];
    [self setLockButton:nil];
    [self setControlPanelView:nil];
    [self setPageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)cpButtonsClicked:(id)sender {
    
    UIButton *cpButton  =   (UIButton*)sender;
    switch (cpButton.tag) {
        case 1://Accounts
        {
            CBWalletSettingsViewController *_controller = [[CBWalletSettingsViewController alloc] initWithNibName:@"CBWalletSettingsView" bundle:nil];
            _controller.delegate = self;
            
            [self magnifyViewController:_controller duration:0.35];
        }
            
            break;
        case 2://Flash
            
            break;
        case 3://receipts
        {
            KZCustomerReceiptHistoryViewController *_controller = [[KZCustomerReceiptHistoryViewController alloc] initWithNibName:@"KZCustomerReceiptHistoryView" bundle:nil];
            _controller.delegate = self;
            
            [self magnifyViewController:_controller duration:0.35];
        }
            
            break;
        case 4://Send
            
            break;
        case 5:// lock
            
            break;
        case 6://request
            
            break;
        case 7://how to
            
            break;
        case 8://support
            
            break;
        case 9://notifications
            
            break;
        case 10://share
            
            break;           
            
        default:
            break;
    }
}

- (IBAction)flipCard:(id)sender {
    
    if ([cardView isHidden]) {
        // show card view
        [UIView transitionWithView:self.containerView duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            self.cardView.hidden            =   FALSE;
            self.controlPanelView.hidden    =   TRUE;
        }completion:^(BOOL finished){
        }];
    }else{
        //show cp
        [UIView transitionWithView:self.containerView duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            self.cardView.hidden            =   TRUE;
            self.controlPanelView.hidden    =   FALSE;
        }completion:^(BOOL finished){
        }];
        
    }
}

- (IBAction)goBack:(id)sender {
    [self diminishViewController:self duration:0.35];
}
#pragma mark - ScrollView delegate


-(void)scrollViewDidEndDragging:(UIScrollView *)mscrollView willDecelerate:(BOOL)decelerate{
    
    if (self.scrollView.contentOffset.x < self.scrollView.frame.size.width) {
        [self.pageView setCurrentPage:0];
    }else {
        [self.pageView setCurrentPage:1]; 
    }   
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)mscrollView{
    if (self.scrollView.contentOffset.x < self.scrollView.frame.size.width) {
        [self.pageView setCurrentPage:0];
    }else {
        [self.pageView setCurrentPage:1];
    }
}

- (void)dealloc {
    [userIconImage release];
    [usernameLabel release];
    [msgNotiIconImage release];
    [containerView release];
    [cardView release];
    [scrollView release];
    [lockButton release];
    [controlPanelView release];
    [pageView release];
    [super dealloc];
}
@end
