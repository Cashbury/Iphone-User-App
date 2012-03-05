//
//  KZCardsAtPlacesViewController.m
//  Cashbery
//
//  Created by Basayel Said on 6/26/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import "KZCardsAtPlacesViewController.h"
#import "KZUserIDCardViewController.h"
#import "CBWalletSettingsViewController.h"
#import "UINavigationController+CustomTransitions.h"
#import "KZApplication.h"
#import "CBCitySelectorViewController.h"
#import "KZUserInfo.h"
#import "FileSaver.h"
#import "CBSavings.h"
#import "KZCustomerReceiptHistoryViewController.h"
#import "CBMessagesViewController.h"
#import "CBGiftsViewController.h"
#import "QREncoder.h"
#import "CBTipperTableCell.h"

@interface KZCardsAtPlacesViewController (PrivateMethods)
- (void) setBalanceLabelValue:(NSNumber *)theBalance;
- (void) setTip:(float)theTip;
- (void) updateQRImage;
@end

@implementation KZCardsAtPlacesViewController

@synthesize cardContainer, frontCard, backCard, qrCard, frontCardBackground, customerName, profileImage, savingsBalance;
@synthesize qrCardTitleImage, tipperView, qrImage, tipperTable, tipDescription, doneButton;

//------------------------------------
// Init & dealloc
//------------------------------------
#pragma mark - Init & dealloc

- (void) dealloc
{
    [cardContainer release];
    [frontCard release];
    [backCard release];
    [qrCard release];
    
    [qrCardTitleImage release];
    [tipperView release];
    [qrImage release];
    [tipperTable release];
    [tipDescription release];
    [doneButton release];
    
    [frontCardBackground release];
    [customerName release];
    [profileImage release];
    
    [savingsBalance release];
    
    [loadingView release];
    
    [super dealloc];
}

//------------------------------------
// View lifecycle
//------------------------------------
#pragma mark - View lifecycle

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    [self.backCard removeFromSuperview];
    [self.qrCard removeFromSuperview];
    
    // Wire up the gesture recognizer
    UITapGestureRecognizer *_controlTap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(flipCard:)] autorelease];
    UITapGestureRecognizer *_controlTap2 = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(flipCard:)] autorelease];
    
    [self.profileImage addGestureRecognizer:_controlTap];
    [self.customerName addGestureRecognizer:_controlTap2];
    
    UITapGestureRecognizer *_backgroundTap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showQRCode:)] autorelease];
    
    [self.frontCardBackground addGestureRecognizer:_backgroundTap];
    
    // Fill in the front card
    
    self.customerName.text  = [[KZUserInfo shared] getShortName];
    
    self.profileImage.contentMode = UIViewContentModeScaleAspectFill;
    self.profileImage.layer.masksToBounds = YES;
    self.profileImage.layer.cornerRadius = 5.0;
    self.profileImage.layer.borderWidth = 2.0;
    self.profileImage.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.profileImage.cropNorth = YES;
    
    NSString *_imagePath = [FileSaver getFilePathForFilename:@"facebook_user_image"];
    
	if ([KZUtils isStringValid:_imagePath])
    {
		UIImage *_profileImage = [UIImage imageWithContentsOfFile:_imagePath];
        
		self.profileImage.image = _profileImage;
	}
    else
    {
        NSURL *_profileURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=normal", [KZUserInfo shared].facebookID]];
        [self.profileImage loadImageWithAsyncUrl:_profileURL];
    }
    
    // Fill in the control panel
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUpdateTotalBalance:) name:CBTotalSavingsUpdateNotification object:nil];
    
    [self setBalanceLabelValue:[[CBSavings sharedInstance] totalSavings]];
    
    
    // Draw the done buton border
    self.doneButton.layer.borderWidth = 1.0f;
    self.doneButton.layer.borderColor = [UIColor grayColor].CGColor;
    self.doneButton.layer.cornerRadius = 5.0;
}

- (void) viewDidUnload
{
    self.frontCard = nil;
    self.backCard = nil;
    self.cardContainer = nil;
    self.qrCard = nil;
    
    self.qrCardTitleImage = nil;
    self.tipperView = nil;
    self.tipperTable = nil;
    self.tipDescription = nil;
    self.doneButton = nil;
    
    self.frontCardBackground = nil;
    self.customerName = nil;
    self.profileImage = nil;
    self.savingsBalance = nil;
    
    loadingView = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super viewDidUnload];
}

- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

//------------------------------------
// Private methods
//------------------------------------
#pragma mark - Private methods

- (void) setBalanceLabelValue:(NSNumber *)theBalance
{
    float _balance = [theBalance floatValue];
    
    self.savingsBalance.text = [NSString stringWithFormat:@"$%1.2f", _balance];
}

