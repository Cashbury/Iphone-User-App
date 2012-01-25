//
//  CWRingUpViewController.m
//  Cashbery
//
//  Created by Basayel Said on 7/18/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import "CWRingUpViewController.h"
#import "QuartzCore/QuartzCore.h"
#import "KZUserInfo.h"
#import "KZSnapController.h"
#import "KZApplication.h"
#import "CXMLElement+Helpers.h"
#import "TouchXML.h"
#import "KZCashierSpendReceiptViewController.h"
#import "CashierTxHistoryViewController.h"
#import "KZReceiptHistory.h"
#import "UIButton+Helper.h"

@interface CWRingUpViewController (Private)
	- (void) keyTouched:(NSString*)string;
	- (void) setMyStyleForButton:(UIButton*)_btn;
	- (void) scan_zxing;
@end

@implementation CWRingUpViewController

@synthesize items_scroll_view, lbl_amount, img_user, lbl_item_counter,  img_item_image, lbl_item_name, current_item, business, items, selected_items_and_quantities, view_item_counter, img_menu_arrow, view_menu, lbl_ring_up, view_cover, view_zxing_bottom_bar, btn_zxing_cancel, btn_clear, btn_ring_up, btn_receipts, btn_scan_toggle;
@synthesize btn_load_up, action;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	is_menu_open = NO;
	
	[self.btn_clear setCustomStyle];
    [self.btn_load_up setCustomStyle];
	[self.btn_ring_up setCustomStyle];
	[self.btn_receipts setCustomStyle];
	
	[self.items_scroll_view setShowsHorizontalScrollIndicator:NO];
	
	self.selected_items_and_quantities = [[[NSMutableDictionary alloc] init] autorelease];
	[CWItemEngagement getItemsHavingEngagementsForBusiness:[self.business.identifier intValue] 
											   andDelegate:self];
    
    [self.img_user loadImageWithAsyncUrl:[KZUserInfo shared].cashier_business.image_url];
    
    self.action = CWRingUpViewControllerActionCharge;
}

- (IBAction) openCloseMenu {
	CGRect current_position = self.view_menu.frame;
	if (is_menu_open) {	// then close
		current_position.origin.y -= 200;
	} else {	// then open
		current_position.origin.y += 200;
	}
	is_menu_open = !is_menu_open;
	[self.view_cover setHidden:NO];
	[self.view_cover setOpaque:NO];
	[UIView animateWithDuration:0.5 
					 animations:^(void){
						 if (is_menu_open) {
							 [self.view_cover setAlpha:0.8];
						 } else {
							 [self.view_cover setAlpha:0.0];
						 }
						 self.view_menu.frame = current_position;
					 } 
					 completion:^(BOOL finished){	
						 if (is_menu_open) {
							 [self.lbl_ring_up setHighlighted:YES];
							 [self.img_menu_arrow setHighlighted:YES];
						 } else {
							 [self.lbl_ring_up setHighlighted:NO];
							 [self.img_menu_arrow setHighlighted:NO];
						 }
					 }
	 ];
	
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (IBAction) showTransactionHistory {
	[self openCloseMenu];
	[KZReceiptHistory getCashierReceipts:self andDaysCount:7];
}


- (void) gotCashierReceipts:(NSMutableArray*)_receipts {
	CashierTxHistoryViewController* vc = [[CashierTxHistoryViewController alloc] initWithDaysArray:_receipts];
	[self presentModalViewController:vc animated:YES];
	[vc release];
}

- (void) gotCustomerReceipts:(NSMutableArray*)_receipts {
	////DUMMY
}

- (void) noReceiptsFound {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Sorry a server error has occurred while retrieving the Receipts. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alert show];
	[alert release];
}


- (IBAction) showRingUp {
    self.action = CWRingUpViewControllerActionCharge;
	[self openCloseMenu];
}

