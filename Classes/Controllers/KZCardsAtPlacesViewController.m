    //
//  KZCardsAtPlacesViewController.m
//  Cashbery
//
//  Created by Basayel Said on 6/26/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import "KZCardsAtPlacesViewController.h"
#import "CXMLElement+Helpers.h"
#import "TouchXML.h"
#import "CBWalletSettingsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "KZSnapController.h"
#import "KZApplication.h"
#import "KZUserInfo.h"
#import "KZPlacesLibrary.h"
#import "KZReceiptController.h"
#import "KZUserIDCardViewController.h"
#import "KZBusiness.h"
#import "KZCardPanelViewController.h"
#import "CBCitySelectorViewController.h"
#import "KZCardAtPlaceCardViewController.h"

@interface KZCardsAtPlacesViewController (Private)
	- (KZBusiness*) currentBusiness;
	- (void) getFlagImage;
@end

@implementation KZCardsAtPlacesViewController

@synthesize place, pageControl, pageControl_for_buttons, scrollView, scrollView_for_buttons, lbl_score, cityLabel, btn_scroll_left, btn_scroll_right, img_flag;


- (id) initWithPlace:(KZPlace*)_place {
	if (self = [self initWithNibName:@"KZCardsAtPlaces" bundle:nil]) {
		self.place = _place;
	}
	return self;
}

- (void) didTapCityButton:(UIGestureRecognizer *)theRecognizer {
	[[KZApplication getAppDelegate].tool_bar_vc hideToolBar];
    CBCitySelectorViewController *_controller = [[CBCitySelectorViewController alloc] initWithNibName:@"CBCitySelectorView"
                                                                                               bundle:nil];
    
    CATransition *_transition = [CATransition animation];
    _transition.duration = 0.35;
    _transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    _transition.type = kCATransitionPush;
    _transition.subtype = kCATransitionFromBottom;
    
    [self.navigationController.view.layer addAnimation:_transition forKey:kCATransition];
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:_controller animated:NO];
    
    [_controller release];
}

- (void) didTapSettingsButton:(id)theSender {
	[[KZApplication getAppDelegate].tool_bar_vc hideToolBar];
    CBWalletSettingsViewController *_controller = [[CBWalletSettingsViewController alloc] initWithNibName:@"CBWalletSettingsView"
                                                                                                   bundle:nil];
    
    CATransition *_transition = [CATransition animation];
    _transition.duration = 0.35;
    _transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    _transition.type = kCATransitionMoveIn;
    _transition.subtype = kCATransitionFromBottom;
    
    [self.navigationController.view.layer addAnimation:_transition forKey:kCATransition];
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:_controller animated:NO];
    
    [_controller release];
}

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
	current_city_id = [KZCity getSelectedCityId];
	[current_city_id retain];
	
	self.scrollView.showsHorizontalScrollIndicator = NO;
	self.scrollView.showsVerticalScrollIndicator = NO;
	
	self.navigationController.navigationBar.tintColor = [UIColor blackColor];
	// these 3 lines
    UIButton *_settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _settingsButton.frame = CGRectMake(0, 0, 320, 44);
    [_settingsButton addTarget:self action:@selector(didTapSettingsButton:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = _settingsButton;
	
	[self.navigationItem setLeftBarButtonItem:[[[UIBarButtonItem alloc] initWithCustomView:[[UIView new] autorelease]] autorelease]];
	///////////////////////////
	
	// Set up city label
    self.cityLabel.indicatorImage = [UIImage imageNamed:@"image-dropdown.png"];    
    self.cityLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *_recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapCityButton:)];
    [self.cityLabel addGestureRecognizer:_recognizer];
    [_recognizer release];    
	
	//[self clearView];
	//[self populateView];
}

