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

@interface CWRingUpViewController : UIViewController <CWItemFetchDelegate, UITextFieldDelegate, CWItemFetchDelegate, KZSnapHandlerDelegate, KZURLRequestDelegate> {
	NSMutableString* text_field_text;
	NSMutableString* str;
	ZXingWidgetController* zxing_vc;
	KZURLRequest* ringup_req;
	BOOL is_menu_open;
}

@property (nonatomic, retain) IBOutlet UIScrollView* items_scroll_view;
@property (nonatomic, retain) IBOutlet UILabel* lbl_amount;
@property (nonatomic, retain) IBOutlet UIImageView* img_user;
@property (nonatomic, retain) IBOutlet UIView *view_item_counter;
@property (nonatomic, retain) IBOutlet UILabel* lbl_item_counter;
@property (nonatomic, retain) IBOutlet UIImageView* img_item_image;
@property (nonatomic, retain) IBOutlet UILabel* lbl_item_name;
@property (nonatomic, retain) IBOutlet UIView* view_zxing_bottom_bar;
@property (nonatomic, retain) IBOutlet UIButton* btn_zxing_cancel;


@property (nonatomic, retain) IBOutlet UIImageView* img_flag;
@property (nonatomic, retain) IBOutlet UILabel* lbl_currency_code;
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
@property (nonatomic, retain) IBOutlet UIButton* btn_receipts;

- (IBAction) okAction;
- (IBAction) plusAction;
- (IBAction) minusAction;
- (IBAction) clearItemsAction;
- (IBAction) selectItemAction:(id)sender;
- (IBAction) openCloseMenu;
- (IBAction) goBackToSettings:(id)sender;
- (IBAction) showTransactionHistory;
- (IBAction) showRingUp;
- (IBAction) cancel_snapping;

- (IBAction) keyBoardAction:(id)sender;

- (id) initWithBusinessId:(NSString*)_business_id;

@end
