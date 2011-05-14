//
//  EngagementSuccessViewController.h
//  Cashbury
//
//  Created by Basayel Said on 3/21/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EngagementSuccessViewController : UIViewController {
	IBOutlet UILabel *lblBusinessName;
	IBOutlet UILabel *lblBranchAddress;
	IBOutlet UILabel *lblTime;
	IBOutlet UILabel *lblTitle;
	IBOutlet UITextView *txtDetails;
	IBOutlet UIView *viewReceipt;
	NSString *share_string;
}

- (IBAction) clear_btn:(id)sender;
- (IBAction) share_btn:(id)sender;

@property (nonatomic, retain) IBOutlet UILabel *lblBusinessName;
@property (nonatomic, retain) IBOutlet UILabel *lblBranchAddress;
@property (nonatomic, retain) IBOutlet UILabel *lblTime;
@property (nonatomic, retain) IBOutlet UILabel *lblTitle;
@property (nonatomic, retain) IBOutlet UITextView *txtDetails;
@property (nonatomic, retain) IBOutlet UIView *viewReceipt;
@property (nonatomic, retain) NSString *share_string;

@end