- (IBAction) showLoadUp {
    self.action = CWRingUpViewControllerActionLoad;
	[self openCloseMenu];
}


- (IBAction) keyBoardAction:(id)sender {
	int tag = [((UIButton*)sender) tag];
	NSRange r;
	if (tag >= 0 && tag <= 9) {
		[self keyTouched:[NSString stringWithFormat:@"%d", tag]];
	} else if (tag == 10) {	// Magnify
		NSLog(@"Magnify Button Touched...");
	} else if (tag == 11) {	// backspace
		[self keyTouched:@""];
	}
}

/*

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

 */
- (void) keyTouched:(NSString*)string {
	if ([string isEqual:@""]) {
		if (text_field_text == nil || [text_field_text isEqual:@""]) return;
		NSRange r = NSMakeRange([text_field_text length]-1, 1);
		[text_field_text deleteCharactersInRange:r];
	} else {
		[text_field_text appendString:string];
	}

	if (str == nil) {
		str = [[NSMutableString alloc] init];
	} else {
		[str deleteCharactersInRange:NSMakeRange(0, [str length])];
	}
	
	
	if ([text_field_text length] < 3) {
		[str appendString:@"$0."];	//$
		for (NSUInteger i = [text_field_text length]; i < 2; i++) {
			[str appendString:@"0"];
		}
		[str appendString:text_field_text];
		
	} else {
		NSRange starting = NSMakeRange(0, [text_field_text length]-2);
		NSRange last_2 = NSMakeRange([text_field_text length]-2, 2);
		[str appendString:@"$"];
		[str appendString:[text_field_text substringWithRange:starting]];
		[str appendString:@"."];
		[str appendString:[text_field_text substringWithRange:last_2]];
	}
	self.lbl_amount.text = str;
}

- (void)viewDidUnload {
    [super viewDidUnload];
	self.selected_items_and_quantities = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.btn_load_up = nil;
}

- (void)dealloc
{
    [btn_load_up release];
    
    [super dealloc];
}

- (void) gotItems:(NSArray*)_items {
	/////////////populate the items images
	//[self.img_item_image copy];
	//[self.lbl_item_name copy];
	self.items = _items;
	NSUInteger i = 0;
	NSUInteger item_height = 0;
	NSUInteger item_width = 0;
	for (CWItemEngagement* item in _items) {
		UIImage* img = [UIImage imageWithData:
										[NSData dataWithContentsOfURL:
												[NSURL URLWithString:
														item.image_url]]];
		CGRect f;
		f.origin.y = 6;
		f.origin.x = ((img.size.width + 4) * i) + 2;
		f.size.width = img.size.width;
		f.size.height = img.size.height;
		
		UIButton *btn = [[UIButton alloc] initWithFrame:f];
		[btn setTag:item.engagement_id];
		[btn addTarget:self action:@selector(selectItemAction:) forControlEvents:UIControlEventTouchUpInside];
		btn.frame = f;
		btn.layer.masksToBounds = YES;
		btn.layer.cornerRadius = 5.0;
		btn.layer.borderWidth = 1.0;
		btn.layer.borderColor = [UIColor colorWithRed:222.0 green:224.0 blue:226.0 alpha:1.0].CGColor;
		[btn setBackgroundImage:img forState:UIControlStateNormal];
		
		UILabel *lbl = [[UILabel alloc] initWithFrame:self.lbl_item_name.frame];
		CGRect lbl_frame = lbl.frame;
		lbl_frame.origin.x = f.origin.x;
		lbl_frame.origin.y = f.origin.y + f.size.height;
		lbl.frame = lbl_frame;
		
		lbl.font = self.lbl_item_name.font;
		lbl.text = item.name;
		lbl.textColor = self.lbl_item_name.textColor;
		lbl.alpha = self.lbl_item_name.alpha;
		lbl.backgroundColor = [UIColor clearColor];
		lbl.textAlignment = self.lbl_item_name.textAlignment;
		lbl.adjustsFontSizeToFitWidth = self.lbl_item_name.adjustsFontSizeToFitWidth;
		lbl.minimumFontSize = self.lbl_item_name.minimumFontSize;
		
		item_height = lbl_frame.origin.y + lbl_frame.size.height;
		item_width = f.size.width + 4;
		
		[self.items_scroll_view addSubview:lbl];
		[self.items_scroll_view addSubview:btn];
		
		[lbl release];
		[btn release];
		i++;
	}
	NSUInteger width = i * item_width;
	if (width < self.items_scroll_view.frame.size.width) width = self.items_scroll_view.frame.size.width+1;
	self.items_scroll_view.contentSize = CGSizeMake(width, self.items_scroll_view.frame.size.height);
	//UIButton* btn = [[UIButton alloc] init];
	// add the button
	//[btn release];
}

