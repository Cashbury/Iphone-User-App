//
//  ScannerHistoryViewController.h
//  Cashbury
//
//  Created by Mrithula Ancy on 5/9/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KazdoorAppDelegate.h"
#import "ContactDetails.h"
#import "ScannedViewControllerViewController.h"
#import "KZApplication.h"

@interface ScannerHistoryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    KazdoorAppDelegate *delegate;
}
@property (retain, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)goBackToScanner:(id)sender;
- (IBAction)goBackToMainView:(id)sender;
@end
