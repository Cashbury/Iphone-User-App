//
//  MainScreenViewController.h
//  Cashbury
//
//  Created by Basayel Said on 3/15/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ZXingWidgetController.h>

@interface MainScreenViewController : UIViewController <ZXingDelegate> {

}
- (IBAction) snap_action:(id) sender;

- (IBAction) places_action:(id) sender;

- (void) logout_action:(id)sender;

@end