- (void) itemsFetchError:(NSString*)_error {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Sorry a server error has occurred while retrieving the Items. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alert show];
	[alert release]; 
}

- (void) setAction:(CWRingUpViewControllerAction)theAction
{
    action = theAction;
    
    self.lbl_ring_up.text = (theAction == CWRingUpViewControllerActionCharge) ? @"Charge" : @"Load";
}

- (IBAction) okAction {
	[self scan_zxing];
}

- (void) scan_cardio { 
	paymentViewController = [[[CardIOPaymentViewController alloc] initWithPaymentDelegate:self] autorelease];
	// To use the CardIO SDK, you must obtain a valid app token by signing up and creating an app at https://www.card.io/
	paymentViewController.appToken = @"698ff679bddf49eeb9aa90ffaba7c7fa";
	[paymentViewController.view addSubview:self.view_zxing_bottom_bar];
	current_camera_screen_num = CAMERA_CC;
	[self presentModalViewController:paymentViewController animated:NO];
}

- (void) scan_zxing {
	// Can and send the ring up amount
	zxing_vc = [KZSnapController snapWithDelegate:self andShowCancel:NO];
	CGRect f = self.view_zxing_bottom_bar.frame;
	f.origin.x = 0;
	f.origin.y = zxing_vc.overlayView.frame.size.height - 44;
	self.view_zxing_bottom_bar.frame = f;
	
	[zxing_vc.overlayView addSubview:self.view_zxing_bottom_bar];
	
	[zxing_vc retain];
	current_camera_screen_num = CAMERA_QR;
	[self presentModalViewController:zxing_vc animated:NO];
}

- (void) setCount:(NSUInteger)_count OfEngagementId:(NSUInteger)_eng_id {
	if (_count < 1) {
		[self.selected_items_and_quantities removeObjectForKey:[NSString stringWithFormat:@"%d", _eng_id]];
	} else {
		[self.selected_items_and_quantities setValue:[NSString stringWithFormat:@"%d", _count] forKey:[NSString stringWithFormat:@"%d", _eng_id]];
	}
}

- (NSUInteger) getCountOfEngagementId:(NSUInteger)_eng_id {
	if ([[self.selected_items_and_quantities allKeys] containsObject:[NSString stringWithFormat:@"%d", self.current_item.engagement_id]]) {
		return (NSUInteger)[[self.selected_items_and_quantities valueForKey:[NSString stringWithFormat:@"%d", _eng_id]] intValue];
	} else {
		return 0;
	}
}

- (IBAction) plusAction {
	NSUInteger count = [self getCountOfEngagementId:self.current_item.engagement_id];
	count++;
	[self setCount:count OfEngagementId:self.current_item.engagement_id];
	self.lbl_item_counter.text = [NSString stringWithFormat:@"%d - %@", count, self.current_item.name];
}

