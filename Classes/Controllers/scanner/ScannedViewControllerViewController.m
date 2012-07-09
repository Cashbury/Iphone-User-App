//
//  ScannedViewControllerViewController.m
//  Cashbury
//
//  Created by Mrithula Ancy on 6/14/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#import "ScannedViewControllerViewController.h"

@interface ScannedViewControllerViewController ()

@end

@implementation ScannedViewControllerViewController
@synthesize viewPlainTextButton;
@synthesize tableView;
@synthesize textView;
@synthesize phoneContactEmailView;
@synthesize bottomSignalBar;
@synthesize typeLabel;
@synthesize bottomView;
@synthesize containerView;
@synthesize webView;
@synthesize contact;
@synthesize tag;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark Header View

-(void)setTableViewHeaderView{
    
    UIView *headerView              =   [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 70.0)];
    UIImageView *userImage          =   [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 64, 64)];

    [userImage setImage:[UIImage imageNamed:@"scanned_user"]];
    [headerView addSubview:userImage];
    [userImage release];
    
    
    UILabel *contactLabel           =   [[UILabel alloc] initWithFrame:CGRectMake(90, 20.0, 200.0, 30.0)];
    [contactLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    contactLabel.textAlignment      =   UITextAlignmentLeft;
    contactLabel.text               =   self.contact.name;
    contactLabel.backgroundColor    =   [UIColor clearColor];
    [headerView addSubview:contactLabel];
    [contactLabel release];
    
    [self.tableView setTableHeaderView:headerView];
    [headerView release];
    
}
-(void)textMessageClicked{
}

-(void)shareContactClicked{
    
}

