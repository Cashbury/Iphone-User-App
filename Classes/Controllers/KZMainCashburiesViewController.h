//
//  KZMainCashburiesViewController.h
//  Cashbery
//
//  Created by Basayel Said on 7/14/11.
//  Copyright 2011 Cashbury. All rights reserved.
//
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
//#import "QRCodeReader.h"
#import "CXMLDocument.h"
#import "KZReloadableDelegate.h"


@interface KZMainCashburiesViewController : UIViewController 
<ScanHandlerDelegate, FaceBookWrapperPublishDelegate, UIScrollViewDelegate, KZPlaceViewDelegate, KZReloadableDelegate>
{
	KZURLRequest *redeem_request;
	int current_page_index;
	NSArray* arr_rewards;
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

//@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property (nonatomic, retain) IBOutlet UIView *view_gauge_popup;
@property (nonatomic, retain) NSMutableArray *viewControllers;
@property (nonatomic, retain) KZReward *current_reward;


- (IBAction) changePage:(id) sender;
- (IBAction) didTapSnapButton:(id)theSender;
- (IBAction) changePage:(id)sender;
- (IBAction) showGaugePopup:(id)sender;
- (IBAction) closeGaugePopup:(id)sender;
- (IBAction) showHowtoSnap:(id)sender;
- (IBAction) showHowtoEarnPoints:(id)sender;

- (id) initWithPlace:(KZPlace*)thePlace;
- (void) didTapSettingsButton:(id)theSender;

@end
