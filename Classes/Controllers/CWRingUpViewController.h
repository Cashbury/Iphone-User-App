//
//  CWRingUpViewController.h
//  Cashbery
//
//  Created by Basayel Said on 7/18/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWItemFetchDelegate.h"
#import "KZBusiness.h"
#import "CWItemEngagement.h"
#import "KZSnapHandlerDelegate.h"
#import <ZXingWidgetController.h>
#import "KZURLRequest.h"
#import "CardIOPaymentViewController.h"
#import "CBAsyncImageView.h"

#define CAMERA_QR 1
#define CAMERA_CC 2

typedef enum
{
	CWRingUpViewControllerActionCharge,
	CWRingUpViewControllerActionLoad,
} CWRingUpViewControllerAction;

@interface CWRingUpViewController : UIViewController <CWItemFetchDelegate, UITextFieldDelegate, CWItemFetchDelegate, KZSnapHandlerDelegate, KZURLRequestDelegate, CardIOPaymentViewControllerDelegate> {
	NSMutableString* text_field_text;
	NSMutableString* str;
	ZXingWidgetController* zxing_vc;
	CardIOPaymentViewController *paymentViewController;
	KZURLRequest* ringup_req;
	BOOL is_menu_open;
	NSUInteger current_camera_screen_num;
}

@property (nonatomic, retain) IBOutlet UIScrollView* items_scroll_view;
@property (nonatomic, retain) IBOutlet UILabel* lbl_amount;
@property (nonatomic, retain) IBOutlet CBAsyncImageView* img_user;
@property (nonatomic, retain) IBOutlet UIView *view_item_counter;
@property (nonatomic, retain) IBOutlet UILabel* lbl_item_counter;
@property (nonatomic, retain) IBOutlet UIImageView* img_item_image;
@property (nonatomic, retain) IBOutlet UILabel* lbl_item_name;
@property (nonatomic, retain) IBOutlet UIView* view_zxing_bottom_bar;
@property (nonatomic, retain) IBOutlet UIButton* btn_zxing_cancel;

@property (nonatomic, assign) CWRingUpViewControllerAction action;

@property (nonatomic, retain) IBOutlet UIView* view_cover;
@property (nonatomic, retain) IBOutlet UILabel* lbl_ring_up;
@property (nonatomic, retain) IBOutlet UIView* view_menu;
@property (nonatomic, retain) IBOutlet UIImageView* img_menu_arrow;

@property (nonatomic, retain) KZBusiness* business;
@property (nonatomic, retain) CWItemEngagement* current_item;
@property (nonatomic, retain) NSArray* items;
@property (nonatomic, retain) NSMutableDictionary* selected_items_and_quantities;

@property (nonatomic, retain) IBOutlet UIButton* btn_clear;
@property (nonatomic, retain) IBOutlet UIButton* btn_ring_up;
@property (nonatomic, retain) IBOutlet UIButton* btn_load_up;
@property (nonatomic, retain) IBOutlet UIButton* btn_receipts;

@property (nonatomic, retain) IBOutlet UIButton* btn_scan_toggle;

- (IBAction) okAction;
- (IBAction) plusAction;
- (IBAction) minusAction;
- (IBAction) clearItemsAction;
- (IBAction) selectItemAction:(id)sender;
- (IBAction) openCloseMenu;
- (IBAction) goBackToSettings:(id)sender;
- (IBAction) showTransactionHistory;
- (IBAction) showRingUp;
- (IBAction) showLoadUp;
- (IBAction) cancel_snapping;
- (IBAction) scan_toggle;
- (IBAction) keyBoardAction:(id)sender;

- (id) initWithBusinessId:(NSString*)_business_id;

- (IBAction)gatherPaymentInformation:(UIButton *)sender;

@end
