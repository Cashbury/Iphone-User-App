//
//  KZCardsAtPlacesViewController.h
//  Cashbery
//
//  Created by Basayel Said on 6/26/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KZPlace.h"
#import "CBDropDownLabel.h"
#import "KZPlacesLibrary.h"

@interface KZCardsAtPlacesViewController : UIViewController <UIScrollViewDelegate, KZPlacesLibraryDelegate> {
	NSArray* businesses;
	NSMutableArray* arr_cards_vcs;
	NSUInteger business_index;
	NSString* current_city_id;
}

@property (nonatomic, retain) IBOutlet UIPageControl* pageControl;
@property (nonatomic, retain) IBOutlet UIPageControl* pageControl_for_buttons;
@property (nonatomic, retain) IBOutlet UIScrollView* scrollView;
@property (nonatomic, retain) IBOutlet UIScrollView* scrollView_for_buttons;
@property (nonatomic, retain) IBOutlet UILabel* lbl_score;

@property (nonatomic, retain) IBOutlet CBDropDownLabel* cityLabel;
@property (nonatomic, retain) IBOutlet UIImageView* img_flag;
@property (nonatomic, retain) IBOutlet UIButton* btn_scroll_left;
@property (nonatomic, retain) IBOutlet UIButton* btn_scroll_right;
 
@property (nonatomic, retain) KZPlace* place;

- (id) initWithPlace:(KZPlace*)_place;

- (IBAction) didTapScrollButtonsToRight;
- (IBAction) didTapScrollButtonsToLeft;
- (IBAction) didTapSnap;
- (IBAction) didTapUseCard;
- (IBAction) pageControlChangedPage:(id)_sender;


@end
