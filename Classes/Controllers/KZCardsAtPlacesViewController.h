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
#import "KZPlacesViewController.h"
#import "CBAsyncImageView.h"

@interface KZCardsAtPlacesViewController : UIViewController <KZPlacesLibraryDelegate, CBMagnifiableViewControllerDelegate>
{
    @private
    BOOL frontCardIsAbove;
}

@property (nonatomic, retain) IBOutlet UIView *cardContainer;
@property (nonatomic, retain) IBOutlet UIView *frontCard;
@property (nonatomic, retain) IBOutlet UIView *backCard;

@property (nonatomic, retain) IBOutlet UIImageView *frontCardBackground;
@property (nonatomic, retain) IBOutlet UILabel *customerName;
@property (nonatomic, retain) IBOutlet UILabel *userID;
@property (nonatomic, retain) IBOutlet CBAsyncImageView *profileImage;

@property (nonatomic, retain) IBOutlet UILabel *savingsBalance;

- (IBAction) showQRCode:(id)sender;
- (IBAction) flipCard:(id)sender;
- (IBAction) didTapPlaces:(id)sender;
- (IBAction) didTapSnap:(id)sender;
- (IBAction) didTapProfile:(id)sender;
- (IBAction) didTapNotifications:(id)sender;


@end