- (void) populateView {
	
	businesses = [KZPlacesLibrary getNearByBusinessesWithIDCards];
	[businesses retain];
	
	NSUInteger i, count = [businesses count];
	CGSize size = self.scrollView.frame.size;
	
	if (count > 0) {
		for (i = 0; i < count; i++) {
			KZBusiness* biz = (KZBusiness*)[businesses objectAtIndex:i];
			if (self.place != nil && self.place.business.has_user_id_card == YES) {
				if (biz.identifier == self.place.business.identifier) {
					business_index = i;
				}
			}
			KZCardAtPlaceCardViewController* vc = [[KZCardAtPlaceCardViewController alloc] initWithBusiness:biz];
			[arr_cards_vcs addObject:vc];
			
			UIView* card = vc.view;
			CGRect f = card.frame;
			f.origin.x = i * self.scrollView.frame.size.width;
			card.frame = f;
			[self.scrollView addSubview:card];
			[vc release];
		}
		if (business_index > 0) {
			[self pageControlChangedPage:nil];
		}
		size.width = size.width * count;
		size.width++;
		if (count > 1) {
			self.pageControl.numberOfPages = count;
			[self.pageControl setHidden:NO];
		} else {
			[self.pageControl setHidden:YES];
		}
		if (business_index < 0) business_index = 0; 
	} else {
		size.width++;
		//[self.scrollView addSubview:self.view_card];
	}
	self.scrollView.contentSize = size;
	///////////////////////////
	
}

- (void) clearView {
	
	for (KZCardAtPlaceCardViewController* _vc in arr_cards_vcs) {
		[_vc.view removeFromSuperview];
	}
	[arr_cards_vcs release];
	arr_cards_vcs = [[NSMutableArray alloc] init];
	
	[businesses release];
	businesses = nil;
	business_index = -1;
	
	
		
}

- (void) viewWillAppear:(BOOL)animated {
	NSLog(@"RELOAD..................");
	[super viewWillAppear:animated];
	
	if ([current_city_id isEqual:[KZCity getSelectedCityId]] == NO) {
		NSLog(@"%@ --------> not the same city.", current_city_id);
		[KZPlacesLibrary shared].delegate = self;
		[[KZPlacesLibrary shared] requestPlacesWithKeywords:nil];
	} else {
		[self clearView];
		[self populateView];
	}
	
	
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	[self.navigationController setToolbarHidden:YES];
	[[KZApplication getAppDelegate].tool_bar_vc showToolBar:self.navigationController];
	[self setCurrentCard:business_index];
	self.cityLabel.text = [KZCity getSelectedCityName]; 
	
	[self performSelectorInBackground:@selector(getFlagImage) withObject:nil];
	//[self performSelector:@selector(getFlagImage) withObject:nil afterDelay:1.0];
}

- (void) didUpdatePlaces{
	[current_city_id release];
	current_city_id = [KZCity getSelectedCityId];
	[current_city_id retain];
	[self clearView];
	[KZApplication hideLoading];
	[self populateView];
}

- (void) didFailUpdatePlaces{
	[KZApplication hideLoading];
}

- (void) getFlagImage {
	NSAutoreleasePool *thePool = [[NSAutoreleasePool alloc] init];
	NSURL* flag_url = [KZCity getCityFlagUrlByCityId:[KZCity getSelectedCityId]];
	UIImage* img = [UIImage imageWithData:[NSData dataWithContentsOfURL:flag_url]];
	if (img != nil) [self.img_flag setImage:img];
	[thePool release];
}

- (void)dealloc {
	[businesses release];
	[current_city_id release];
	[arr_cards_vcs release];
    [super dealloc];
}



- (IBAction) didTapUseCard {
	KZUserIDCardViewController* user_id_card = [[KZUserIDCardViewController alloc] initWithBusiness:[self currentBusiness]];
	user_id_card.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[[KZApplication getAppDelegate].navigationController presentModalViewController:user_id_card animated:YES];
	[user_id_card release];
	
	/*
	if (self.place == nil || self.place.business.has_user_id_card == NO) return; 
	UIView* super_view = nil;
	if (self.view_user_id_card.superview == nil) {
		super_view = self.view_card.superview;
		self.view_user_id_card.frame = self.view_card.frame;
	} else {
		super_view = self.view_user_id_card.superview;
		self.view_card.frame = self.view_user_id_card.frame;
	}
	//////////TODO animation
//	[UIView  beginAnimations:@"show_card" context: nil];
//	[UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
//	[UIView setAnimationDuration:0.75];
	if (self.view_user_id_card.superview == nil) {
//		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view_user_id_card cache:YES];
		
		//[self.view_card removeFromSuperview];
		[super_view insertSubview:self.view_user_id_card aboveSubview:self.view_card];
		//NSLog(@"Sending REQUEST TO : %@", [NSString stringWithFormat:@"%@/users/%@/get_id.xml?auth_token=%@", API_URL, self.place.business.identifier, [KZUserInfo shared].auth_token]);
		
		/////// Show the QR Code
		NSMutableDictionary *_headers = [[NSMutableDictionary alloc] init];
		[_headers setValue:@"application/xml" forKey:@"Accept"];
		KZURLRequest* req = [[KZURLRequest alloc] initRequestWithString:[NSString stringWithFormat:@"%@/users/%@/get_id.xml?auth_token=%@", API_URL, self.place.business.identifier, [KZUserInfo shared].auth_token] 
															  andParams:nil 
															   delegate:self 
																headers:_headers 
													  andLoadingMessage:nil];
		[_headers release];
		 
	} else {
//		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view_user_id_card cache:YES];
		[self.view_user_id_card removeFromSuperview];
		//[super_view insertSubview:self.view_card aboveSubview:self.view_user_id_card];
		////////////FIXME tttttttttttttttt
		//[[KZPlacesLibrary shared] requestPlacesWithKeywords:nil];
		[KZReceiptController getAndShowAllReceipts:self];
	}
	
//	[UIView commitAnimations];
	*/
}

