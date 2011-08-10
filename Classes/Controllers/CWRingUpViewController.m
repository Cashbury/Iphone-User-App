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

@implementation CWRingUpViewController

@synthesize items_scroll_view, txt_amount, img_user, lbl_item_counter,  img_item_image, lbl_item_name, current_item, business, items, selected_items_and_quantities, view_item_counter;
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.selected_items_and_quantities = [[[NSMutableDictionary alloc] init] autorelease];
	[CWItemEngagement getItemsHavingEngagementsForBusiness:[self.business.identifier intValue] 
											   andDelegate:self];
	[self performSelectorInBackground:@selector(showBrandLogo) withObject:nil];
}

- (void) showBrandLogo {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	[self.img_user setImage:
			[UIImage imageWithData:
					[NSData dataWithContentsOfURL:
							[NSURL URLWithString:
									[KZUserInfo shared].cashier_business.image_url]]]]; 
	self.img_user.layer.masksToBounds = YES;
	self.img_user.layer.cornerRadius = 5.0;
	self.img_user.layer.borderWidth = 2.0;
	self.img_user.layer.borderColor = [UIColor lightGrayColor].CGColor;
	[pool release];
}
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void) viewWillAppear:(BOOL)animated {
	[self.txt_amount becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	if ([string isEqual:@""]) {
		if (text_field_text == nil || [text_field_text isEqual:@""]) return NO;
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
		[str appendString:@"$0."];
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
	textField.text = str;
	return NO;
}

- (void)viewDidUnload {
    [super viewDidUnload];
	self.selected_items_and_quantities = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
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
		f.origin.y = 1;
		f.origin.x = ((img.size.width + 4) * i) + 2;
		f.size.width = img.size.width;
		f.size.height = img.size.height;
		
		UIButton *btn = [[UIButton alloc] initWithFrame:f];
		[btn setTag:item.engagement_id];
		[btn addTarget:self action:@selector(selectItemAction:) forControlEvents:UIControlEventTouchUpInside];
		btn.frame = f;
		btn.layer.masksToBounds = YES;
		btn.layer.cornerRadius = 5.0;
		btn.layer.borderWidth = 2.0;
		btn.layer.borderColor = [UIColor whiteColor].CGColor;
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

- (IBAction) okAction {
	// Can and send the ring up amount
	zxing_vc = [KZSnapController snapWithDelegate:self andShowCancel:YES];
	[zxing_vc retain];
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
		self.business = [KZBusiness getBusinessWithIdentifier:_business_id andName:nil andImageURL:nil];
		text_field_text = [[NSMutableString alloc] init];
		str = nil;
	}
	return self;
}

- (void) didSnapCode:(NSString*)_code {
	NSLog(_code);
	[zxing_vc dismissModalViewControllerAnimated:NO];
	[zxing_vc release];
	float amount = [[str substringWithRange:NSMakeRange(1, [str length]-1)] floatValue];

	NSMutableString* params = [[NSMutableString alloc] init];
	[params appendFormat:@"auth_token=%@", [KZUserInfo shared].auth_token];
	[params appendFormat:@"&amount=%0.2lf", amount];
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
	ringup_req = [[KZURLRequest alloc] initRequestWithString:[NSString stringWithFormat:@"%@/users/cashiers/ring_up.xml", API_URL] 
												   andParams:params 
													delegate:self 
													 headers:_headers 
										   andLoadingMessage:@"Sending..."];
	[params release];
	
	
}

- (void) didCancelledSnapping {
	///////FIXME XXXXXXXXXXXXXXXXXXX
		//[self didSnapCode:@"b25316d21feec55fc057"];
	/*
	NSLog(@"Cancelled");
	[zxing_vc dismissModalViewControllerAnimated:NO];
	[zxing_vc release];
	 */
}

- (void) KZURLRequest:(KZURLRequest *)theRequest didFailWithError:(NSError*)theError {
	NSLog(@"Got ERROR : %@", [theError localizedDescription]);
	[ringup_req release];
}

- (void) KZURLRequest:(KZURLRequest *)theRequest didSucceedWithData:(NSData*)theData {
	////////////TODO make sure that the error that comes from the server has the 500 status code to work successfully
	@try {	
		NSString* str = [[[NSString alloc] initWithData:theData encoding:NSUTF8StringEncoding] autorelease];

		CXMLDocument *_document = [[[CXMLDocument alloc] initWithData:theData options:0 error:nil] autorelease];
		NSLog(@"Got Rsponse : %@", [_document description]);
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
												   customer_image_url:[_node stringFromChildNamed:@"customer-image-url"]];
			[self presentModalViewController:rec animated:YES];
			[rec release];
			[text_field_text setString:@""];
			self.txt_amount.text = @"$0.00";
			[self clearItemsAction];
		}
		[ringup_req release];
	}@catch (NSException * e) {
		NSLog(@"Exception: %@", e);
	}
}

@end
