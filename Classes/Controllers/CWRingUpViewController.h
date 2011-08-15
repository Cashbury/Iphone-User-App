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
}

@property (nonatomic, retain) IBOutlet UIScrollView* items_scroll_view;
@property (nonatomic, retain) IBOutlet UITextField* txt_amount;
@property (nonatomic, retain) IBOutlet UIImageView* img_user;
@property (nonatomic, retain) IBOutlet UIView *view_item_counter;
@property (nonatomic, retain) IBOutlet UILabel* lbl_item_counter;
@property (nonatomic, retain) IBOutlet UIImageView* img_item_image;
@property (nonatomic, retain) IBOutlet UILabel* lbl_item_name;
@property (nonatomic, retain) KZBusiness* business;
@property (nonatomic, retain) CWItemEngagement* current_item;
@property (nonatomic, retain) NSArray* items;
@property (nonatomic, retain) NSMutableDictionary* selected_items_and_quantities;

- (IBAction) okAction;
- (IBAction) plusAction;
- (IBAction) minusAction;
- (IBAction) clearItemsAction;
- (IBAction) selectItemAction:(id)sender;

- (IBAction) goBackToSettings:(id)sender;

- (id) initWithBusinessId:(NSString*)_business_id;

@end
