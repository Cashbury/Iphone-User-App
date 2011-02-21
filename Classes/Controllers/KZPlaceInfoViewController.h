//
//  KZPlaceInfoViewController.h
//  Kazdoor
//
//  Created by Rami on 11/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KZPlace.h"

@interface KZPlaceInfoViewController : UIViewController
{
    KZPlace *place;
}

@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *streetLabel;
@property (nonatomic, retain) IBOutlet UILabel *addressLabel;
@property (nonatomic, retain) IBOutlet UINavigationItem *navItem;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil place:(KZPlace *)thePlace;

- (IBAction)didTapBackButton:(id)theSender;

@end