- (void) setTip:(float)theTip
{
    tip = theTip;
    
    NSInteger _tipPercentage = tip * 100;
    
    NSString *_tipDescription = (tip > 0) ? [NSString stringWithFormat:@"+ %d%% tip added", _tipPercentage] : @"set tip: no tip added";
    
    [self.tipDescription setTitle:_tipDescription forState:UIControlStateNormal];
    
    [self updateQRImage];
}

- (void) updateQRImage
{
    UIImage *_qrcodeImage = nil;
    
    if (userHashCode)
    {
        int _dimension = 180;
        
        NSString *_qrString = [NSString stringWithFormat:@"%@ t:%.0f%%", userHashCode, tip * 100];
        NSLog(@"%@", _qrString);
        
        DataMatrix *_qrMatrix = [QREncoder encodeWithECLevel:QR_ECLEVEL_AUTO version:QR_VERSION_AUTO string:_qrString];
        
        _qrcodeImage = [QREncoder renderDataMatrix:_qrMatrix imageDimension:_dimension];
    }
    
    self.qrImage.image = _qrcodeImage;
}

//------------------------------------
// Actions
//------------------------------------
#pragma mark - Actions

- (IBAction) didTapPlaces:(id)sender
{
    KZPlacesViewController *_controller = [[KZPlacesViewController alloc] initWithNibName:@"KZPlacesView" bundle:nil];
    UINavigationController *_b = [[UINavigationController alloc] initWithRootViewController:_controller];
    
    _controller.delegate = self;
    
    [self magnifyViewController:_b duration:0.35];
}

- (IBAction) showQRCode:(id)sender
{
    if ([frontCard superview])
    {
        // Request the ID card
        NSString *_requestString = [NSString stringWithFormat:@"%@/users/%@/get_id.xml?auth_token=%@", API_URL, nil, [KZUserInfo shared].auth_token];
        
        [[KZURLRequest alloc] initRequestWithString:_requestString
                                          andParams:nil 
                                           delegate:self
                                            headers:[NSDictionary dictionaryWithObject:@"application/xml" forKey:@"Accept"]
                                  andLoadingMessage:@"Loading..."];
        
        [self setTip:0];
        isTipping = NO;
        
        [self.tipperTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionBottom];
    }
    
    // Flip the views
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
    
    if ([frontCard superview])
    {
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.cardContainer cache:YES];
        
        [frontCard removeFromSuperview];
        [cardContainer addSubview:qrCard];
    }
    else
    {
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.cardContainer cache:YES];
        
        [qrCard removeFromSuperview];
        [cardContainer addSubview:frontCard];
    }
    
    [UIView commitAnimations];
}

- (IBAction) didTapSnap:(id)sender
{
    loadingView = [[UIViewController alloc] initWithNibName:@"CBLoadScanner" bundle:nil];
    
    [self magnifyViewController:loadingView duration:0.2];
    
    ZXingWidgetController* vc = [KZEngagementHandler snap];
    [KZEngagementHandler shared].delegate = self;
    
    if (IS_IOS_5_OR_NEWER)
    {
        [self presentViewController:vc animated:YES completion:nil];
    }
    else
    {
        [self presentModalViewController:vc animated:YES];
    }
}

- (IBAction) didTapNotifications:(id)sender
{
    
}

- (IBAction) didTapReceipts:(id)theSender
{
    KZCustomerReceiptHistoryViewController *_controller = [[KZCustomerReceiptHistoryViewController alloc] initWithNibName:@"KZCustomerReceiptHistoryView" bundle:nil];
    _controller.delegate = self;
    
    [self magnifyViewController:_controller duration:0.35];
}

- (void) didTapProfile:(id)sender
{
    CBWalletSettingsViewController *_controller = [[CBWalletSettingsViewController alloc] initWithNibName:@"CBWalletSettingsView" bundle:nil];
    _controller.delegate = self;
    
    [self magnifyViewController:_controller duration:0.35];
}

- (IBAction) didTapMessages:(id)theSender
{
    CBMessagesViewController *_controller = [[CBMessagesViewController alloc] initWithNibName:@"CBMessagesView" bundle:nil];
    _controller.delegate = self;
    
    [self magnifyViewController:_controller duration:0.35];
}

- (IBAction) didTapLoad:(id)theSender
{
    
}

- (IBAction) didTapGifts:(id)theSender
{
    CBGiftsViewController *_controller = [[CBGiftsViewController alloc] initWithNibName:@"CBGiftsView" bundle:nil];
    _controller.delegate = self;
    
    [self magnifyViewController:_controller duration:0.35];
}

- (void) didUpdatePlaces
{
	[KZApplication hideLoading];
}

- (void) didFailUpdatePlaces
{
	[KZApplication hideLoading];
}


- (IBAction) flipCard:(id)theSender
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
    
    if ([frontCard superview])
    {
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.cardContainer cache:YES];
        
        [frontCard removeFromSuperview];
        [cardContainer addSubview:backCard];
    }
    else
    {
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.cardContainer cache:YES];
        
        [backCard removeFromSuperview];
        [cardContainer addSubview:frontCard];
    }
    
    [UIView commitAnimations];
}

