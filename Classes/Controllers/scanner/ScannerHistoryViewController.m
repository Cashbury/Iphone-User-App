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
@synthesize tableView;

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
    delegate                    =   [[UIApplication sharedApplication] delegate];
    self.tableView.delegate     =   self;
    self.tableView.dataSource   =   self;
    self.navigationController.navigationBar.hidden  =   TRUE;
    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark TableView delegates
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [delegate.scanHistoryArray count];
}

-(UITableViewCell*)tableView:(UITableView *)mtableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellIndentifier   =   @"ScannedHistoryCell";
    UITableViewCell *cell       =   [mtableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil) {
        cell                    =   [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIndentifier];
        cell.textLabel.font     =   [UIFont fontWithName:@"HelveticaNeue" size:14];
        cell.textLabel.textColor        =   [UIColor colorWithRed:(CGFloat)51/255 green:(CGFloat)51/255 blue:(CGFloat)51/255 alpha:1.0];
        cell.detailTextLabel.font       =   [UIFont fontWithName:@"HelveticaNeue" size:10];
        cell.detailTextLabel.textColor  =   [UIColor colorWithRed:(CGFloat)153/255 green:(CGFloat)153/255 blue:(CGFloat)153/255 alpha:1.0];
        cell.accessoryType              =   UITableViewCellAccessoryDisclosureIndicator;
    }
    ContactDetails *details     =   [delegate.scanHistoryArray objectAtIndex:indexPath.row];
    switch (details.type) {
        case SCAN_TYPE_TEXT:
            cell.textLabel.text         =   details.name;
            cell.detailTextLabel.text   =   @"Text .";
            break;
        case SCAN_TYPE_PHONE:
            cell.textLabel.text         =   details.mobile;
            cell.detailTextLabel.text   =   @"Tel .";
            break;
        case SCAN_TYPE_EMAIL:
            cell.textLabel.text         =   details.email;
            cell.detailTextLabel.text   =   @"Email .";
            break;
        case SCAN_TYPE_WEB:
            cell.textLabel.text         =   details.url;
            cell.detailTextLabel.text   =   @"URL .";
            break;
        case SCAN_TYPE_CONTACT:
            cell.textLabel.text         =   [NSString stringWithFormat:@"%@ . %@ . %@ . ",details.name,details.mobile,details.email];
            cell.detailTextLabel.text   =   @"Mecard .";
            break;

        default:
            break;
    }
    cell.detailTextLabel.text           =   [cell.detailTextLabel.text stringByAppendingFormat:@" %@ . %@ . QR Code",details.date,details.time];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ContactDetails *details =   [delegate.scanHistoryArray objectAtIndex:indexPath.row];
    ScannedViewControllerViewController *scanned    =   [[ScannedViewControllerViewController alloc] init];
    scanned.contact                                 =   details;
    scanned.tag                                     =   SCAN_TAG_SCANNEDHISTORY;
    [self.navigationController pushViewController:scanned animated:TRUE];
    [scanned release];
    
}
  


- (void)viewDidUnload
{
    [self setTableView:nil];
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

- (IBAction)goBackToMainView:(id)sender {
   
    
    if (IS_IOS_5_OR_NEWER)
    {
        [[KZApplication getAppDelegate].navigationController.visibleViewController dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [[KZApplication getAppDelegate].navigationController.visibleViewController dismissModalViewControllerAnimated:YES];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DiscardScannerHistoryToMainView" object:nil];
}
- (void)dealloc {
    [tableView release];
    [super dealloc];
}
@end