- (IBAction) minusAction {
	NSUInteger count = [self getCountOfEngagementId:self.current_item.engagement_id];
	count--;
	
	if (count < 1) {
		[self.view_item_counter setHidden:YES];
		[self.items_scroll_view viewWithTag:self.current_item.engagement_id].layer.borderColor = [UIColor whiteColor].CGColor;
	} else {
		self.lbl_item_counter.text = [NSString stringWithFormat:@"%d - %@", count, self.current_item.name];
	}
	[self setCount:count OfEngagementId:self.current_item.engagement_id];
	
}

- (IBAction) clearItemsAction {
	[text_field_text setString:@""];
	self.lbl_amount.text = @"$0.00";	//$

	self.current_item = nil;
	[self.selected_items_and_quantities removeAllObjects];
	[self.view_item_counter setHidden:YES];
	NSArray* views = [self.items_scroll_view subviews];
	
	for (UIView* subview in views) {
		if ([subview class] == [UIButton class]) {
			subview.layer.borderColor = [UIColor whiteColor].CGColor;
		}
	}
}

- (IBAction) selectItemAction:(id)sender {
	UIButton* btn = (UIButton*)sender;
	btn.layer.borderColor = [UIColor redColor].CGColor;
	BOOL increment_count = YES;
	if (self.current_item == nil) { 
		self.current_item = [CWItemEngagement getItemByEngagementId:btn.tag];
	} else if (self.current_item.engagement_id != btn.tag) {
		self.current_item = [CWItemEngagement getItemByEngagementId:btn.tag];
		increment_count = NO;
	}

	NSUInteger count = [self getCountOfEngagementId:self.current_item.engagement_id];
	if (increment_count || count < 1) {
		count++;
		[self setCount:count OfEngagementId:self.current_item.engagement_id];
	}
	self.lbl_item_counter.text = [NSString stringWithFormat:@"%d - %@", count, self.current_item.name];
	[self.view_item_counter setHidden:NO];
}

- (id) initWithBusinessId:(NSString*)_business_id {
	if (self = [self initWithNibName:@"CWRingUpView" bundle:nil]) {
		current_camera_screen_num = 0;
		self.business = [KZBusiness getBusinessWithIdentifier:_business_id andName:nil andImageURL:nil];
		text_field_text = [[NSMutableString alloc] init];
		str = nil;
	}
	return self;
}

- (void) didSnapCode:(NSString*)_code {
	[zxing_vc dismissModalViewControllerAnimated:NO];
	[zxing_vc release];
	current_camera_screen_num = 0;
	float amount = [[str substringWithRange:NSMakeRange(1, [str length]-1)] floatValue];

	NSMutableString* params = [[NSMutableString alloc] init];
	[params appendFormat:@"auth_token=%@", [KZUserInfo shared].auth_token];
	[params appendFormat:@"&amount=%1.2f", amount];
	[params appendFormat:@"&customer_identifier=%@", _code];
	[params appendFormat:@"&long=%@", [LocationHelper getLongitude]];
	[params appendFormat:@"&lat=%@", [LocationHelper getLatitude]];
	
	NSArray* arr_engagements_ids = [self.selected_items_and_quantities allKeys];
	for (NSString* engagement_id in arr_engagements_ids) {
		NSString* quantity = (NSString*)[self.selected_items_and_quantities objectForKey:engagement_id];
		[params appendFormat:@"&engagements[]=%@,%@", engagement_id, quantity];
		
	}
	
	NSLog(params);
	
	NSMutableDictionary *_headers = [[NSMutableDictionary alloc] init];
	[_headers setValue:@"application/xml" forKey:@"Accept"];
    
    NSString *_formattedEndpoint = (self.action == CWRingUpViewControllerActionCharge) ? @"%@/users/cashiers/charge_customer.xml" : @"%@/users/cashiers/load_money.xml";
    
	ringup_req = [[KZURLRequest alloc] initRequestWithString:[NSString stringWithFormat:_formattedEndpoint, API_URL] 
												   andParams:params 
													delegate:self 
													 headers:_headers 
										   andLoadingMessage:@"Sending..."];
    
	[params release];
}