#pragma mark Footer View
-(void)setTableViewFooterView{
    UIView *tableFooter             =   [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    
    UIButton *textMessage           =   [UIButton buttonWithType:UIButtonTypeRoundedRect];
    textMessage.frame               =   CGRectMake(10.0, 5.0, 135, 40);
    [textMessage setTitle:@"Text Message" forState:UIControlStateNormal];
    [textMessage.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
    textMessage.layer.borderColor   =   [UIColor colorWithRed:(CGFloat)196/255 green:(CGFloat)199/255 blue:(CGFloat)202/255 alpha:1.0].CGColor;
   textMessage.layer.cornerRadius  =   10.0;
    textMessage.layer.borderWidth   =   1.0;
    [tableFooter addSubview:textMessage];
    
    
    UIButton *shareContact          =   [UIButton buttonWithType:UIButtonTypeRoundedRect];
    shareContact.frame              =   CGRectMake(160.0, 5.0, 135, 40);
    [shareContact setTitle:@"Share Contact" forState:UIControlStateNormal];
    [shareContact.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
    [shareContact addTarget:self action:@selector(shareContactClicked) forControlEvents:UIControlEventTouchUpInside];
    shareContact.layer.borderColor  =   [UIColor colorWithRed:(CGFloat)196/255 green:(CGFloat)199/255 blue:(CGFloat)202/255 alpha:1.0].CGColor;
    shareContact.layer.borderWidth  =   1.0;
    shareContact.layer.cornerRadius =   10.0;
    [tableFooter addSubview:shareContact];
    
    [self.tableView setTableFooterView:tableFooter];
    [tableFooter release];
}
-(void)showCorrectView{
    switch (self.contact.type) {
        case SCAN_TYPE_WEB:
            self.phoneContactEmailView.hidden   =   TRUE;
            self.textView.hidden                =   TRUE;
            self.webView.hidden                 =   FALSE;
            self.typeLabel.text                 =   @"Content: Web URL";
            break;
        case SCAN_TYPE_TEXT:
            self.phoneContactEmailView.hidden   =   TRUE;
            self.textView.hidden                =   FALSE;
            self.webView.hidden                 =   TRUE;
            self.typeLabel.text                 =   @"Content: Text";
            break;
        case SCAN_TYPE_CONTACT: 
            self.phoneContactEmailView.hidden   =   FALSE;
            self.textView.hidden                =   TRUE;
            self.webView.hidden                 =   TRUE;
            self.typeLabel.text                 =   @"Content: Mecard Contact";
            break;
        case SCAN_TYPE_EMAIL: 
            self.phoneContactEmailView.hidden   =   FALSE;
            self.textView.hidden                =   TRUE;
            self.webView.hidden                 =   TRUE;
            self.typeLabel.text                 =   @"Content: Email";
            break;
        case SCAN_TYPE_PHONE:
            self.phoneContactEmailView.hidden   =   FALSE;
            self.textView.hidden                =   TRUE;
            self.webView.hidden                 =   TRUE;
            self.typeLabel.text                 =   @"Content: Telephone Number";
            break;
            
        default:
            break;
    }
}

-(void)setControls{
    
    switch (self.contact.type) {
        case SCAN_TYPE_TEXT:{
            RRSGlowLabel *textLabel     =   (RRSGlowLabel*)[textView viewWithTag:20];
            textLabel.text              =   self.contact.name;
        }
            break;
            
        case SCAN_TYPE_PHONE: case SCAN_TYPE_EMAIL: case SCAN_TYPE_CONTACT:
            self.tableView.delegate     =   self;
            self.tableView.dataSource   =   self;
            [self setTableViewHeaderView];
            [self setTableViewFooterView];
            break;
            
        case SCAN_TYPE_WEB:{
        
            UIWebView *tempWeb      =   (UIWebView*)[webView viewWithTag:30];
            UIActivityIndicatorView *indicatorView  =   (UIActivityIndicatorView*)[tempWeb viewWithTag:40];
            [indicatorView startAnimating];
            NSURL *homeURL          =   [NSURL URLWithString:self.contact.url];
            NSURLRequest *request   =   [[NSURLRequest alloc] initWithURL:homeURL];
            tempWeb.delegate        =   self;
            [tempWeb loadRequest:request];
            [request release];
        }
            break;
                                                 
            
        default:
            break;
    }
    

    self.bottomView.layer.borderWidth           =   1.0;
    self.bottomView.layer.borderColor           =   [UIColor colorWithRed:(CGFloat)196/255 green:(CGFloat)199/255 blue:(CGFloat)202/255 alpha:1.0].CGColor;
    self.bottomView.layer.masksToBounds    =   TRUE;
}

#pragma mark UIWebViewDelegate Methods

- (void)webViewDidFinishLoad:(UIWebView *)mwebView{
    UIActivityIndicatorView *indicatorView  =   (UIActivityIndicatorView*)[webView viewWithTag:40];
    [indicatorView stopAnimating];
}

#pragma mark Animate Container view
-(void)animateContainerView{
    containerView.frame         =   CGRectMake(containerView.frame.origin.x, 480.0, containerView.frame.size.width, containerView.frame.size.height);
    [UIView animateWithDuration:0.5 animations:^{
        containerView.hidden    =   FALSE;
        containerView.frame     =   CGRectMake(containerView.frame.origin.x, 6.0, containerView.frame.size.width, containerView.frame.size.height); 
    }completion:^(BOOL conclusion){
        self.bottomSignalBar.highlighted    =   TRUE;
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:TRUE];
    [self setControls];
    [self showCorrectView];
    [self performSelector:@selector(animateContainerView) withObject:nil afterDelay:0.5];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setViewPlainTextButton:nil];
    [self setTextView:nil];
    [self setPhoneContactEmailView:nil];
    [self setWebView:nil];
    [self setContainerView:nil];
    [self setBottomSignalBar:nil];
    [self setTypeLabel:nil];
    [self setBottomView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark TableView delegates
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    switch (self.contact.type) {
        case SCAN_TYPE_PHONE: case SCAN_TYPE_EMAIL:
            return 2;
            break;
            
        case SCAN_TYPE_CONTACT:
            return 5;
            break;
            
        default:
            break;
    }
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.contact.type == SCAN_TYPE_CONTACT) {
        if (section == 4) {
            return 2;
        }
    }else {
        if (section == 1) {
            return 2;
        }
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)mtableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellIdentifier    =   @"ScannedCell";
    UILabel *textLabel          =   nil;
    UITableViewCell *cell       =   [mtableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell                    =   [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cellIdentifier];
        cell.backgroundColor    =   [UIColor whiteColor];
        cell.selectionStyle     =   UITableViewCellEditingStyleNone;
        if ((self.contact.type == SCAN_TYPE_CONTACT && indexPath.section == 4) || ((self.contact.type == SCAN_TYPE_EMAIL || self.contact.type == SCAN_TYPE_PHONE) && indexPath.section == 1)) {
            textLabel                   =   [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 290, 30)];
            [textLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
            textLabel.tag               =   indexPath.row+10;
            textLabel.textAlignment     =   UITextAlignmentCenter;
            [textLabel setTextColor:[UIColor colorWithRed:(CGFloat)60/255 green:(CGFloat)83/255 blue:(CGFloat)131/255 alpha:1.0]];
            textLabel.backgroundColor   =   [UIColor clearColor];
            [cell.contentView addSubview:textLabel];
            [textLabel release];
        }
        
    }
    if (self.contact.type == SCAN_TYPE_CONTACT) {
        switch (indexPath.section) {
            case 0:
                cell.textLabel.text             =   @"mobile";
                cell.detailTextLabel.text       =   self.contact.mobile;
                break;
            case 1:
                cell.textLabel.text             =   @"email";
                cell.detailTextLabel.text       =   self.contact.email;
                break;
            case 2:
                cell.textLabel.text             =   @"home page";
                cell.detailTextLabel.text       =   self.contact.url;
                break;
            case 3:
                cell.textLabel.text             =   @"home";
                cell.detailTextLabel.text       =   self.contact.address;
                break;
            case 4:
                textLabel                       =   (UILabel*)[cell.contentView viewWithTag:indexPath.row+10];
                textLabel.hidden                =   FALSE;
                cell.textLabel.text             =   @"";
                cell.detailTextLabel.text       =   @"";
                if (indexPath.row == 0) {
                    [textLabel setText:@"Create New Contact"];
                  //  textLabel.text    =   @"Create New Contact";
                }else {
                    textLabel.text    =   @"Add to Existing Contact";
                }
                
                break;                
                
            default:
                break;
        }
       
    }else {
        switch (indexPath.section) {
            case 0:
                if (self.contact.type == SCAN_TYPE_EMAIL) {
                    cell.textLabel.text             =   @"email";
                    cell.detailTextLabel.text       =   self.contact.email;
                }else {
                     
                    cell.textLabel.text             =   @"mobile";
                    cell.detailTextLabel.text       =   self.contact.mobile;
                }
                break;
            case 1:
                textLabel.hidden                =   FALSE;
                cell.textLabel.text             =   @"";
                cell.detailTextLabel.text       =   @"";
                if (indexPath.row == 0) {
                    textLabel.text    =   @"Create New Contact";
                }else {
                    textLabel.text    =   @"Add to Existing Contact";
                }
                break;                
                
            default:
                break;
        }
        
        
    }
    return cell;
}




- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [tableView release];
    [contact release];
    [viewPlainTextButton release];
    [textView release];
    [phoneContactEmailView release];
    [webView release];
    [containerView release];
    [bottomSignalBar release];
    [typeLabel release];
    [bottomView release];
    [super dealloc];
}
- (IBAction)viewPlainText:(id)sender {
    
    PlainTextViewController *plainView  =   [[PlainTextViewController alloc] init];
    if (self.tag == SCAN_TAG_AFTERSCANNING) {
        UINavigationController *nav         =   [KZApplication getAppDelegate].navigationController;
        [nav pushViewController:plainView animated:TRUE];
    }else {
        [self.navigationController  pushViewController:plainView animated:TRUE];
    }
    
    plainView.titleLabel.text               =  self.typeLabel.text;
    plainView.plainTextView.text            =   self.contact.qrcode;
}

- (IBAction)goBack:(id)sender {
    if (self.tag == SCAN_TAG_AFTERSCANNING) {
        [self diminishViewController:self duration:0.35];
    }else {
        [self.navigationController popViewControllerAnimated:TRUE];
    }
    
}
@end
