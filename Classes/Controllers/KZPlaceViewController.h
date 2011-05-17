//
//  KZPlaceViewController.h
//  Kazdoor
//
//  Created by Rami on 13/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KZPlace.h"
#import <ZXingWidgetController.h>
#import "KZApplication.h"
#import "KZReward.h"
#import "KZStampView.h"
#import "FacebookWrapper.h"
#import "KZRewardViewController.h"
#import "QRCodeReader.h"
#import "CXMLDocument.h"


@interface KZPlaceViewController : UIViewController 
<ZXingDelegate, UIAlertViewDelegate, KZURLRequestDelegate, ScanHandlerDelegate, 
FaceBookWrapperPublishDelegate, UIScrollViewDelegate, KZRewardViewDelegate, KZPlaceViewDelegate>
{
	KZURLRequest *redeem_request;
}
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

@property (nonatomic, retain) IBOutlet UILabel *lbl_earned_points;
@property (nonatomic, retain) IBOutlet UIButton *btn_snap_enjoy;

// Toolbar
@property (nonatomic, retain) IBOutlet UIButton *place_btn;
@property (nonatomic, retain) IBOutlet UIButton *other_btn;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;

@property (nonatomic, retain) NSMutableArray *viewControllers;
@property (nonatomic, retain) KZPlace *place;
@property (nonatomic, retain) KZReward *current_reward;

- (IBAction) changePage:(id) sender;
- (IBAction) didTapInfoButton:(id)theSender;
- (IBAction) didTapSnapButton:(id)theSender;
- (IBAction) goBack:(id)theSender;
- (IBAction)changePage:(id)sender;

- (id) initWithPlace:(KZPlace*)thePlace;

@end