- (IBAction) didTapSupport:(id)theSender
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *_mailController = [[[MFMailComposeViewController alloc] init] autorelease];
        _mailController.mailComposeDelegate = self;
        
        [_mailController setToRecipients:[NSArray arrayWithObject:@"support@cashbury.com"]];
        [_mailController setSubject:@"Feedback"];
        
        [self presentModalViewController:_mailController animated:YES];
    }
}

- (void) didUpdateTotalBalance:(NSNotification *) theNotification
{
    NSNumber *_balanceNumber = (NSNumber *) [theNotification object];
    [self setBalanceLabelValue:_balanceNumber];
}

- (IBAction) didTapDoneButton:(id)theSender
{
    if (isTipping)
    {
        self.tipperView.hidden = YES;
        self.qrImage.hidden = NO;
        
        isTipping = NO;
    }
    else
    {
        [self showQRCode:theSender];
        
        // Prepare the QR code
    }
}

- (IBAction) didTapOnTip:(id)theSender
{
    if (isTipping)
    {
        self.qrImage.hidden = NO;
        self.tipperView.hidden = YES;
        
        self.qrCardTitleImage.image = [UIImage imageNamed:@"scan-title.png"];
    }
    else
    {
        self.qrImage.hidden = YES;
        self.tipperView.hidden = NO;
        
        self.qrCardTitleImage.image = [UIImage imageNamed:@"tips-title.png"];
    }
    
    isTipping = !isTipping;
}

//------------------------------------
// UITableViewDatasource methods
//------------------------------------
#pragma mark - UITableViewDatasource methods

- (NSInteger) tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)theSection
{
    return 7;
}

- (UITableViewCell *) tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)theIndexPath
{
    static NSString *IDENTIFIER = @"TipperCell";
    
    CBTipperTableCell *_cell = (CBTipperTableCell *) [theTableView dequeueReusableCellWithIdentifier:IDENTIFIER];
    
    if (_cell == nil)
    {
        _cell = [[CBTipperTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IDENTIFIER];
        _cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSInteger _rowCount = [theTableView numberOfRowsInSection:theIndexPath.section];
    
    if (theIndexPath.row == _rowCount - 1)
    {
        _cell.tipLabel.text = @"no tip";
    }
    else
    {
        NSInteger _tipAmount = (_rowCount - theIndexPath.row - 1) * 5;
        _cell.tipLabel.text = [NSString stringWithFormat:@"%d %%", _tipAmount];
    }
    
    return _cell;
}

//------------------------------------
// UITableViewDatasource methods
//------------------------------------
#pragma mark - UITableViewDatasource methods

- (void) tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)theIndexPath
{
    CGFloat _tipAmount = ([theTableView numberOfRowsInSection:theIndexPath.section] - theIndexPath.row - 1) * 0.05;
    
    [self setTip:_tipAmount];
}

//------------------------------------
// CBMagnifiableViewControllerDelegate methods
//------------------------------------
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

//------------------------------------
// MFMailComposeViewControllerDelegate
//------------------------------------
#pragma mark - MFMailComposeViewControllerDelegate

- (void) mailComposeController:(MFMailComposeViewController*)theController didFinishWithResult:(MFMailComposeResult)theResult error:(NSError*)theError
{
    [theController dismissModalViewControllerAnimated:YES];
}

//------------------------------------
// KZURLRequestDelegate methods
//------------------------------------
#pragma mark - KZURLRequestDelegate methods

- (void) KZURLRequest:(KZURLRequest *)theRequest didFailWithError:(NSError*)theError
{
	[KZApplication hideLoading];
    
	UIAlertView *_alert = [[UIAlertView alloc] initWithTitle:@"Cashbury"
                                                     message:@"A server error has occurred while getting your ID. Please retry flipping the card."
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles: nil];
	[_alert show];
	[_alert release];
	
	[theRequest release];
}

- (void) KZURLRequest:(KZURLRequest *)theRequest didSucceedWithData:(NSData*)theData
{
    CXMLDocument *_document = [[[CXMLDocument alloc] initWithData:theData options:0 error:nil] autorelease];
    
    CXMLElement *_hasCode = (CXMLElement *) [_document nodeForXPath:@"/hash/user-id" error:nil];    
    
    userHashCode = [[_hasCode stringValue] copy];
    
    [self updateQRImage];
    
    [theRequest release];
}

//------------------------------------
// KZEngagementHandlerDelegate methods
//------------------------------------
#pragma mark - KZEngagementHandlerDelegate methods

- (void) willDismissZXing
{
    if (loadingView)
    {
        if (loadingView.view.superview)
        {
            [self diminishViewController:loadingView duration:0];
            
            [loadingView release];
        }
    }
}

@end