/*
- (void) KZURLRequest:(KZURLRequest *)theRequest didFailWithError:(NSError*)theError {
	//NSLog(@"An Error has occured when requesting the User ID QRCode");
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Sorry a server error has occurred while getting your ID. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alert show];
	[alert release];

	[theRequest release];
}

- (void) KZURLRequest:(KZURLRequest *)theRequest didSucceedWithData:(NSData*)theData {
	CXMLDocument *_document = [[[CXMLDocument alloc] initWithData:theData options:0 error:nil] autorelease];
	NSLog([_document description]);
	CXMLElement* _image_node = [_document nodeForXPath:@"/hash/user-id-image-url" error:nil];
	CXMLElement* _timer_node = [_document nodeForXPath:@"/hash/starting-timer-seconds" error:nil];
	NSString* qr_code_image_url = [_image_node stringValue];
	int timer_seconds = [[_timer_node stringValue] intValue];
	[KZApplication showLoadingScreen:@"Generating..."];
	UIImage* img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:qr_code_image_url]]];
	[self.img_user_id_card setImage:img];
	[KZApplication hideLoading];
	[theRequest release];
}
 */
 
- (void) setCurrentCard:(NSUInteger)_index {
	if (_index < 0) return;
	if (businesses == nil) return;
	
	business_index = _index;
	self.pageControl.currentPage = _index;
	KZBusiness* biz = [self currentBusiness];
	float score = [biz getScore];
	NSString* currency_code = [biz getCurrencyCode];
	self.lbl_score.text = (currency_code != nil ? [NSString stringWithFormat:@"Balance: %@%0.0lf", currency_code, score] : @"");
}

- (KZBusiness*) currentBusiness {
	if (businesses == nil) return nil;
	if (business_index < 0) return nil;
	return (KZBusiness*)[businesses objectAtIndex:business_index];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView {
	CGFloat pageWidth = self.scrollView.frame.size.width;
	int page = floor((self.scrollView.contentOffset.x - pageWidth / 2.0) / pageWidth) + 1;
	[self setCurrentCard:page];
}

- (IBAction) pageControlChangedPage:(id)_sender {
	if (_sender == self.pageControl) {
		[self setCurrentCard:self.pageControl.currentPage];
		CGRect frame = self.scrollView.frame;
		frame.origin.x = frame.size.width * self.pageControl.currentPage;
		frame.origin.y = 0;
		[self setCurrentCard:self.pageControl.currentPage];
		[self.scrollView scrollRectToVisible:frame animated:YES];	
	} else {
		[self setCurrentCard:self.pageControl_for_buttons.currentPage];
		CGRect frame = self.scrollView_for_buttons.frame;
		frame.origin.x = frame.size.width * self.pageControl_for_buttons.currentPage;
		frame.origin.y = 0;
		[self setCurrentCard:self.pageControl_for_buttons.currentPage];
		[self.scrollView_for_buttons scrollRectToVisible:frame animated:YES];
	}
} 
 


- (IBAction) didTapScrollButtonsToRight {
	NSLog(@"RIGHT....");
}

- (IBAction) didTapScrollButtonsToLeft {
	NSLog(@"LEFT....");
}


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 
 
 - (void)didReceiveMemoryWarning {
 // Releases the view if it doesn't have a superview.
 [super didReceiveMemoryWarning];
 
 // Release any cached data, images, etc that aren't in use.
 }
 
 - (void)viewDidUnload {
 [super viewDidUnload];
 // Release any retained subviews of the main view.
 // e.g. self.myOutlet = nil;
 }
 */


@end
