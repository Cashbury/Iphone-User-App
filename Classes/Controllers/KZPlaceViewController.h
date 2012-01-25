//
//  KZPlaceViewController.h
//  Kazdoor
//
//  Created by Rami on 13/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KZPlace.h"
#import "KZApplication.h"
#import "KZReward.h"
#import "KZStampView.h"
#import "FacebookWrapper.h"
#import "KZRewardViewController.h"
#import "CocoaQRCodeReader.h"
#import "CXMLDocument.h"
#import "KZReloadableDelegate.h"
#import "CBMagnifiableViewController.h"


@interface KZPlaceViewController : CBMagnifiableViewController 
<ScanHandlerDelegate, FaceBookWrapperPublishDelegate, UIScrollViewDelegate, KZPlaceViewDelegate, KZReloadableDelegate>
{
	KZURLRequest *redeem_request;
	BOOL is_menu_open;
	int current_page_index;
}
// Toolbar
@property (nonatomic, retain) IBOutlet UIButton *place_btn;
@property (nonatomic, retain) IBOutlet UIButton *other_btn;
- (IBAction) didTapInfoButton:(id)theSender;
- (IBAction) goBack:(id)theSender;


@property (nonatomic, retain) IBOutlet UIScrollView *verticalScrollView;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UILabel *lbl_earned_points;
@property (nonatomic, retain) IBOutlet UIButton *btn_snap_enjoy;
@property (nonatomic, retain) IBOutlet UIButton *btn_close;
@property (nonatomic, retain) IBOutlet UIView *menu;
@property (nonatomic, retain) IBOutlet UIImageView *menu_c;
@property (nonatomic, retain) IBOutlet UIImageView *menu_eject;

//@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property (nonatomic, retain) IBOutlet UIView *view_gauge_popup;
@property (nonatomic, retain) NSMutableArray *viewControllers;
@property (nonatomic, retain) KZPlace *place;
@property (nonatomic, retain) KZReward *current_reward;


- (IBAction) changePage:(id) sender;
- (IBAction) didTapSnapButton:(id)theSender;
- (IBAction) changePage:(id)sender;
- (IBAction) showGaugePopup:(id)sender;
- (IBAction) closeGaugePopup:(id)sender;
- (IBAction) showHowtoSnap:(id)sender;
- (IBAction) showHowtoEarnPoints:(id)sender;
- (IBAction) openCloseMenu;

- (id) initWithPlace:(KZPlace*)thePlace;


@end
