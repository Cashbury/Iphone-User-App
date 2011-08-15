//
//  EngagementSuccessViewController.h
//  Cashbury
//
//  Created by Basayel Said on 3/21/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KZBusiness.h"
#import "FacebookWrapper.h"

@interface EngagementSuccessViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, FaceBookWrapperPublishDelegate> {
	NSString *fb_image_url;
	KZBusiness *business;
	NSString *address;
	NSMutableArray *details_lines;
	NSMutableArray *cells_heights;
	BOOL is_loaded;
}

- (IBAction) clear_btn:(id)sender;
- (IBAction) share_btn:(id)sender;

@property (nonatomic, retain) IBOutlet UILabel *lblBusinessName;
@property (nonatomic, retain) IBOutlet UILabel *lblBranchAddress;
@property (nonatomic, retain) IBOutlet UILabel *lblTime;
@property (nonatomic, retain) IBOutlet UILabel *lblTitle;
@property (nonatomic, retain) IBOutlet UIView *viewReceipt;
@property (nonatomic, retain) IBOutlet UITableView *tbl_body;
@property (nonatomic, retain) IBOutlet UITableViewCell *cell_top;
@property (nonatomic, retain) IBOutlet UITableViewCell *cell_middle;
@property (nonatomic, retain) IBOutlet UITableViewCell *cell_bottom;
@property (nonatomic, retain) IBOutlet UIImageView *img_register;
@property (nonatomic, retain) NSString *share_string;

- (id) initWithBusiness:(KZBusiness*)_biz andAddress:(NSString*)_address;
- (void) addLineDetail:(NSString*)_detail;
- (void) setMainTitle:(NSString*)_title;
- (void) setFacebookMessage:(NSString*)_fb_message andIcon:(NSString*)_image_url;
@end

