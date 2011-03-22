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
	UIPageControl *pageControl;
	NSMutableArray *viewControllers;
	BOOL pageControlUsed;
	
}
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) NSMutableArray *viewControllers;
@property (nonatomic, retain) KZPlace *place;

- (IBAction) changePage:(id) sender;

- (id) initWithPlace:(KZPlace*)thePlace;

@end
