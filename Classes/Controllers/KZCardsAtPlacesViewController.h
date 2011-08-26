//
//  KZCardsAtPlacesViewController.h
//  Cashbery
//
//  Created by Basayel Said on 6/26/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KZPlace.h"

@interface KZCardsAtPlacesViewController : UIViewController <UIScrollViewDelegate> {
	NSArray* businesses;
	NSUInteger business_index;
}

@property (nonatomic, retain) IBOutlet UIPageControl* pageControl;
@property (nonatomic, retain) IBOutlet UIScrollView* scrollView;
@property (nonatomic, retain) IBOutlet UIView* view_card;
@property (nonatomic, retain) IBOutlet UILabel* lbl_title;
@property (nonatomic, retain) IBOutlet UILabel* lbl_score;
@property (nonatomic, retain) IBOutlet UIButton* btn_receipts;

@property (nonatomic, retain) KZPlace* place;

- (id) initWithPlace:(KZPlace*)_place;

- (IBAction) didTapPlaces;
- (IBAction) didTapSnap;
- (IBAction) didTapUseCard;
- (IBAction) pageControlChangedPage:(id)_sender;
- (IBAction) didTapReceipts;

@end
