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

@interface KZCardsAtPlacesViewController : UIViewController <UIScrollViewDelegate, KZPlacesLibraryDelegate>

- (IBAction) didSlide:(id)sender;
- (IBAction) didTapOnCard:(id)sender;
- (IBAction) didTapPlaces:(id)sender;
- (IBAction) didTapSnap:(id)sender;
- (IBAction) didTapProfile:(id)sender;
- (IBAction) didTapNotifications:(id)sender;


@end