//
//  HowToViewController.h
//  Cashbury
//
//  Created by Basayel Said on 5/17/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KZPlace.h"
#import "KZReward.h"

@interface HowToViewController : UIViewController {

}

@property (nonatomic, retain) IBOutlet UIView *how_to_earn_view;
@property (nonatomic, retain) IBOutlet UIView *how_to_snap_view;
@property (nonatomic, retain) KZReward *reward;
@property (nonatomic, retain) IBOutlet UITextView *txt_how_to_earn;
@property (nonatomic, retain) IBOutlet UIButton *place_btn;
@property (nonatomic, retain) IBOutlet UIButton *other_btn;

- (id) initWithReward:(KZReward*)_reward;
- (void) showHowToSnap;
- (void) showHowToEarnPoints;
- (IBAction)didTapBackButton:(id)theSender;
- (IBAction)goBacktoPlaces:(id)theSender;

@end