- (void) didCancelledSnapping {
	[zxing_vc dismissModalViewControllerAnimated:NO];
	[zxing_vc release];
	current_camera_screen_num = 0;
}

- (IBAction) cancel_snapping {
	if (current_camera_screen_num == CAMERA_CC) {
		[self userDidCancelPaymentViewController:paymentViewController];
	} else if (current_camera_screen_num == CAMERA_QR) {
		[zxing_vc cancelled];
	}
	[self.btn_scan_toggle setSelected:NO];
	current_camera_screen_num = 0;
}

- (void) KZURLRequest:(KZURLRequest *)theRequest didFailWithError:(NSError*)theError {
	NSLog(@"Got ERROR : %@", [theError localizedDescription]);
	[ringup_req release];
}

- (void) KZURLRequest:(KZURLRequest *)theRequest didSucceedWithData:(NSData*)theData {
	@try {	
		NSString* str = [[[NSString alloc] initWithData:theData encoding:NSUTF8StringEncoding] autorelease];

		CXMLDocument *_document = [[[CXMLDocument alloc] initWithData:theData options:0 error:nil] autorelease];
		CXMLElement* _node  = [_document nodeForXPath:@"/hash" error:nil];
		if ([_node stringFromChildNamed:@"currency-symbol"] == nil) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Sorry an error has occurred. Invalid QR Code. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
			[alert show];
			[alert release];
		} else {
			KZCashierSpendReceiptViewController* rec = 
			[[KZCashierSpendReceiptViewController alloc] initWithBusiness:[KZUserInfo shared].cashier_business 
															   amount:[_node stringFromChildNamed:@"amount"] 
													  currency_symbol:[_node stringFromChildNamed:@"currency-symbol"] 
														customer_name:[_node stringFromChildNamed:@"customer-name"] 
														customer_type:[_node stringFromChildNamed:@"customer-type"] 
												   customer_image_url:[_node stringFromChildNamed:@"customer-image-url"]
														transaction_id:[_node stringFromChildNamed:@"transaction-id"]];
            
            rec.actionString = (self.action == CWRingUpViewControllerActionCharge) ? @"collected from" : @"loaded for";
			
			[self presentModalViewController:rec animated:YES];
			[rec release];
			[text_field_text setString:@""];
			[self clearItemsAction];
		}
		[ringup_req release];
	}@catch (NSException * e) {
		NSLog(@"Exception: %@", e);
	}
}

- (IBAction) goBackToSettings:(id)sender {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view.superview cache:NO];	
	[self.view removeFromSuperview];
	[UIView commitAnimations];
}

- (IBAction) scan_toggle {
	if ([self.btn_scan_toggle isSelected]) {	// toggle to QR
		[self.btn_scan_toggle setSelected:NO];
		[self userDidCancelPaymentViewController:paymentViewController];
		[self scan_zxing];
	} else {	// toggle to CC
		[self.btn_scan_toggle setSelected:YES];
		[zxing_vc cancelled];
		[self scan_cardio];
	}
}


- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
	NSLog(@"User canceled payment info");
	// Handle user cancellation.
	// Dismiss the paymentViewController
	current_camera_screen_num = 0;
	[self.btn_scan_toggle setSelected:NO];
	[[UIApplication sharedApplication] setStatusBarHidden:NO];
	[paymentViewController dismissModalViewControllerAnimated:NO];
}

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
	NSLog(@"Got payment info. Number: %@, expiry: %02i/%i, cvv: %@.", info.cardNumber, info.expiryMonth, info.expiryYear, info.cvv);
	// Process the payment using your merchant account and payment gateway.
	// Dismiss the paymentViewController
	current_camera_screen_num = 0;
	[self.btn_scan_toggle setSelected:NO];
	[[UIApplication sharedApplication] setStatusBarHidden:NO];
	[paymentViewController dismissModalViewControllerAnimated:NO];
}

@end
