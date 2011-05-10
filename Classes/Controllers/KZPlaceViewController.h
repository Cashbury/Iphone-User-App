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

@interface KZPlaceViewController : UIViewController 
<ZXingDelegate, 
FaceBookWrapperPublishDelegate,
UIAlertViewDelegate, 
UIScrollViewDelegate>
{
    KZPointsLibrary *pointsArchive;
    NSUInteger earnedPoints;
    BOOL ready;
	KZPlace *place;

	// scroll View
	UIScrollView *scrollView;
	UIButton *place_btn;
	UIButton *other_btn;
	UIPageControl *pageControl;
	NSMutableArray *viewControllers;
	BOOL pageControlUsed;
	
}
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIButton *place_btn;
@property (nonatomic, retain) IBOutlet UIButton *other_btn;
@property (nonatomic, retain) NSMutableArray *viewControllers;
@property (nonatomic, retain) KZPlace *place;

- (IBAction) changePage:(id) sender;
- (IBAction) didTapInfoButton:(id)theSender;
- (IBAction) goBack:(id)theSender;
- (id) initWithPlace:(KZPlace*)thePlace;

@end
