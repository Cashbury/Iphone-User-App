//
//  PlacesTableCellViewController.h
//  Cashbery
//
//  Created by Basayel Said on 3/22/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PlacesTableCellViewController : UIViewController {
	IBOutlet UIImageView *imgReward;
}

@property (nonatomic, retain) IBOutlet UIImageView *imgReward;

- (void) setRewardIndicatorEnabled:(BOOL)enabled;

@end
