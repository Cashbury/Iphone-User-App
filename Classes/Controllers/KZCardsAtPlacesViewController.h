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

@interface KZCardsAtPlacesViewController : UIViewController <KZPlacesLibraryDelegate, CBMagnifiableViewControllerDelegate>
{
    @private
    BOOL frontCardIsAbove;
}

@property (nonatomic, retain) IBOutlet UIView *cardContainer;
@property (nonatomic, retain) IBOutlet UIView *frontCard;
@property (nonatomic, retain) IBOutlet UIView *backCard;

@property (nonatomic, retain) IBOutlet UILabel *facebookName;
@property (nonatomic, retain) IBOutlet UILabel *facebookID;
@property (nonatomic, retain) IBOutlet UIImageView *profileImage;

- (IBAction) showQRCode:(id)sender;
- (IBAction) flipCard:(id)sender;
- (IBAction) didTapPlaces:(id)sender;
- (IBAction) didTapSnap:(id)sender;
- (IBAction) didTapProfile:(id)sender;
- (IBAction) didTapNotifications:(id)sender;


@end