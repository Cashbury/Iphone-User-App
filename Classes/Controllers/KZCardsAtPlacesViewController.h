//
//  KZCardsAtPlacesViewController.h
//  Cashbery
//
//  Created by Basayel Said on 6/26/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KZPlace.h"

@interface KZCardsAtPlacesViewController : UIViewController {

}

@property (nonatomic, retain) IBOutlet UIView* view_card;
@property (nonatomic, retain) IBOutlet UIView* view_user_id_card;
@property (nonatomic, retain) IBOutlet UIImageView* img_user_id_card;
@property (nonatomic, retain) IBOutlet UILabel* lbl_title;

@property (nonatomic, retain) KZPlace* place;

- (id) initWithPlace:(KZPlace*)_place;

- (IBAction) didTapPlaces;
- (IBAction) didTapSnap;
- (IBAction) didTapUseCard;

@end
